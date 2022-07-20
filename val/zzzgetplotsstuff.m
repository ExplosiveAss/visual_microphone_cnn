clear all;
close all;

load('video_1_vad_scores.mat')
imwrite(scores, 'video_1_vad.png');
close all;
a = reshape(scores, [], 1);
histogram(a);
xlabel('Voice Activity Likelihood score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_1_histogram.png');
close all;

load('video_2_vad_scores.mat')
imwrite(scores, 'video_2_vad.png');
close all;
a = reshape(scores, [], 1);
histogram(a);
xlabel('Voice Activity Likelihood score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_2_histogram.png');
close all;

load('video_3_vad_scores.mat')
imwrite(scores, 'video_3_vad.png');
close all;
a = reshape(scores, [], 1);
histogram(a);
xlabel('Voice Activity Likelihood score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_3_histogram.png');
close all;

load('video_4_vad_scores.mat')
imwrite(scores, 'video_4_vad.png');
close all;
a = reshape(scores, [], 1);
histogram(a);
xlabel('Voice Activity Likelihood score');
ylabel('frequency of getting this score in the video');
saveas(gcf, 'video_4_histogram.png');
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