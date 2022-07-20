clear all;
close all;

load('video_1_stoi_scores.mat')
imwrite(stoiscores/max(stoiscores, [], 'all'), 'video_1_stoi.png');
close all;
a = reshape(stoiscores, [], 1);
histogram(a);
xlabel('STOI score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_1_stoi_histogram.png');
close all;

load('video_2_stoi_scores.mat')
imwrite(stoiscores/max(stoiscores, [], 'all'), 'video_2_stoi.png');
close all;
a = reshape(stoiscores, [], 1);
histogram(a);
xlabel('STOI score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_2_stoi_histogram.png');
close all;

load('video_3_stoi_scores.mat')
stoiscores(stoiscores==-9413) = 0;
imwrite(stoiscores/max(stoiscores, [], 'all'), 'video_3_stoi.png');
close all;
a = reshape(stoiscores, [], 1);
histogram(a);
xlabel('STOI score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_3_stoi_histogram.png');
close all;

load('video_4_stoi_scores.mat')
imwrite(stoiscores/max(stoiscores, [], 'all'), 'video_4_stoi.png');
close all;
a = reshape(stoiscores, [], 1);
histogram(a);
xlabel('STOI score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_4_stoi_histogram.png');
close all;
































load('video_1_segsnr_scores.mat')
sss = segsnrscores;
sss = sss - min(sss, [], 'all');
sss = sss / max(sss, [], 'all');
imwrite(sss, 'video_1_segsnr.png');
close all;
a = reshape(segsnrscores, [], 1);
histogram(a);
xlabel('segsnr score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_1_segsnr_histogram.png');
close all;

load('video_2_segsnr_scores.mat')
sss = segsnrscores;
sss = sss - min(sss, [], 'all');
sss = sss / max(sss, [], 'all');
imwrite(sss, 'video_2_segsnr.png');
close all;
a = reshape(segsnrscores, [], 1);
histogram(a);
xlabel('segsnr score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_2_segsnr_histogram.png');
close all;

load('video_3_segsnr_scores.mat')
segsnrscores(segsnrscores==-9413) = -NaN;
segsnrscores(isnan(segsnrscores)) = min(segsnrscores, [], 'all', 'omitnan');
sss = segsnrscores;
sss = sss - min(sss, [], 'all', 'omitnan');
sss = sss / max(sss, [], 'all');
imwrite(sss, 'video_3_segsnr.png');
close all;
a = reshape(segsnrscores, [], 1);
histogram(a);
xlabel('segsnr score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_3_segsnr_histogram.png');
close all;

load('video_4_segsnr_scores.mat')
sss = segsnrscores;
sss = sss - min(sss, [], 'all');
sss = sss / max(sss, [], 'all');
imwrite(sss, 'video_4_segsnr.png');
close all;
a = reshape(segsnrscores, [], 1);
histogram(a);
xlabel('segsnr score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_4_segsnr_histogram.png');
close all;













% load('video_3_vad_scores.mat')
% saveas(gcf, 'video_3_vad_with_speech_enhahcement.png');
% close all;
% a = reshape(scores, [], 1);
% histogram(a);
% xlabel('Voice Activity Likelihood score');
% ylabel('frequency of getting this score in the video');
% saveas(gcf, 'video_3_histogram_with_speech_enhahcement.png');
% close all;
% 
% load('video_4_vad_scores.mat')
% imshow(scores);
% saveas(gcf, 'video_4_vad_with_speech_enhahcement.png');
% close all;
% a = reshape(scores, [], 1);
% histogram(a);
% xlabel('Voice Activity Likelihood score');
% ylabel('frequency of getting this score in the video');
% saveas(gcf, 'video_4_histogram_with_speech_enhahcement.png');
% close all;