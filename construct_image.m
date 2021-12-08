function [type_list1, type_list2] = construct_image(FH, wavelength, f1, f2, acquisition, gaussian_width, use_gpu, svd, phase_correction,...
                                                                  color_f1, color_f2, color_f3, output_type)
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
% blood velocity: velocity

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
SH2 = abs(SH).^2; 

%% shifts related to acquisition wrong positioning
SH2 = permute(SH2, [2 1 3]);
SH2 = circshift(SH2, [-ac.delta_y, ac.delta_x, 0]);

%% Compute moments based on dropdown value

switch output_type
    case 'velocity estimate'
        type_list1 = construct_velocity_video(SH2, f1, f2, ac.fs, j_win, gaussian_width, wavelength);
        
    case 'color Doppler'
        [type_list1, type_list2] = composite(SH2, color_f1, color_f2, color_f3, ac.fs, j_win, gaussian_width);
       
    case 'directional Doppler'
        [type_list1, type_list2] = directional(SH2, f1, f2, ac.fs, j_win, gaussian_width);  
end

M1sM0r = fmean(SH2, f1, f2, ac.fs, j_win, gaussian_width);
[hologram0, sqrt_hologram0] = moment0(SH2, f1, f2, ac.fs, j_win, gaussian_width);
hologram1 = moment1(SH2, f1, f2, ac.fs, j_win, gaussian_width);
hologram2 = moment2(SH2, f1, f2, ac.fs, j_win, gaussian_width);

end