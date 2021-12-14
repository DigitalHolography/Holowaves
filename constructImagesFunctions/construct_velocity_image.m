function img = construct_velocity_image(SH, f1, f2, fs, batch_size, gw, wavelength)

% % FIXME: batch_size = size(SH, 3)

SH = squeeze(SH);

SH_avg_xy = mean(SH, [1 2]);

% spectral flat field correction
for ii = 1:batch_size
    SH(:,:,ii) = SH(:,:,ii) - SH_avg_xy(ii);
end

% enforce positivity
SH = max(SH,0); 

% spatial flat field correction 
SH_sum_xy = sum(SH, [1 2]);
SH_filtered = imgaussfilt(SH, gw);
SH_filtered = SH_filtered + eps(SH_filtered(1,1,1));
SH = SH ./ SH_filtered;

% renormalization
SH_filtered_avg_xy = sum(SH, [1 2]);
SH = SH .* SH_sum_xy ./ SH_filtered_avg_xy;

% compute spectral moment images
moment_1_image = moment1(SH, f1, f2, fs, batch_size, gw); 
moment_0_image = moment0(SH, f1, f2, fs, batch_size, gw);
1;
% compute average frequency image from hyperspectral image
frequency_image = moment_1_image * 1e3; %kHz
frequency_image = frequency_image ./ imgaussfilt(moment_0_image, 64);

index = 1.33; % optical index
velocity = (frequency_image * wavelength) / (2 * index); % m/s 
% velocity = log10(abs(velocity));

% construct velocity image
img = mat2gray(velocity);
img = ind2rgb(uint16(65535 * img), colormap_redblue(65536));
img = gather(img);
end   