function img_type_list = construct_image(FH, wavelength, acquisition, gaussian_width, use_gpu, svd, svdx, Nb_SubAp, phase_correction,...
                                                                  color_f1, color_f2, color_f3, img_type_list, is_low_frequency , ...
                                                                  spatial_transformation, time_transform, SubAp_PCA, xy_stride, num_unit_cells_x, r1, ...
                                                                  local_temporal, phi1, phi2, local_spatial, nu1, nu2, ...
                                                                  artery_mask)

% [~, phase ] = zernike_phase([ 4 ], 512, 512);
% phase = 30 * 0.5 * phase;
% phase_mask =  exp(1i * phase);
% phase_mask = imresize(phase_mask, [size(FH,1) size(FH,2)]);
% figure;
% imagesc(angle(phase_mask));
% FH = FH .* phase_mask;

% FIXME : replace ifs by short name functions
j_win = size(FH, 3);
ac = acquisition;
%artery_mask = flip(artery_mask);

% move data to gpu if available
if use_gpu
    if exist('phase_correction', 'var')
        phase_correction = gpuArray(phase_correction);
    end
end

if (SubAp_PCA.Value)
    FH = subaperture_PCA(FH, SubAp_PCA, acquisition, svd, time_transform.f1, time_transform.f2, gaussian_width);
end

if exist('phase_correction', 'var') && ~isempty(phase_correction)
    FH = FH .* exp(-1i * phase_correction);
end



% if we want dark field preview H is calculated by dark field function
if img_type_list.dark_field_image.select
    %for now we assume that both spatial transforms are the same
    H = dark_field(FH, ac.z_retina, spatial_transformation, ac.z_iris, spatial_transformation, ac.lambda, ac.x_step, ac.y_step, xy_stride, time_transform.f1, time_transform.f2, ac.fs, num_unit_cells_x, r1); 
    img_type_list.dark_field_image.H = H;
else
    switch spatial_transformation
        case 'angular spectrum'
            H = ifft2(FH);
        case 'Fresnel'
            H = fftshift(fft2(FH));
%             H = fftshift(ifft2(FH));
    end
    
end
%% SVD filtering


if svd
    H = svd_filter(H, time_transform.f1, ac.fs);
end

if (svdx)
    H = svd_x_filter(H, time_transform.f1, ac.fs, Nb_SubAp);
end


if local_spatial
    H = local_spatial_PCA(H, nu1, nu2);
end

if local_temporal
    H = local_temporal_PCA(H, phi1, phi2);
end

clear FH;







img_type_list.spectrogram.H = H;


%% Compute moments based on dropdown value
if is_low_frequency
    sign = -1;
else 
    sign = 1;
end


switch time_transform.type
    case 'PCA' % if the time transform is PCA
        SH = short_time_PCA(H);
    case 'FFT' % if the time transform is FFT
        SH = fft(H, [], 3);
end

f1 = time_transform.f1;
f2 = time_transform.f2;
n1 = time_transform.min_PCA;
n2 = time_transform.max_PCA;

% clear("H");
SH = abs(SH).^2;

%% shifts related to acquisition wrong positioning
SH = permute(SH, [2 1 3]);
SH = circshift(SH, [-ac.delta_y, ac.delta_x, 0]);


if img_type_list.pure_PCA.select
    img_type_list.pure_PCA.image = cumulant(SH, n1, n2);
    img_type_list.pure_PCA.image = flat_field_correction(img_type_list.pure_PCA.image, gaussian_width);
end

if img_type_list.dark_field_image.select
    img_type_list.dark_field_image.image = log(flat_field_correction(moment0(SH, f1, f2, ac.fs, j_win, gaussian_width),gaussian_width));
end

if img_type_list.phase_variation.select
    %FIXME : ecraser H
    C = angle(phase_fluctuation(H));
    C = permute(C, [2 1 3]);
    img_type_list.phase_variation.image = moment0(SH, f1, f2, ac.fs, j_win, gaussian_width);
end

if img_type_list.power_Doppler.select % Power Doppler has been chosen
    [img, sqrt_img] = moment0(SH, f1, f2, ac.fs, j_win, gaussian_width);
    img_type_list.power_Doppler.M0_sqrt = sqrt_img;
    img_type_list.power_Doppler.image = img;

    %save image for study
%     img = mat2gray(img);
%     [file_name, suffix] = get_last_file_name('C:\Users\Philadelphia\Pictures\local_spatial_220314', 'power', 'png');
%     imwrite(img, fullfile('C:\Users\Philadelphia\Pictures\local_spatial_220314', sprintf("%s_%d.png", file_name, suffix + 1)));
end

if img_type_list.power_1_Doppler.select % Power 1 Doppler has been chosen
    img = moment1(SH, f1, f2, ac.fs, j_win, gaussian_width);
    [img0,~] = moment0(SH, f1, f2, ac.fs, j_win, 0);
    img = img./mean(img0(:));
    img_type_list.power_1_Doppler.image = img;
end

if img_type_list.power_2_Doppler.select % Power 2 Doppler has been chosen
    %% FIXME: from now on Power 2 Doppler becomes frequency RMS
    img2 = moment2(SH, f1, f2, ac.fs, j_win, 0); %0 35
    %moment 1
    [img0,~] = moment0(SH, f1, f2, ac.fs, j_win, 0); %0 35
    %     img_type_list.power_2_Doppler.image = img2./img0;
    %     img_type_list.power_2_Doppler.image = img2./mean(img0(128:384,128:384),[1 2]);
    %     img_type_list.power_2_Doppler.image = sqrt(img2./img0);
    img_type_list.power_2_Doppler.image = sqrt(img2./mean(img0(:)));
end

if img_type_list.color_Doppler.select  % Color Doppler has been chosen
    [freq_low, freq_high] = composite(SH, color_f1, color_f2, color_f3, ac.fs, j_win, gaussian_width);
    img_type_list.color_Doppler.freq_low = freq_low;
    img_type_list.color_Doppler.freq_high = freq_high;
    img_type_list.color_Doppler.image = construct_colored_image(sign * gather(freq_low), sign * gather(freq_high), is_low_frequency);
end

if img_type_list.directional_Doppler.select % Directional Doppler has been chosen
    [M0_pos, M0_neg] = directional(SH, f1, f2, ac.fs, j_win, gaussian_width);
    img_type_list.directional_Doppler.M0_pos = M0_pos;
    img_type_list.directional_Doppler.M0_neg = M0_neg;
    img_type_list.directional_Doppler.image = construct_directional_image(sign * gather(M0_pos), sign *gather(M0_neg), is_low_frequency);
end

if img_type_list.M0sM1r.select % M1sM0r has been chosen
    img = fmean(SH, f1, f2, ac.fs, j_win, gaussian_width);
    img_type_list.M0sM1r.image = img;
end

if img_type_list.velocity_estimate.select % Velocity Estimate has been chosen
   img_type_list.velocity_estimate.image = construct_velocity_video(SH, f1, f2, ac.fs, j_win, gaussian_width, wavelength);
end

if img_type_list.spectrogram.select
%     bin_x = 2;
%     bin_y = 2;
%     bin_t = 1;
%     bin_w = 16;
    cubeTargetSize = 256;
    cubeFreqLength = 32 ;
    %img_type_list.spectrogram.SH = SH(1:bin_x:end,1:bin_y:end,1:bin_w:end);
    img_type_list.spectrogram.SH = imresize3(SH,[cubeTargetSize cubeTargetSize cubeFreqLength],'Method','linear');
    img_type_list.spectrogram.vector = zeros(1,j_win);
    img_type_list.spectrogram.image = zeros(size(SH, 1), size(SH, 2));
    %     tmp = zeros(size(SH,1), size(SH,2), 1, size(SH,3),'single');
    %     for ii = 1:size(SH,3)
    %         tmp(:,:,1,ii)  = SH(:,:,ii);
    %     img_type_list.spectrogram.SH = tmp;
    %
    %     %     figure(111)
    %     %     imagesc(artery_mask);
    %     n1 = ceil(f1 * j_win / ac.fs);
    %     n2 = ceil(f2 * j_win / ac.fs);
    %
    %     % symetric integration interval
    %     n3 = j_win - n2 + 1;
    %     n4 = j_win - n1 + 1;
    %     SH = abs(SH);
end


 if img_type_list.moment0.select % Power 1 Doppler has been chosen
    [img, sqrt_img] = moment0(SH, f1, f2, ac.fs, j_win, 0);
    img_type_list.moment0.image = img;
    img_type_list.moment0.sqrt_img = sqrt_img;
 end

 if img_type_list.moment1.select % Power 1 Doppler has been chosen
    img = moment1(SH, f1, f2, ac.fs, j_win, 0);
    img_type_list.moment1.image = img;
 end

 if img_type_list.moment2.select % Power 1 Doppler has been chosen
    img = moment2(SH, f1, f2, ac.fs, j_win, 0);
    img_type_list.moment2.image = img;
 end

%     moment = squeeze(sum(SH(:, :, n1:n2), 3)) + squeeze(sum(SH(:, :, n3:n4), 3));
%     blurred_moment = imgaussfilt(moment, gaussian_width);

%     ms = sum(SH, [1 2]);
%     SH = SH./ blurred_moment;
%       SH_mean = squeeze(mean(SH, [1 2]));
%       ms = squeeze(sum(SH_mean, "all"));
% %       artery_neighborhood_mask = imbinarize(imgaussfilt(single(artery_mask), 100));
% %       figure;
% %       imagesc(artery_neighborhood_mask);
% 
% %       SH_mean  = squeeze(sum(SH .*artery_neighborhood_mask, [1 2]) ./ nnz(artery_neighborhood_mask));
% %     ms2 = sum(SH, [1 2]);
% %     corrected_image = (ms / ms2) .* image;
% 
%     if ~isempty(artery_mask)
%         SH_artery  = squeeze(sum(SH .*artery_mask,[1 2]) ./ nnz(artery_mask));
%         ma = squeeze(sum(SH_artery, "all"));
%         SH_artery  = (SH_artery)*(ms/ma) - SH_mean;
%         SH_artery(SH_artery < 0) = 1;
%         % normalize : squeeze(mean(SH_mean(2:end, :), 1));
% %         SH_artery = SH_artery ./ SH_norm;
%         SH_artery(1:1) = 0;
% %         SH_artery(n2:n3) = 0;
%         SH_artery(end-1:end) = 0;
%         SH_artery = fftshift(SH_artery);
%         img_type_list.spectrogram.image = mat2gray(single(artery_mask));
% 
%         %SH_artery = SH_artery./ movmean(SH_artery, 25);
%         img_type_list.spectrogram.vector = SH_artery;
%     else

%     end
%     img_type_list.spectrogram.H = SH;

end