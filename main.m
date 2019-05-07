%% reset environment
clear;
clc;
close all;

%% application constants

% input images size (512x512 pix)
nx = 512;
ny = 512;
pix_per_image = nx * ny;

% image batches constants
% interferogram images are processed in batches
% each batch produces a single momentum image
j_win = 64; % number of images in each batch
j_step = 512; % index offset between two image batches

fs = 60; % input video sampling frequency
f1 = 3;
f2 = 30;

% shifts to put center of the image at coord (0, 0)
delta_x = 0;
delta_y = 0;

% width of gaussian filter for the hologram flat field correction
gw = 35;

x_step = 28e-6;
y_step = 28e-6;

lambda = 789e-9; % laser wavelength

%% evaluate base functions on grid
% construct disc grid in polar coordinates
x = linspace(-1, 1, nx);
y = linspace(-1, 1, ny);
[X, Y] = meshgrid(x, y);
[theta, r] = cart2pol(X, Y);
indices = r <= sqrt(2); % [-1; 1] square excircle

% evaluate base functions
zernike_values = zeros(nx, ny, numel(n));
for k = 1:numel(n) % k= 1,2,3
    y = zernfun(n(k), m(k), r(indices), theta(indices), 'norm');
    zernike_values(:, :, k) = reshape(y(indices), nx, ny);
end

%% optimization parameters
% zernike base parameters
% see https://en.wikipedia.org/wiki/Zernike_polynomials
% we chose a polynomial base of 3 zernike polynomials:
% (n, m) = (2, -2): oblique astigmatism
% (n, m) = (2, 2): vertical astigmatism
% (n, m) = (2, 0): defocus
n = [2 2 2];
m = [-2 2 0];

% constraints over the base elements coefficients for optimization
min_constraint = [-30 -30 -1];
max_constraint = [30 30 1];

% initial coefficients guess
initial_guess = [0 0 0]; % no correction initially

%% video i/o
[data_filename, data_path] = uigetfile('.raw');
data_fullpath = fullfile(data_path, data_filename);
data_file_info = dir(data_fullpath);
num_images = data_file_info.bytes / (2*nx*ny);

% setup output directory
[~, name] = fileparts(data_filename);
output_dir = sprintf('%s_jwin=%d_jstep=%d', name, j_win, j_step);
mkdir(output_dir);

% setup video writers
video_wr_aberrated = VideoWriter(fullfile(output_dir, 'aberrated.avi'));
video_wr_phase_corrector = VideoWriter(fullfile(output_dir, 'phase_corrector.avi'));
video_wr_corrected = VideoWriter(fullfile(output_dir, 'corrected.avi'));

video_wr_aberrated.FrameRate = 25;
video_wr_aberrated.Quality = 100;
video_wr_phase_corrector.FrameRate = 25;
video_wr_phase_corrector.Quality = 100;
video_wr_corrected.FrameRate = 25;
video_wr_corrected.Quality = 100;

%% main loop
num_batches = floor((num_images - j_win) / j_step);
offsets = (0:num_batches) * j_step;

for offset = offsets
    %% read image batch
    data_fd = fopen(data_fullpath, 'r');
    fseek(data_fd, offset, 'bof');
    batch = fread(data_fd, pix_per_image * j_win, 'uint16=>double', 'b'); % big endian
    fclose(data_fd);
    batch = reshape(batch, nx, ny, j_win);
    batch = replace_dropped_frames(batch, 0.2);

    %% construct aberrated hologram
    moment_aberrated = compute_moment(batch, kernel, f1, f2, fs, delta_x, delta_y);
    % apply flat field correction
    moment_aberrated = moment_aberrated ./ imgaussfilt(moment_aberrated, gw);
    
    %% optimize zernike correction
    
    
    %% write frames to files
    open(video_wr_aberrated);
    open(video_wr_phase_corrector);
    open(video_wr_corrected);
    
    writeVideo(video_wr_aberrated, mat2gray(moment_aberrated));
    
    close(video_wr_aberrated);
    close(video_wr_phase_corrector);
    close(video_wr_corrected);
    
end





