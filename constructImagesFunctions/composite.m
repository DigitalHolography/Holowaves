function [freq_low, freq_high] = composite(SH, f1, f2, f3, fs, batch_size, gw)
% reconstructs two different holograms with different frequency ranges
% that can be combined to generate a composite color image.

%% integration intervals
low_n1 = round(f1 * batch_size / fs) + 1;
low_n2 = round(f2 * batch_size / fs);
high_n1 = low_n2 + 1;
high_n2 = round(f3 * batch_size / fs);

%% integration
freq_low = squeeze(sum(abs(SH(:, :, low_n1:low_n2)), 3));
freq_high = squeeze(sum(abs(SH(:, :, high_n1:high_n2)), 3));

%% normalization
freq_low = freq_low ./ imgaussfilt(freq_low, gw);
freq_high = freq_high./ imgaussfilt(freq_high, gw);
end