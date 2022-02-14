function [M0, sqrt_M0] = moment0(SH, n1, n2,  gw)
%% integration interval
% % convert frequencies to indices
% n1 = ceil(f1 * batch_size / fs);
% n2 = ceil(f2 * batch_size / fs);
% 
% % symetric integration interval
% n3 = size(SH, 3) - n2 + 1;
% n4 = size(SH, 3) - n1 + 1;

moment = squeeze(sum(abs(SH(:, :, n1(1):n2(1))), 3));
for i = 2 : length(n1)
    moment = moment + squeeze(sum(abs(SH(:, :, n1(i):n2(i))), 3));
end
sqrt_moment = sqrt(moment);
sqrt_moment = sqrt_moment ./ imgaussfilt(sqrt_moment, gw);

moment =  flat_field_correction(moment, gw);
M0 = gather(moment);
sqrt_M0 = gather(sqrt_moment);
end