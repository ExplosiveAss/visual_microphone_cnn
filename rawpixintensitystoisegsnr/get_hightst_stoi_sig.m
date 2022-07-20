clear all;
close all;
addpath(genpath("C:\Users\User\CHOONG REN JUN\#library"));



videos = {'video_1', 'video_2', 'video_3', 'video_4'};
vidfilenames = {'..\\Chips2-2200Hz-Mary_MIDI-input.avi', '..\\Plant-2200Hz-Mary_MIDI-input.avi', '..\\Chips1-2200Hz-Mary_Had-input.avi', '..\\Chips1-20000Hz-Mary_Had-input.avi'};
freqs = {2200, 2200, 2200, 20000};


for vid_idx = 1:length(videos)
    vidnum = videos{vid_idx};
    vidfilename = vidfilenames{vid_idx};
    ofreq = freqs{vid_idx};
    fs = ofreq;
    
    load([vidnum, '_segsnr_scores.mat'])
    [M,I] = max(segsnrscores,[],"all","linear");
    [segsnrdim1, segsnrdim2] = ind2sub(size(segsnrscores),I);
    
    load([vidnum, '_stoi_scores.mat'])
    [M,I] = max(stoiscores,[],"all","linear");
    [stoidim1, stoidim2] = ind2sub(size(stoiscores),I);
    
    vr = VideoReader(vidfilename);
    segsnrarr = zeros(1, vr.NumberOfFrames);
    stoiarr = zeros(1, vr.NumberOfFrames);
    for jj = 1:1:vr.NumberOfFrames
        frame = readFrame(vr);
        frame = im2double(frame);
        
        segsnrpix = (frame(segsnrdim1, segsnrdim2, 1) + frame(segsnrdim1, segsnrdim2, 2) + frame(segsnrdim1, segsnrdim2, 3));
        segsnrpix = segsnrpix / 3;
        segsnrarr(jj) = segsnrpix;
        
        stoipix = (frame(stoidim1, stoidim2, 1) + frame(stoidim1, stoidim2, 2) + frame(stoidim1, stoidim2, 3));
        stoipix = stoipix / 3;
        stoiarr(jj) = stoipix;
    end
    
    segsnrfilename = sprintf('%s_segsnr_best_pixel_%d_%d.mat', vidnum, segsnrdim1, segsnrdim2);
    stoifilename = sprintf('%s_stoi_best_pixel_%d_%d.mat', vidnum, stoidim1, stoidim2);
    
    save(segsnrfilename, 'segsnrarr');
    save(stoifilename, 'stoiarr');
    
    
    
    
    %% xcorrcombine
    
    
    if strcmp(vidnum, 'video_1')
        [z1, p1, k1] = butter(2, [150/(ofreq / 2), 450/(ofreq / 2)], 'bandpass');
        sos1 = zp2sos(z1,p1,k1);
        [z2, p2, k2] =  butter(2, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
        sos2 = zp2sos(z2,p2,k2);
    elseif strcmp(vidnum, 'video_2')
        [z1, p1, k1] = butter(2, [150/(ofreq / 2), 450/(ofreq / 2)], 'bandpass');
        sos1 = zp2sos(z1,p1,k1);
        [z2, p2, k2] =  butter(2, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
        sos2 = zp2sos(z2,p2,k2);
    elseif strcmp(vidnum, 'video_3')
        [z1, p1, k1] = butter(2, 150/(ofreq / 2), 'high');
        sos1 = zp2sos(z1,p1,k1);
        [z2, p2, k2] =  butter(2, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
        sos2 = zp2sos(z2,p2,k2);
        [z3, p3, k3] =  butter(1, [239/(ofreq / 2), 241/(ofreq / 2)], 'stop');
        sos3 = zp2sos(z3,p3,k3);
        [z4, p4, k4] =  butter(1, [359/(ofreq / 2), 361/(ofreq / 2)], 'stop');
        sos4 = zp2sos(z4,p4,k4);
        [z5, p5, k5] =  butter(1, [479/(ofreq / 2), 481/(ofreq / 2)], 'stop');
        sos5 = zp2sos(z5,p5,k5);
    elseif strcmp(vidnum, 'video_4')
        [z1, p1, k1] = butter(2, 150/(ofreq / 2), 'high');
        sos1 = zp2sos(z1,p1,k1);
        [z2, p2, k2] =  butter(2, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
        sos2 = zp2sos(z2,p2,k2);
        [z3, p3, k3] =  butter(1, [239/(ofreq / 2), 241/(ofreq / 2)], 'stop');
        sos3 = zp2sos(z3,p3,k3);
    end
    
    
    
    
    segsnrarr = segsnrarr - mean(segsnrarr);
    segsnrarr = segsnrarr / max(abs(segsnrarr));
    segsnrarr = sosfilt(sos1, segsnrarr);
    segsnrarr = sosfilt(sos2, segsnrarr);
    if strcmp(vidnum, 'video_3')
        segsnrarr = sosfilt(sos3, segsnrarr);
        segsnrarr = sosfilt(sos4, segsnrarr);
        segsnrarr = sosfilt(sos5, segsnrarr);
    elseif strcmp(vidnum, 'video_4')
        segsnrarr = sosfilt(sos3, segsnrarr);
        segsnrarr = ssubmmsev(segsnrarr, fs);
    end
    segsnrarr = segsnrarr - mean(segsnrarr);
    segsnrarr = segsnrarr / max(abs(segsnrarr));
    
    
    stoiarr = stoiarr - mean(stoiarr);
    stoiarr = stoiarr / max(abs(stoiarr));
    stoiarr = sosfilt(sos1, stoiarr);
    stoiarr = sosfilt(sos2, stoiarr);
    if strcmp(vidnum, 'video_3')
        stoiarr = sosfilt(sos3, stoiarr);
        stoiarr = sosfilt(sos4, stoiarr);
        stoiarr = sosfilt(sos5, stoiarr);
    elseif strcmp(vidnum, 'video_4')
        stoiarr = sosfilt(sos3, stoiarr);
        stoiarr = ssubmmsev(stoiarr, fs);
    end
    stoiarr = stoiarr - mean(stoiarr);
    stoiarr = stoiarr / max(abs(stoiarr));
    
    
    %% postprocessing
    
    
    
    if strcmp(vidnum, 'video_1')
        [z1, p1, k1] = butter(2, [150/(ofreq/2) 450/(ofreq/2)], 'bandpass');
        sos1 = zp2sos(z1,p1,k1);
        [z2, p2, k2] =  butter(1, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
        sos2 = zp2sos(z2,p2,k2);
    elseif strcmp(vidnum, 'video_2')
        [z1, p1, k1] = butter(2, [150/(ofreq/2) 450/(ofreq/2)], 'bandpass');
        sos1 = zp2sos(z1,p1,k1);
        [z2, p2, k2] =  butter(1, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
        sos2 = zp2sos(z2,p2,k2);
    elseif strcmp(vidnum, 'video_3')
        [z1, p1, k1] = butter(2, 150/(ofreq / 2), 'high');
        sos1 = zp2sos(z1,p1,k1);
        [z2, p2, k2] =  butter(1, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
        sos2 = zp2sos(z2,p2,k2);
    elseif strcmp(vidnum, 'video_4')
        [z1, p1, k1] = butter(2, 150/(ofreq / 2), 'high');
        sos1 = zp2sos(z1,p1,k1);
        [z2, p2, k2] =  butter(1, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
        sos2 = zp2sos(z2,p2,k2);
    end
    
    
    segsnrarr = segsnrarr - mean(segsnrarr);
    segsnrarr = segsnrarr / max(abs(segsnrarr));
    segsnrarr = sosfilt(sos1, segsnrarr);
    segsnrarr = sosfilt(sos2, segsnrarr);
    if strcmp(vidnum, 'video_3')
        segsnrarr = ssubmmsev(segsnrarr, fs);
    elseif strcmp(vidnum, 'video_4')
        segsnrarr = ssubmmsev(segsnrarr, fs);
    end
    segsnrarr = segsnrarr - mean(segsnrarr);
    segsnrarr = segsnrarr / max(abs(segsnrarr));
    
    
    stoiarr = stoiarr - mean(stoiarr);
    stoiarr = stoiarr / max(abs(stoiarr));
    stoiarr = sosfilt(sos1, stoiarr);
    stoiarr = sosfilt(sos2, stoiarr);
    if strcmp(vidnum, 'video_3')
        stoiarr = ssubmmsev(stoiarr, fs);
    elseif strcmp(vidnum, 'video_4')
        stoiarr = ssubmmsev(stoiarr, fs);
    end
    stoiarr = stoiarr - mean(stoiarr);
    stoiarr = stoiarr / max(abs(stoiarr));
    
    segsnrfilename = sprintf('%s_segsnr_best_pixel_%d_%d.wav', vidnum, segsnrdim1, segsnrdim2);
    stoifilename = sprintf('%s_stoi_best_pixel_%d_%d.wav', vidnum, stoidim1, stoidim2);
    
    audiowrite(segsnrfilename, segsnrarr, ofreq);
    audiowrite(stoifilename, stoiarr, ofreq);
end