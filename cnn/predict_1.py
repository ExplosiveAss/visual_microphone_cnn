import os
import torch
from torch import nn

import cv2
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
import time
import scipy.io.wavfile as wav
from torch._C import dtype

from model import SpeechDetector

sosbs1 = signal.butter(2, [119, 121], btype="bandstop", output="sos", fs=2200)
sosbs2 = signal.butter(2, [239, 241], btype="bandstop", output="sos", fs=2200)
sosbp1 = signal.butter(5, [150, 450], btype="bandpass", output="sos", fs=2200)
# soshp = signal.butter(5, 150, btype="highpass", output="sos", fs=2200)
soslp = signal.butter(5, 1100, btype="lowpass", output="sos", fs=8000)

device = "cuda" if torch.cuda.is_available() else "cpu"
model = SpeechDetector().to(device)
model.load_state_dict(torch.load("saved_models/noise_detection_208.pth"))
model.eval()

video = "video_1"
filename = "../Chips2-2200Hz-Mary_MIDI-input.avi"

numrows = 400
numcols = 704
rowstep = 25

scores = np.zeros((numrows, numcols))
starttime = time.perf_counter()
for row in range(0, int(round(numrows/rowstep))):
    cap = cv2.VideoCapture(filename)
    totnumframes = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    fourcc = int(cap.get(cv2.CAP_PROP_FOURCC))
    framerate = float(cap.get(cv2.CAP_PROP_FPS))
    framewidth = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    frameheight = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

    pixels = np.zeros((rowstep, numcols, totnumframes))

    count = 0

    while cap.isOpened():
        retval, frame = cap.read()

        if not retval:
            break

        frame = frame[row * rowstep :row * rowstep + rowstep, :, :]
        frame = frame.mean(axis = 2)

        pixels[:, :, count] = frame

        if count & 1023 == 1023:
            currenttime = time.perf_counter()
            elapsedtime = currenttime - starttime
            est_time_remaining = elapsedtime / count * (totnumframes - count) * (numrows/rowstep - row)
            est_days_remaining = int( est_time_remaining / (60*60*24) )
            est_hrs_remaining = int(( est_time_remaining - est_days_remaining*(60*60*24) ) / (60*60))
            est_mins_remaining = int(( est_time_remaining - est_days_remaining*(60*60*24) - est_hrs_remaining*(60*60) ) / (60))
            est_secs_remaining = int( est_time_remaining - est_days_remaining*(60*60*24) - est_hrs_remaining*(60*60) - est_mins_remaining*(60) )
            print(f"video 1 Rowstep number {row}, Progress: {count}/{totnumframes} frames done, {elapsedtime:.2f} secs elapsed\nestimated {est_days_remaining} days {est_hrs_remaining} hrs {est_mins_remaining} mins {est_secs_remaining} secs left\n")
        count += 1

    currenttime = time.perf_counter()
    elapsedtime = currenttime - starttime
    print(f"elapsed time = {elapsedtime}")

    starttime = time.perf_counter()
    for step in range(rowstep):
        for col in range(numcols):
            sig = pixels[step, col, :]
            sig = sig - sig.mean()
            sig = sig / np.max(np.abs(sig))
            sig = signal.sosfilt(sosbs1, sig)
            sig = signal.sosfilt(sosbs2, sig)
            sig = signal.sosfilt(sosbp1, sig)
            # sig = signal.sosfilt(soshp, sig)
            sig = sig - sig.mean()
            sig = sig / np.max(np.abs(sig))


            sig = signal.resample(sig, int(round(len(sig) * 8000 / 2200)), window="hamming")
            sig = signal.sosfilt(soslp, sig)
            sig = sig - sig.mean()
            sig = sig / np.max(np.abs(sig))

            sigtensor = torch.tensor(sig, dtype=torch.float)
            sigtensor = sigtensor.reshape((1, -1))
            sigtensor = sigtensor.to(device)

            predscore = model(sigtensor)

            scores[row * rowstep + step, col] = predscore.item()

        currenttime = time.perf_counter()
        elapsedtime = currenttime - starttime
        est_time_remaining = elapsedtime / (step + 1) * (rowstep - step)
        est_days_remaining = int( est_time_remaining / (60*60*24) )
        est_hrs_remaining = int(( est_time_remaining - est_days_remaining*(60*60*24) ) / (60*60))
        est_mins_remaining = int(( est_time_remaining - est_days_remaining*(60*60*24) - est_hrs_remaining*(60*60) ) / (60))
        est_secs_remaining = int( est_time_remaining - est_days_remaining*(60*60*24) - est_hrs_remaining*(60*60) - est_mins_remaining*(60) )
        print(f"video 1 Rowstep number {row}, AI Progress: {step}/{rowstep} frames done, {elapsedtime:.2f} secs elapsed\nestimated {est_days_remaining} days {est_hrs_remaining} hrs {est_mins_remaining} mins {est_secs_remaining} secs left\n")


    np.save("video_1_scores.npy", scores)

    cap.release()



np.save("video_1_scores.npy", scores)




img = scores
img = img - img.min()
img = img / img.max()
img = img * 255
img = np.around(img).astype(np.uint8)
img = img.reshape(numrows, numcols, 1)
cv2.imwrite("video_1_quality_log_scale.png", img)

img = scores
img = np.power(10, img / 20)
img = img - img.min()
img = img / img.max()
img = img * 255
img = np.around(img).astype(np.uint8)
img = img.reshape(numrows, numcols, 1)
cv2.imwrite("video_1_quality_normal_scale.png", img)