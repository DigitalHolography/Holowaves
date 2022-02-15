function [M0, sqrt_M0] = moment0(A, idxspan1, idxspan2,  gw)
%% integration interval
% A : 3D array x,y,omega
% idxspan1 = index vector (positive freqs)
% idxspan2 = index vector (negative freqs)

A = abs(A);
moment = squeeze(sum(A(:, :, idxspan1(1):idxspan2(1)), 3));
for i = 2 : length(idxspan1)
    moment = moment + squeeze(sum(A(:, :, idxspan1(i):idxspan2(i)), 3));
end
moment =  flat_field_correction(moment, gw);

sqrt_moment = sqrt(moment);
sqrt_moment = flat_field_correction(sqrt_moment, gw);

M0 = gather(moment);
sqrt_M0 = gather(sqrt_moment);
end