spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
colormap('jet');
lim = caxis;
caxis([-150 -30]);