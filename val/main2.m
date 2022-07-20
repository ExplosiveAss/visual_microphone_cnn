clear all;
close all;
addpath(genpath("C:\Users\User\CHOONG REN JUN\#library"));


vidnum = 'video_2';
vidfilename = '..\\Plant-2200Hz-Mary_MIDI-input.avi';
fs = 2200;
numrows = 400;
numcols = 704;
rowstepsize = 100;
numsteps = numrows / rowstepsize;


ofreq = fs;
[z1, p1, k1] =  butter(2, [119/(ofreq / 2), 121/(ofreq / 2)], 'stop');
sos1 = zp2sos(z1,p1,k1);
[z2, p2, k2] =  butter(2, [239/(ofreq / 2), 241/(ofreq / 2)], 'stop');
sos2 = zp2sos(z2,p2,k2);
[z3, p3, k3] =  butter(5, [150/(ofreq / 2), 450/(ofreq / 2)], 'bandpass');
sos3 = zp2sos(z3,p3,k3);


scores = zeros(numrows, numcols);

for ii = 1:rowstepsize:numrows
    ii
    vr = VideoReader(vidfilename);
    arr = zeros(vr.NumberOfFrames, rowstepsize, numcols);
    for jj = 1:1:vr.NumberOfFrames
        frame = readFrame(vr);
        frame = mean(frame, 3);
        arr(jj, :, :) = frame(ii:ii + rowstepsize - 1, :);
    end
    
    for jj = 1:1:rowstepsize
        for kk = 1:1:numcols
            sig = arr(:, jj, kk);
            sig = sig - mean(sig);
            sig = sig / max(abs(sig));
            sig = sosfilt(sos1, sig);
            sig = sosfilt(sos2, sig);
            sig = sosfilt(sos3, sig);
            
            
            if any(isnan(sig))
                scores(ii - 1 + jj,kk) = 0;
            else
                [vs, zo] = v_vadsohn(sig, fs);
                vad_score = mean(vs);
                scores(ii - 1 + jj,kk) = vad_score;
            end
        end
    end
    save('video_2_vad_scores.mat', 'scores');
end
save('video_2_vad_scores.mat', 'scores');