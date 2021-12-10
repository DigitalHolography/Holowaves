function v = construct_velocity_video(SH, f1, f2, fs, batch_size, gw, wavelength)

% FIXME: batch_size = size(SH, 3)

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
SH_filtered_avg_xy = sum(SH, [1 2]);
SH = SH .* SH_sum_xy ./ SH_filtered_avg_xy;

moment_1 = moment1(SH, f1, f2, fs, batch_size, gw); 
moment_0 = moment0(SH, f1, f2, fs, batch_size, gw);

frequency = moment_1 * 1e3; %kHz
frequency = frequency ./ imgaussfilt(moment_0, 64);

index = 1.5; %optical index
velocity = (frequency * wavelength) / (2 * index); % m/s 

v = mat2gray(velocity);
v = ind2rgb(uint16(65535 * v), colormap_redblue(65536));
v = gather(v);
end   