function [M0_pos, M0_neg] = directional(SH, f1, f2, fs, batch_size, gw)
%% integration interval
% convert frequencies to indices
n1 = ceil(f1 * batch_size / fs);
n2 = ceil(f2 * batch_size / fs);

% symetric integration interval
n3 = size(SH, 3) - n2 + 1;
n4 = size(SH, 3) - n1 + 1;

M0_pos = squeeze(sum(abs(SH(:, :, n1:n2)), 3));
M0_neg = squeeze(sum(abs(SH(:, :, n3:n4)), 3));

% normalization
N_M0_pos = sum(M0_pos(:));
N_M0_neg = sum(M0_neg(:));

M0_filtered = imgaussfilt(M0_pos + M0_neg, gw);

M0_pos = M0_pos ./ M0_filtered;
N_M0_pos_filtered = sum(M0_pos(:));
M0_pos = M0_pos * N_M0_pos / N_M0_pos_filtered;

M0_neg = M0_neg ./ M0_filtered;
N_M0_neg_filtered = sum(M0_neg(:));
M0_neg = M0_neg * N_M0_neg/N_M0_neg_filtered;
end