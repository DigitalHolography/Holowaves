function img_type_list = construct_image(FH, wavelength, f1, f2, acquisition, gaussian_width, use_gpu, svd, phase_correction,...
                                                                  color_f1, color_f2, color_f3, img_type_list, is_low_frequency)

% FIXME : replace ifs by short name functions


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

% possibly you don't need to distinguish between grayscale images and RGB

if img_type_list.power_Doppler.select % Power Doppler has been chosen
    [img, sqrt_img] = (moment0(SH2, f1, f2, ac.fs, j_win, gaussian_width));
    img_type_list.power_Doppler.M0_sqrt = sqrt_img;
    img_type_list.power_Doppler.image = img;
end

if img_type_list.power_1_Doppler.select % Power 1 Doppler has been chosen
    img = moment1(SH2, f1, f2, ac.fs, j_win, gaussian_width);
    img_type_list.power_1_Doppler.image = img;
end

if img_type_list.power_2_Doppler.select % Power 2 Doppler has been chosen
    img = moment2(SH2, f1, f2, ac.fs, j_win, gaussian_width);
    img_type_list.power_2_Doppler.image = img;
end

if img_type_list.color_Doppler.select  % Color Doppler has been chosen
    [M0_neg, M0_pos] = composite(SH2, color_f1, color_f2, color_f3, ac.fs, j_win, gaussian_width);
    img_type_list.color_Doppler.M0_pos = M0_pos;
    img_type_list.color_Doppler.M0_neg = M0_neg;
    img_type_list.color_Doppler.image = construct_colored_image(sign * gather(M0_neg), sign * gather(M0_pos), is_low_frequency);
end

if img_type_list.directional_Doppler.select % Directional Doppler has been chosen
    [freq_high, freq_low] = directional(SH2, f1, f2, ac.fs, j_win, gaussian_width);
    img_type_list.directional_Doppler.freq_low = freq_low;
    img_type_list.directional_Doppler.freq_high = freq_high;
    img_type_list.directional_Doppler.image = construct_directional_image(sign * gather(freq_high), sign *gather(freq_low), is_low_frequency);
end

if img_type_list.M0sM1r.select % M1sM0r has been chosen
    img = fmean(SH2, f1, f2, ac.fs, j_win, gaussian_width);
    img_type_list.M0sM1r.image = img;
end

if img_type_list.velocity_estimate.select % Velocity Estimate has been chosen
   img_type_list.velocity_estimate.image = construct_velocity_video(SH2, f1, f2, ac.fs, j_win, gaussian_width, wavelength);
end

end