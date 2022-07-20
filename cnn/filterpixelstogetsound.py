import numpy as np
import matplotlib.pyplot as plt
import cv2
import time
from scipy.io import savemat


videos = ["../Chips2-2200Hz-Mary_MIDI-input.avi", "../Plant-2200Hz-Mary_MIDI-input.avi", "../Chips1-2200Hz-Mary_Had-input.avi", "../Chips1-20000Hz-Mary_Had-input.avi"]
scores = ["video_1_scores.npy", "video_2_scores.npy", "video_3_scores.npy", "video_4_scores.npy"]
vidnums = ["video_1", "video_2", "video_3", "video_4"]


percentiles = [1.750, 1.500, 1.250, 1.000, 0.750, 0.500, 0.250, 0.200, 0.150, 0.125, 0.100, 0.075, 0.050, 0.040, 0.030, 0.025, 0.020, 0.015, 0.010, 0.005]
quantiles = [1 - ii / 100 for ii in percentiles]


for scorefilename, vidfilename, vidnum in zip(scores, videos, vidnums):

    cap = cv2.VideoCapture(vidfilename)
    totnumframes = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    fourcc = int(cap.get(cv2.CAP_PROP_FOURCC))
    framerate = float(cap.get(cv2.CAP_PROP_FPS))
    framewidth = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    frameheight = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    

    score = np.load(scorefilename)

    idxess = []
    pixelss = []
    for percentile, quantile in zip(percentiles, quantiles):
        thresh = np.nanquantile(score, quantile)
        idxes = np.where(score >= thresh)
        pixels = np.zeros((totnumframes, len(idxes[0])))

        idxess.append(idxes)
        pixelss.append(pixels)


    
    starttime = time.perf_counter()
    count = 0

    while cap.isOpened():
        retval, frame = cap.read()

        if not retval:
            break

        frame = frame.mean(axis = 2)
        for idxes, pixels in zip(idxess, pixelss):
            pixels[count] = frame[idxes]

        if count & 1023 == 1023:
            currenttime = time.perf_counter()
            elapsedtime = currenttime - starttime
            est_time_remaining = elapsedtime / count * (totnumframes - count)
            est_days_remaining = int( est_time_remaining / (60*60*24) )
            est_hrs_remaining = int(( est_time_remaining - est_days_remaining*(60*60*24) ) / (60*60))
            est_mins_remaining = int(( est_time_remaining - est_days_remaining*(60*60*24) - est_hrs_remaining*(60*60) ) / (60))
            est_secs_remaining = int( est_time_remaining - est_days_remaining*(60*60*24) - est_hrs_remaining*(60*60) - est_mins_remaining*(60) )
            print(f"Video = {vidfilename}, Progress: {count}/{totnumframes} frames done, {elapsedtime:.2f} secs elapsed\nestimated {est_days_remaining} days {est_hrs_remaining} hrs {est_mins_remaining} mins {est_secs_remaining} secs left\n")
        count += 1

    for percentile, pixels in zip(percentiles, pixelss):
        np.save(f"top_{percentile:.3f}_percent_score_pixels_{vidnum}.npy", pixels)
        mdict = {f"{vidnum}_passed" : pixels}
        savemat(f'{vidnum}_AInoisedetection_top_{percentile:.3f}_percent_passed.mat', mdict)



