classdef GuiCache
% A parameter cache to store parameters from GUI
% so that during computations, values are fetched from cache instead of GUI
% so that the user can modify the values in the GUI without messing
% everything up
properties (Access = public)
    batch_size
    ref_batch_size
    batch_stride
    spatialTransformation
    z
    z_retina
    z_iris
    z_switch
    time_transform  % object with : type of transformation, f1, f2
    blur
    imageChoice
    wavelength
    Fs
    pix_width
    pix_height
    registration
    iterative_registration
    temporal_filter_flag
    temporal_filter
    parallelism
    registration_via_phase
    aberration_compensation
    notes
    DX
    DY
    position_in_file
    output_videos
    low_memory
    rephasing
    OCTdata
    SVD
    save_raw
    
    % color image parameters
    color_f1
    color_f2
    color_f3
    low_frequency

    % dark field parameters
    xystride
    num_unit_cells_x
    r1
    
    % iterative optimization parameters
    iterative_aberration_compensation
    optimization_zernike_ranks
    mask_num_iter
    zernikes_tol
    max_constraint
    
    % shack-hartmann parameters
    shack_hartmann_aberration_compensation
    shack_hartmann_zernike_ranks
    num_subapertures
    subaperture_margin
    SubAp_PCA;
    minSubAp_PCA;
    maxSubAp_PCA;

    %masks
    artery_mask;
end
methods (Access = public)
    function obj = GuiCache()
        % do nothing
    end
end
end