function M2 = moment2(SH, f1, f2, fs, batch_size, gw)
%% integration interval
% convert frequencies to indices
n1 = ceil(f1 * batch_size / fs);
n2 = ceil(f2 * batch_size / fs);

% symetric integration interval
n3 = size(SH, 3) - n2 + 1;
n4 = size(SH, 3) - n1 + 1;

f_range = (n1:n2) .* (fs / batch_size);
f_range_sym = (-n2:-n1) .* (fs / batch_size);
SH(:,:,n1:n2) = SH(:,:,n1:n2) .* reshape(f_range, 1, 1, numel(f_range)).^2;
SH(:,:,n3:n4) = SH(:,:,n3:n4) .* reshape(f_range_sym, 1, 1, numel(f_range_sym)).^2;
moment2 = gather(squeeze(sum(abs(SH(:, :, n1:n2)), 3))) + gather(squeeze(sum(abs(SH(:, :, n3:n4)), 3)));
moment2 = sqrt(moment2);
moment2 = moment2 ./ imgaussfilt(moment2, gw);

M2 = moment2;
end