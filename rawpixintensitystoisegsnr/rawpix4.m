clear all;
close all;
addpath(genpath("C:\Users\User\CHOONG REN JUN\#library"));


vidnum = 'video_4';
vidfilename = '..\\Chips1-20000Hz-Mary_Had-input.avi';
fs = 20000;
numrows = 192;
numcols = 192;
rowstepsize = 64;
numsteps = numrows / rowstepsize;

[osig, ofreq] = audioread(['evaluation_folder\original\' vidnum '.wav']);
osig = osig - mean(osig);


%% xcorr combine filters
[z1, p1, k1] = butter(2, 150/(ofreq / 2), 'high');
sos1 = zp2sos(z1,p1,k1);
[z2, p2, k2] =  butter(2, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
sos2 = zp2sos(z2,p2,k2);
[z3, p3, k3] =  butter(1, [239/(ofreq / 2), 241/(ofreq / 2)], 'stop');
sos3 = zp2sos(z3,p3,k3);
% remember speech enhahcement!



%% postprocessing filters
[zA, pA, kA] = butter(2, 150/(ofreq / 2), 'high');
sosA = zp2sos(zA,pA,kA);
[zB, pB, kB] =  butter(1, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
sosB = zp2sos(zB,pB,kB);
% remember speech enhahcement!
















stoiscores = zeros(numrows, numcols);
segsnrscores = zeros(numrows, numcols);

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


            %% xcorr combine filters
            sig = sosfilt(sos1, sig);
            sig = sosfilt(sos2, sig);
            sig = sosfilt(sos3, sig);
            sig = ssubmmsev(sig, fs);

            %% postprocessing filters
            sig = sosfilt(sosA, sig);
            sig = sosfilt(sosB, sig);
            sig = ssubmmsev(sig, fs);



            if any(isnan(sig))
                stoiscores(ii - 1 + jj,kk) = -9413; % supposed to be nan but I purposely put a funny number so I can reidentify the location easily later
                segsnrscores(ii - 1 + jj,kk) = -9413;
            else
                sig = sig - mean(sig);
                sig = sig / max(abs(sig));

                sig = crj_xcorrshift(sig, osig);
                stoival = stoi(osig, sig, fs);
                segsnrval = v_snrseg(sig, osig, fs, 'w');

                stoiscores(ii - 1 + jj,kk) = stoival;
                segsnrscores(ii - 1 + jj,kk) = segsnrval;
            end
        end
    end
    save([vidnum '_stoi_scores.mat'], 'stoiscores');
    save([vidnum '_segsnr_scores.mat'], 'segsnrscores');
end
save([vidnum '_stoi_scores.mat'], 'stoiscores');
save([vidnum '_segsnr_scores.mat'], 'segsnrscores');

