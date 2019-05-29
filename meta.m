% Meta script - Corrects aberrations from .raw video file
% Available methods:
%   1 - Numerical Shack-Hartmann simulation
%   2 - Entropy optimization

% load parameters from config file
config;

% get interferogram filename
[data_filename, data_path] = uigetfile('.raw');

%% Construct InterferogramStream object
fullpath = fullfile(data_path, data_filename);
acquisition = DopplerAcquisition(Nx, Ny, fs, z, delta_x, delta_y, x_step, y_step);
interferogram_stream = InterferogramStream(fullpath, endianness,acquisition, ...
                                           j_win, j_step);
             
%% Select which method to use                                
switch method
    case 1
        shack_hartmann = ShackHartmann(n_pup, n_mode, interp_factor);
    case 2
        entropy_opt = EntropyOptimization(f1, f2, n, m, min_constraint, ...
                                          max_constraint, initial_guess, ...
                                          mask_radiuses);
    otherwise
        error('Method does not exist. Use 1 for Shack Hartmann or 2 for entropy optimization')
end

%% Construct objects common to all methods
% wave propagation kernel
kernel = propagation_kernel(Nx, Ny, z, lambda, x_step, y_step, use_double_precision);

%% video i/o
data_fullpath = fullfile(data_path, data_filename);
data_file_info = dir(data_fullpath);
num_images = data_file_info.bytes / (2*Nx*Ny);

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

open(video_wr_aberrated);
open(video_wr_phase_corrector);
open(video_wr_corrected);

%% Main loop
num_batches = interferogram_stream.num_frame_batches();

for batch_idx = 1:num_batches
    frame_batch = interferogram_stream.read_batch(batch_idx);
    
    %% interferograms pre-treatment
    FH = fftshift(fft2(frame_batch));
    FH = FH .* kernel;
    
    %% compute aberrated hologram
    hologram_aberrated = reconstruct_hologram(FH, f1, f2, acquisition, gaussian_width, enable_hardware_acceleration);
    
    %% perform aberration compensation with selected method
    switch method
        case 1
            % Shack Hartmann
            [M_aso, found] = shack_hartmann.fetch_M_aso_from_cache('M_aso');
            if ~found
                M_aso = shack_hartmann.construct_M_aso(acquisition, gaussian_width, enable_hardware_acceleration);            
            end
            % rename shift_array
            shifts = shack_hartmann.compute_images_shifts(FH, false, acquisition, f1, f2, gaussian_width, enable_hardware_acceleration);
            shifts = reshape(shifts, size(shifts,1)*size(shifts,2), 1);

            Y = cat(1, real(shifts), imag(shifts));
            M_aso_concat = cat(1,real(M_aso),imag(M_aso));
            X = pinv(M_aso_concat) * Y;
        case 2
            % Entropy optimization
            X = entropy_opt.optimize(FH, f1, f2, acquisition, gaussian_width, 0.4, enable_hardware_acceleration);
    end
    
    %% apply correction
    phase_correction = compute_phase_correction(X, zernike_eval);
    hologram_corrected = reconstruct_hologram(FH, f1, f2, acquisition, gaussian_width, enable_hardware_acceleration, phase_correction);
    
    %% write video files
    writeVideo(video_wr_aberrated, mat2gray(hologram_aberrated));
    writeVideo(video_wr_phase_corrector, mat2gray(phase_correction));
    writeVideo(video_wr_corrected, mat2gray(hologram_corrected));
end

close(video_wr_aberrated);
close(video_wr_phase_corrector);
close(video_wr_corrected);

