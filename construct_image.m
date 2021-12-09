function img_list = construct_image(FH, wavelength, f1, f2, acquisition, gaussian_width, use_gpu, svd, phase_correction,...
                                                                  color_f1, color_f2, color_f3, img_type_list, is_low_frequency)
% fullNames = ['Power Doppler', 'Color Doppler', 'Directional Doppler', 'Velocity Estimate'];
% save the problem of frequencies!
img_list = zeros(size(FH,1), size(FH,2), 3, size(img_type_list,2)); % 10 corresponds to the possible outputs of reconstruct hologram extras

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
if is_low_frequency
    sign = -1;
else 
    sign = 1;
end


if img_type_list.values(1) % Power Doppler has been chosen
    [img, ~] = (moment0(SH2, f1, f2, ac.fs, j_win, gaussian_width));
    img_list(:,:,:,1) = cat(3, img, img, img);
end

if img_type_list.values(2) % Power 1 Doppler has been chosen
    img = moment1(SH2, f1, f2, ac.fs, j_win, gaussian_width);
    img_list(:,:,:,2) = cat(3, img, img, img);
end

if img_type_list.values(3) % Power 2 Doppler has been chosen
    img = moment2(SH2, f1, f2, ac.fs, j_win, gaussian_width);
    img_list(:,:,:,3) = cat(3, img, img, img);
end

if img_type_list.values(4)  % Color Doppler has been chosen
    [freq_high, freq_low] = composite(SH2, color_f1, color_f2, color_f3, ac.fs, j_win, gaussian_width);
    img_list(:,:,:,4) = construct_colored_image(sign * gather(freq_high), sign * gather(freq_low), is_low_frequency);
end

if img_type_list.values(5) % Directional Doppler has been chosen
    [M0_neg, M0_pos] = directional(SH2, f1, f2, ac.fs, j_win, gaussian_width);
    img_list(:,:,:,5) = construct_directionalDoppler_image(sign * gather(M0_neg), sign *gather(M0_pos), is_low_frequency);
end

if img_type_list.values(6) % M1sM0r has been chosen
    img = fmean(SH2, f1, f2, ac.fs, j_win, gaussian_width);
    img_list(:,:,:,6) = cat(3, img, img, img);
end

if img_type_list.values(7) % Velocity Estimate has been chosen
    img_list(:,:,:,7) = construct_velocity_video(SH2, f1, f2, ac.fs, j_win, gaussian_width, wavelength);
end

end