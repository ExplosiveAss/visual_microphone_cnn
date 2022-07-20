clear all
close all
addpath(genpath("C:\Users\User\CHOONG REN JUN\#library"));

morefilters = false;

vidnum = 'video_4';
fs = 20000;
ofreq = fs;

if morefilters
    if strcmp(vidnum, 'video_1')
        [zA, pA, kA] = butter(20, [150/(ofreq / 2), 450/(ofreq / 2)], 'bandpass');
        sosA = zp2sos(zA, pA, kA);
    elseif strcmp(vidnum, 'video_2')
        [zA, pA, kA] = butter(20, [150/(ofreq / 2), 450/(ofreq / 2)], 'bandpass');
        sosA = zp2sos(zA, pA, kA);
    elseif strcmp(vidnum, 'video_3')
        [zA, pA, kA] = butter(20, 150/(ofreq / 2), 'high');
        sosA = zp2sos(zA, pA, kA);
        [zB, pB, kB] =  butter(20, [295/(ofreq / 2), 310/(ofreq / 2)], 'stop');
        sosB = zp2sos(zB, pB, kB);
    elseif strcmp(vidnum, 'video_4')
        [zA, pA, kA] = butter(20, 150/(ofreq / 2), 'high');
        sosA = zp2sos(zA, pA, kA);
        [zB, pB, kB] =  butter(20, [295/(ofreq / 2), 310/(ofreq / 2)], 'stop');
        sosB = zp2sos(zB, pB, kB);
    end
end

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


percentiles = {'1.750', '1.500', '1.250', '1.000', '0.750', '0.500', '0.250', '0.200', '0.150', '0.125', '0.100', '0.075', '0.050', '0.040', '0.030', '0.025', '0.020', '0.015', '0.010', '0.005'};
% percentiles = {'0.150', '0.125', '0.100', '0.075', '0.050'};

for precentile_idx = 1:length(percentiles)
    percentile = percentiles{precentile_idx}

    load([vidnum, '_AInoisedetection_top_' percentile '_percent_passed.mat']);

    data = video_4_passed';

    result = data(1, :);

    result = result - mean(result);
    result = result / max(abs(result));
    if morefilters
        if strcmp(vidnum, 'video_1')
            result = sosfilt(sosA, result);
        elseif strcmp(vidnum, 'video_2')
            result = sosfilt(sosA, result);
        elseif strcmp(vidnum, 'video_3')
            result = sosfilt(sosA, result);
            result = sosfilt(sosB, result);
        elseif strcmp(vidnum, 'video_4')
            result = sosfilt(sosA, result);
            result = sosfilt(sosB, result);
        end
    end
    result = sosfilt(sos1, result);
    result = sosfilt(sos2, result);
    if strcmp(vidnum, 'video_3')
        result = sosfilt(sos3, result);
        result = sosfilt(sos4, result);
        result = sosfilt(sos5, result);
    elseif strcmp(vidnum, 'video_4')
        result = sosfilt(sos3, result);
        result = ssubmmsev(result, fs);
    end
    result = result - mean(result);
    result = result / max(abs(result));

    total_length = size(data);
    total_length = int64(total_length(1));
    for ii = 1:1:total_length
        sig = data(ii, :);

        
        
        sig = sig - mean(sig);
        sig = sig / max(abs(sig));
        if morefilters
            if strcmp(vidnum, 'video_1')
                sig = sosfilt(sosA, sig);
            elseif strcmp(vidnum, 'video_2')
                sig = sosfilt(sosA, sig);
            elseif strcmp(vidnum, 'video_3')
                sig = sosfilt(sosA, sig);
                sig = sosfilt(sosB, sig);
            elseif strcmp(vidnum, 'video_4')
                sig = sosfilt(sosA, sig);
                sig = sosfilt(sosB, sig);
            end
        end
        sig = sosfilt(sos1, sig);
        sig = sosfilt(sos2, sig);
        if strcmp(vidnum, 'video_3')
            sig = sosfilt(sos3, sig);
            sig = sosfilt(sos4, sig);
            sig = sosfilt(sos5, sig);
        elseif strcmp(vidnum, 'video_4')
            sig = sosfilt(sos3, sig);
            sig = ssubmmsev(sig, fs);
        end
        sig = sig - mean(sig);
        sig = sig / max(abs(sig));

        if any(isnan(sig))
            continue
        end
        
        sig = crj_xcorrshift(sig, result);
        result = result + sig;
    end

    result = result(50:end);
    if strcmp(vidnum, 'video_3') || strcmp(vidnum, 'video_4')
        result = result(500:end);
    end
    result = result - mean(result);
    result = result / max(abs(result));

    figure;
    plot(result);
    saveas(gcf, [vidnum '_xcorrsum_' percentile '_matlab_sig.png']);

    audiowrite([vidnum '_xcorrsum_' percentile '_matlab_result.wav'], result, fs);
    save([vidnum '_xcorrsum_' percentile '_matlab_result.mat'], 'result');

    figure;
    spectrogram(result, int64(0.05 * fs), int64(0.025 * fs), 32768, fs, 'yaxis');
    colormap('jet');
    saveas(gcf, [vidnum '_xcorrsum_' percentile '_matlab_result.png']);
    ylim([0 1]);

    figure;
    R = fft(result);
    len = length(R);
    plot(linspace(0, 1-1/len, len) * fs, abs(R));
    xlim([0 1000]);
    saveas(gcf, [vidnum '_xcorrsum_' percentile '_matlab_psd.png']);

    close all;
end