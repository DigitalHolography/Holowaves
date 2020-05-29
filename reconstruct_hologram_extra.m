function [hologram0, sqrt_hologram0, hologram1, hologram2, freq_low, freq_high, M0_pos, M0_neg, M1sM0r] = reconstruct_hologram_extra(FH, f1, f2, acquisition, gaussian_width, use_gpu, svd, phase_correction,...
                                                                  color_f1, color_f2, color_f3)
% Compute the moment of a batch of interferograms.
% This function computes a lot of different outputs, for speed use
% tue 'reconstruct_hologram' function instead.
%
% INPUT ARGUMENT
% FH: the preprocessed input interferograms batch
% kernel: wave propagation kernel
% f1, f2: frequency integration bounds
% acquisition: a DopplerAcquisition struct containing informations
%              about the experimental setup
% gaussian_width: size of the gaussian filter
% use_gpu: use gpu or not for the reconstruction
% svd: add SVD filtering to hologram reconstruction
% phase_correction: optional parameter, a phase correction to apply before
%                   reconstructing the hologram
%
% OUTPUT ARGUMENTS
% hologram0: M0
% sqrt_hologram0: sqrt(M0)
% hologram1: M1
% hologram2: M2
% composite_(1|2|3): reduced frequency bands of M0 to create a composite
%                    RGB image in post processing

j_win = size(FH, 3);
ac = acquisition;

% move data to gpu if available
if use_gpu
    if exist('phase_correction', 'var')
        phase_correction = gpuArray(phase_correction);
    end
end

if exist('phase_correction', 'var') && ~isempty(phase_correction)
    FH = FH .* exp(-1i * phase_correction);
end

H = ifft2(FH);
clear FH;

%% SVD filtering
if svd
    H = svd_filter(H, f1, ac.fs);
end

%% squared magnitude of hologram
SH = fft(H, [], 3);
SH = abs(SH).^2;

%% shifts related to acquisition wrong positioning
SH = permute(SH, [2 1 3]);
SH = circshift(SH, [-ac.delta_y, ac.delta_x, 0]);

%% Compute moments
[hologram0, sqrt_hologram0] = moment0(SH, f1, f2, ac.fs, j_win, gaussian_width);
hologram1 = moment1(SH, f1, f2, ac.fs, j_win, gaussian_width);
hologram2 = moment2(SH, f1, f2, ac.fs, j_win, gaussian_width);
[freq_low, freq_high] = composite(SH, color_f1, color_f2, color_f3, ac.fs, j_win, gaussian_width);
[M0_pos, M0_neg] = directional(SH, f1, f2, ac.fs, j_win, gaussian_width);
M1sM0r = fmean(SH, f1, f2, ac.fs, j_win, gaussian_width);
end