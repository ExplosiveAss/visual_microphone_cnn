function crj_specgram(x, fs, cmap_lower_lim, cmap_upper_lim)
    % x = the signal
    % fs = the sampling rate
    % cmap_lower_lim = the lower limit (dB/Hz) for the colormap,
    % recoomended value = -150
    % cmap_upper_lim = the upper limit (dB/Hz) for the colormap,
    % recommended value = -30
    
    spectrogram(x, int64(0.05 * fs), int64(0.025 * fs), 10000, fs, 'yaxis');
    colormap('jet');
    lim = caxis;
    caxis([cmap_lower_lim cmap_upper_lim]);


end