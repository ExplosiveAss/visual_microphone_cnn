clear all
close all
addpath(genpath("C:\Users\User\CHOONG REN JUN\#library"));




output_cleaned_signal = true;




%%
vidnum = 'video_1';

[osig, ofreq] = audioread(['original\' vidnum '.wav']);
osig = osig - mean(osig);

osiglen = length(osig);
osig16000 = resample(osig, 16000, ofreq);

rootdir = pwd;
filelist = dir(fullfile(rootdir, 'recovered', '**\*.*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


[z1, p1, k1] = butter(2, [150/(ofreq/2) 450/(ofreq/2)], 'bandpass');
sos1 = zp2sos(z1,p1,k1);
[z2, p2, k2] =  butter(1, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
sos2 = zp2sos(z2,p2,k2);


fp = fopen([vidnum '_results.csv'], 'w');


for ii = 1:1:length(filelist)
    file = filelist(ii);
    
    path = strsplit(file.folder, '\');
    
    if strcmp(path{end}, vidnum) && strcmp(path{end - 1}, 'recovered')
        if endsWith(file.name, '.wav')

            
            input_file_path_and_name = fullfile(file.folder, file.name);
            input_file_path_and_name
            
            [s, f]  = audioread(input_file_path_and_name);
            
            s = s - mean(s);
            s = s / max(abs(s));
            
            
            
            %%
            ss = s;
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150450
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '150450_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end

            
            
            
            %%
            ss = s;
            ss = sosfilt(sos2, ss); % 120
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '120_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150450
            ss = sosfilt(sos2, ss); % 120
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '150450_120_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            

            
    
        end
    end
end

fclose(fp);



















%%
vidnum = 'video_2';

[osig, ofreq] = audioread(['original\' vidnum '.wav']);
osig = osig - mean(osig);

osiglen = length(osig);
osig16000 = resample(osig, 16000, ofreq);

rootdir = pwd;
filelist = dir(fullfile(rootdir, 'recovered', '**\*.*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


[z1, p1, k1] = butter(2, [150/(ofreq/2) 450/(ofreq/2)], 'bandpass');
sos1 = zp2sos(z1,p1,k1);
[z2, p2, k2] =  butter(1, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
sos2 = zp2sos(z2,p2,k2);


fp = fopen([vidnum '_results.csv'], 'w');


for ii = 1:1:length(filelist)
    file = filelist(ii);
    
    path = strsplit(file.folder, '\');
    
    if strcmp(path{end}, vidnum) && strcmp(path{end - 1}, 'recovered')
        if endsWith(file.name, '.wav')

            
            input_file_path_and_name = fullfile(file.folder, file.name);
            input_file_path_and_name
            
            [s, f]  = audioread(input_file_path_and_name);
            
            s = s - mean(s);
            s = s / max(abs(s));
            
            
            
            %%
            ss = s;
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            figure;
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150450
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '150450_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            figure;
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos2, ss); % 120
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '120_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            figure;
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150450
            ss = sosfilt(sos2, ss); % 120
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '150450_120_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            figure;
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            

            
    
        end
    end
end

fclose(fp);




















%%
vidnum = 'video_3';

[osig, ofreq] = audioread(['original\' vidnum '.wav']);
osig = osig - mean(osig);

osiglen = length(osig);
osig16000 = resample(osig, 16000, ofreq);

rootdir = pwd;
filelist = dir(fullfile(rootdir, 'recovered', '**\*.*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


[z1, p1, k1] = butter(2, 150/(ofreq / 2), 'high');
sos1 = zp2sos(z1,p1,k1);
[z2, p2, k2] =  butter(1, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
sos2 = zp2sos(z2,p2,k2);


fp = fopen([vidnum '_results.csv'], 'w');


for ii = 1:1:length(filelist)
    file = filelist(ii);
    
    path = strsplit(file.folder, '\');
    
    if strcmp(path{end}, vidnum) && strcmp(path{end - 1}, 'recovered')
        if endsWith(file.name, '.wav')

            
            input_file_path_and_name = fullfile(file.folder, file.name);
            input_file_path_and_name
            
            [s, f]  = audioread(input_file_path_and_name);
            
            s = s - mean(s);
            s = s / max(abs(s));
            
            
            
            %%
            ss = s;
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            
            
            
            %%
            ss = s;
            ss = ssubmmsev(ss, ofreq); % se
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = 'se_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '150_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150
            ss = ssubmmsev(ss, ofreq); % se
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '150_se_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos2, ss); % 120
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '120_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos2, ss); % 120
            ss = ssubmmsev(ss, ofreq); % se
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '120_se_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150
            ss = sosfilt(sos2, ss); % 120
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '120_150_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            

            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150
            ss = sosfilt(sos2, ss); % 120
            ss = ssubmmsev(ss, ofreq); % se
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '120_150_se_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
    
        end
    end
end

fclose(fp);




















%%
vidnum = 'video_4';

[osig, ofreq] = audioread(['original\' vidnum '.wav']);
osig = osig - mean(osig);

osiglen = length(osig);
osig16000 = resample(osig, 16000, ofreq);

rootdir = pwd;
filelist = dir(fullfile(rootdir, 'recovered', '**\*.*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


[z1, p1, k1] = butter(2, 150/(ofreq / 2), 'high');
sos1 = zp2sos(z1,p1,k1);
[z2, p2, k2] =  butter(1, [118/(ofreq / 2), 122/(ofreq / 2)], 'stop');
sos2 = zp2sos(z2,p2,k2);


fp = fopen([vidnum '_results.csv'], 'w');


for ii = 1:1:length(filelist)
    file = filelist(ii);
    
    path = strsplit(file.folder, '\');
    
    if strcmp(path{end}, vidnum) && strcmp(path{end - 1}, 'recovered')
        if endsWith(file.name, '.wav')

            
            input_file_path_and_name = fullfile(file.folder, file.name);
            input_file_path_and_name
            
            [s, f]  = audioread(input_file_path_and_name);
            
            s = s - mean(s);
            s = s / max(abs(s));
            
            
            
            %%
            ss = s;
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            
            
            
            %%
            ss = s;
            ss = ssubmmsev(ss, ofreq); % se
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = 'se_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '150_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150
            ss = ssubmmsev(ss, ofreq); % se
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '150_se_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos2, ss); % 120
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '120_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos2, ss); % 120
            ss = ssubmmsev(ss, ofreq); % se
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '120_se_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150
            ss = sosfilt(sos2, ss); % 120
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '120_150_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            

            
            %%
            ss = s;
            ss = sosfilt(sos1, ss); % 150
            ss = sosfilt(sos2, ss); % 120
            ss = ssubmmsev(ss, ofreq); % se
            ss = crj_xcorrshift(ss, osig);
            ss = ss - mean(ss);
            ss = ss / max(abs(ss));

            file_prefix = '120_150_se_';
            stoival = stoi(osig, ss, ofreq);
            snrval = snr(ss, ss - osig);
            segsnrval = v_snrseg(ss, osig, ofreq, 'w');
            llrval = comp_llr(osig, ss, ofreq);
            ss16000 = resample(ss, 16000, ofreq);
            pesqval = pesq(osig16000, ss16000, 16000);
            fprintf(fp, [file_prefix file.name ',stoi:,%f,snr:,%f,segsnr:,%f,llr:,%f,pesq:,%f\n'], stoival, snrval,segsnrval,llrval,pesqval);
            x = ss; fs = ofreq;
            figure;
            spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
            colormap('jet');
            lim = caxis;
            figfilename = [file.folder '\' file_prefix file.name];
            fname = [figfilename(1:end-4) '_spectrogram.png'];
            saveas(gcf, fname);
            figure;
            R = fft(ss);
            len = length(R);
            plot(linspace(0, 1-1/len, len) * fs, abs(R));
            xlim([0 1000]);
            fname = [figfilename(1:end-4) '_psd.png'];
            saveas(gcf, fname);
            figure;
            time = 0:1:len-1;
            time = time / fs;
            plot(time, ss);
            fname = [figfilename(1:end-4) '_sig.png'];
            saveas(gcf, fname);
            plot(0:1:length(osig)-1 / fs, osig);
            hold on;
            plot(0:1:length(ss)-1 / fs, ss);
            fname = [figfilename(1:end-4) '_oriblue_sigorange.png'];
            saveas(gcf, fname);
            close all;
            if output_cleaned_signal
                audiowrite([figfilename(1:end-4) '.wav'], ss, ofreq);
            end
            
            
    
        end
    end
end

fclose(fp);