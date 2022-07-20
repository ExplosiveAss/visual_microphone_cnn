import pickle
from torch._C import dtype
import torch.nn
from torch.utils.data import Dataset
import scipy.io.wavfile as wav
import numpy as np
import os


def read_and_concatenate(dir, fs):
    # print(f"loading {dir}")
    try:
        os.chdir(os.path.join(dir, "wav"))
        fullsig = []
        for file in os.listdir():
            fsf, sig  = wav.read(file)
            if fsf == fs:
                fullsig.append(sig)

        if len(fullsig) == 0:
            raise Exception(f"{dir} got problem")

        fullsig = np.concatenate(fullsig)

    finally:
        os.chdir(os.path.join("..", ".."))
    return fullsig

class VoxforgeDataset(Dataset):
    def __init__(self, filepath, mode, split_at = 0.7, fs = 8000):
        self.filepath = filepath
        sounds_file = os.path.join(filepath, "sounds.pickle")
        powers_file = os.path.join(filepath, "powers.pickle")
        self.fs = fs


        if os.path.isfile(sounds_file):
            self.sounds = pickle.load(open(sounds_file, "rb"))
        else:
            development_set = "..\\voxforge"
            current_dir = os.getcwd()
            os.chdir(development_set)
            self.sounds = [read_and_concatenate(ddd, fs) for ddd in os.listdir()]
            os.chdir(current_dir)
            pickle.dump(self.sounds, open(sounds_file, "wb"))


        for ii in range(len(self.sounds)):
            self.sounds[ii] = torch.tensor(self.sounds[ii], dtype = torch.float)
            self.sounds[ii] = self.sounds[ii] - self.sounds[ii].mean()
            self.sounds[ii] = self.sounds[ii] / torch.max(torch.abs(self.sounds[ii]))

        if os.path.isfile(powers_file):
            self.powers = pickle.load(open(powers_file, "rb"))
        else:
            self.powers = torch.zeros(len(self.sounds), dtype = torch.float)
            for ii in range(len(self.sounds)):
                self.powers[ii] = self.sounds[ii].var()
            pickle.dump(self.powers, open(powers_file, "wb"))
        

        split_at = int(round(len(self.sounds) * split_at))
        if mode == "train":
            self.sounds = self.sounds[:split_at]
            self.powers = self.powers[:split_at]
        else:
            self.sounds = self.sounds[split_at:]
            self.powers = self.powers[split_at:]

    def __str__(self):
        return f"Dateset of length={len(self.sounds)} from {self.filepath}"

    def __repr__(self):
        return f"Dateset of length={len(self.sounds)} from {self.filepath}"

    def __len__(self):
        return len(self.sounds)

    def __getitem__(self, index):
        with torch.no_grad():
                
            sig = self.sounds[index]
            sigpow = self.powers[index]

            # snr = torch.rand(1, dtype = torch.float).item() * 10 # SNR range from 0 to 10 # version 1, 2, 3
            snrdb = torch.rand(1, dtype = torch.float) * 80.0 - 40.0 # SNR range from -40 dB to 40 dB # version 4
            snr = torch.pow(torch.tensor(10.0, dtype = torch.float), snrdb / 20.0)
            noisepow = sigpow / snr

            noise = self.generate_noise(noisepow, len(sig))
            noisysig = sig + noise
            noisysig = noisysig - noisysig.mean()
            noisysig = noisysig / torch.max(torch.abs(noisysig))



        # return noisysig, torch.tensor(snr, dtype=torch.float) # version 1, 2, 3
        return noisysig, snrdb # version 4

    def generate_noise(self, pow, length):
        # noise = torch.normal(0.0, torch.sqrt(pow), size = (length, )) #version 1, 2, 3
        noise = torch.normal(0.0, torch.sqrt(pow).item(), size = (length, )) # version 4
        return noise


