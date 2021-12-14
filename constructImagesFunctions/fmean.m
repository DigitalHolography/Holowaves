function M1sM0r = fmean(SH, f1, f2, fs, batch_size, gw)
%% integration interval
% convert frequencies to indices
n1 = ceil(f1 * batch_size / fs);
n2 = ceil(f2 * batch_size / fs);

% symetric integration interval
n3 = size(SH, 3) - n2 + 1;
n4 = size(SH, 3) - n1 + 1;

f_range = (n1:n2) .* (fs / batch_size);
f_range_sym = (-n2:-n1) .* (fs / batch_size);
SH_f1 = SH;
SH_f1(:,:,n1:n2) = SH_f1(:,:,n1:n2) .* reshape(f_range, 1, 1, numel(f_range));
SH_f1(:,:,n3:n4) = SH_f1(:,:,n3:n4) .* reshape(f_range_sym, 1, 1, numel(f_range_sym));

M0 = squeeze(sum(abs(SH(:, :, n1:n2)), 3)) + squeeze(sum(abs(SH(:, :, n3:n4)), 3));
M1 = gather(squeeze(sum(abs(SH_f1(:, :, n1:n2)), 3))) + gather(squeeze(sum(abs(SH_f1(:, :, n3:n4)), 3)));

N_M0 = sum(M0(:));
M0_filtered = imgaussfilt(M0, gw);
M0_div = M0 ./ M0_filtered;
N_M0_div = sum(M0_div(:));
M0_div = M0_div * N_M0 / N_M0_div;

N_M0 = sum(M1(:));
M1_filtered = imgaussfilt(M1, gw);
M1_div = M1 ./ M1_filtered;
N_M0_div = sum(M1_div(:));
M1_div = M1_div * N_M0 / N_M0_div;

M1sM0r = M1_div ./ M0_div;
end