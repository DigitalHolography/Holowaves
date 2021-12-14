function img = construct_colored_image(M_freq_low, M_freq_high, is_low_frequency)
% Constructs a colored image from hologram stacks made with different
% frequency bands
%
% M_freq_low: hologram stack made with a low frequency band
% M_freq_high: hologram stack made with a high frequency band
% is_low_frequency: true if the acquisity was made a low frequency, false
%                   otherwise

M_freq_low = squeeze(M_freq_low);
M_freq_high = squeeze(M_freq_high);
avg_M0_low = mean(M_freq_low, 3);
avg_M0_high = mean(M_freq_high, 3);

avg_M0_low = mat2gray(avg_M0_low);
avg_M0_high = mat2gray(avg_M0_high);

gw_p = 50;
if is_low_frequency
    avg_M0_low  = avg_M0_low ./ imgaussfilt(avg_M0_low, gw_p);
    avg_M0_high = avg_M0_high ./ imgaussfilt(avg_M0_high, gw_p);
    avg_M0_low  = mat2gray(avg_M0_low);
    avg_M0_high = mat2gray(avg_M0_high);
end

tol = [0.01 0.995];

low_high = stretchlim(avg_M0_low, tol);
avg_M0_low  = imadjust(avg_M0_low, low_high);

low_high = stretchlim(avg_M0_high, tol);
avg_M0_high = imadjust(avg_M0_high, low_high);

% composite generation
multiband_img = cat(3, avg_M0_low, avg_M0_high);
DCR_imgs = decorrstretch(multiband_img, 'tol', [0.2 0.998]);
img = imfuse(DCR_imgs(:,:,2), DCR_imgs(:,:,1), 'ColorChannels', 'red-cyan');
low_high = stretchlim(img, [0, 1]);
gamma_composite = 0.8;
img = imadjust(img, low_high, low_high, gamma_composite);
img = imsharpen(img, 'Radius', 10, 'Amount', 0.6);
end