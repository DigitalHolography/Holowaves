function [M0, raw_M0] = moment0(A, f1, f2, fs, batch_size, gw)
%% integration interval
% convert frequencies to indices
n1 = ceil(f1 * batch_size / fs);
n2 = ceil(f2 * batch_size / fs);

% symetric integration interval
n3 = size(A, 3) - n2 + 1;
n4 = size(A, 3) - n1 + 1;

A = abs(A);

moment = squeeze(sum(A(:, :, n1:n2), 3)) + squeeze(sum(A(:, :, n3:n4), 3));

raw_M0 = gather(moment);
moment =  flat_field_correction(moment, gw);

% sqrt_moment = sqrt(moment);
% sqrt_moment = flat_field_correction(sqrt_moment, gw);

M0 = gather(moment);
% sqrt_M0 = gather(sqrt_moment);
end