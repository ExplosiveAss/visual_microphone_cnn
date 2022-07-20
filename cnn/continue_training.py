import os
import torch

import pickle
from dataloaders import VoxforgeDataset
import torch
from torch import nn
from torch.utils.data import Dataset, DataLoader
from torchvision.transforms import ToTensor, Lambda, Compose
import cv2
import matplotlib.pyplot as plt
import matplotlib.animation as animation 



import sys

import logging


logging.basicConfig(format="[%(asctime)s][%(levelname)s] - %(message)s", level=logging.DEBUG, handlers=[logging.StreamHandler(sys.stdout), logging.FileHandler(filename=f"logs.txt", mode="a")])

# Get cpu or gpu device for training.
device = "cuda" if torch.cuda.is_available() else "cpu"
logging.info("Using {} device".format(device))


batch_size = 1



train_dataset = VoxforgeDataset(".", mode="train")
test_dataset = VoxforgeDataset(".", mode="test")
fs = 8000


train_dataloader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
test_dataloader = DataLoader(test_dataset, batch_size=batch_size, shuffle=True)



from model import SpeechDetector

ttt = 164
model = SpeechDetector().to(device)
model.load_state_dict(torch.load(f"saved_models/noise_detection_{ttt-1}.pth"))


loss_fn = nn.MSELoss()
optimizer = torch.optim.SGD(model.parameters(), lr=0.000001, momentum=0.6, weight_decay=0.3, dampening=0.9)
scheduler = torch.optim.lr_scheduler.ExponentialLR(optimizer, gamma=0.8)


epochs = 1001
losses = pickle.load(open("losses.pickle", "rb"))


while ttt <= epochs:

    try:

        logging.info(f"Epoch {ttt+1}\n-------------------------------")
        
        # Training start
        size = len(train_dataloader.dataset)
        model.train()
        optimizer.zero_grad()
        loss_list = []
        for batch, (X, y) in enumerate(train_dataloader):
            X, y = X.to(device), y.to(device)
            # y = y.view(-1, 1)

            # Compute prediction error
            pred = model(X)
            loss = loss_fn(pred, y)

            # Backpropagation
            
            loss.backward()
            

            loss_list.append(loss.item())

            if not loss_list[-1] == loss_list[-1]:
                logging.exception(f"batch {batch}")
                raise Exception(f"NAN!!!")


            if batch % 10 == 0:
                optimizer.step()
                optimizer.zero_grad()

                avg_loss = sum(loss_list) / len(loss_list)
                logging.info(f"avg_loss: {avg_loss}  [{batch:>5d}/{size:>5d}]")
                loss_list = []

        
        optimizer.step()
        optimizer.zero_grad()
        loss = sum(loss_list) / len(loss_list)
        logging.info(f"avg_loss: {avg_loss}  [{size:>5d}/{size:>5d}]")
        # Training end

        # Testing start
        size = len(test_dataloader.dataset)
        logging.info(f"size = {size}")
        num_batches = len(test_dataloader)
        model.eval()
        test_loss = 0
        with torch.no_grad():
            for X, y in test_dataloader:
                X, y = X.to(device), y.to(device)
                # y = y.view(-1, 1)
                pred = model(X)
                test_loss += loss_fn(pred, y).item()
        test_loss /= num_batches
        logging.info(f"Avg loss: {test_loss:>8f} \n")
        # Testing end


        losses.append(test_loss)
        # if ttt % 10 == 0:
        torch.save(model.state_dict(), f"saved_models/noise_detection_{ttt}.pth")

    except Exception as e:
        if ttt == 0:
            raise Exception("GG. We're screwed.")
        model.load_state_dict(torch.load(f"saved_models/noise_detection_{ttt-1}.pth"))
        scheduler.step()
    else:
        ttt = ttt + 1


logging.info("Done!")
logging.info(losses)
pickle.dump(losses, open("losses.pickle", "wb"))
plt.plot(losses)
plt.title("test loss vs train epoch")
plt.ylabel("test loss (MSError)")
plt.xlabel("epoch")
plt.show()