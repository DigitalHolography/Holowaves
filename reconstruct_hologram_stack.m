function hologram_stack = reconstruct_hologram_stack(FH, time_transform, acquisition, gaussian_width, use_gpu, svd, svdx, Nb_SubAp, phase_correction, stack_size)
    % Compute the moment of a batch of interferograms.
    % For more moment outputs, use reconstruct_hologram_extra, this function
    % only computes one output for speed
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
        % composite_(1|2|3): reduced frequency bands of M0 to create a composite
    %                    RGB image in post processing
    j_win = size(FH, 3);
    ac = acquisition;
    f1 = time_transform.f1;
    f2 = time_transform.f2;
    
    % move data to gpu if available
    if use_gpu
        if exist('phase_correction', 'var')
            phase_correction = gpuArray(phase_correction);
        end
    end
    
    %FIXME: can I mute it? Why doesn'it it work?
    % if exist('phase_correction', 'var') && ~isempty(phase_correction)
    %     FH = FH .* exp(-1i * phase_correction);
    % end
%     coefs = cell(1,1,1);
%     coefs{1,1,1} = [0 100 0];
%     [FH, ~] = rephase_FH_for_preview(FH, coefs, [3 4 5]);

    %% spatial filter
    mask = construct_mask(3, max(size(FH,1),size(FH,2)), size(FH, 1), size(FH, 2));
    FH = FH .* mask;


    H = ifft2(FH);
    clear FH;

    %% spatial filter z
    fftBuffer = fft(H);

    % Store buffers
    dcFilterBuffer = fftBuffer;
    trendFilterBuffer = fftBuffer;

    % Apply high pass filter to remove DC
    dcFilterBuffer(1:7,:,:) = 0;
    fringesAfterHighPassFilter = real(ifft(dcFilterBuffer));

    % Apply low pass filter to remove the trend
    trendFilterBuffer(1:size(H,1)-5,:,:) = 0;  

    H = fringesAfterHighPassFilter - trendFilterBuffer;


    %% SVD filtering
    if svd
        H = svd_filter(H, ac.fs/j_win, ac.fs);
    end

    if (svdx)
        H = svd_x_filter(H, time_transform.f1, ac.fs, Nb_SubAp);
    end

    %% calculate spectrogram
    SH = fft(H, [], 3);

    %% shifts related to acquisition wrong positioning
    SH = permute(SH, [2 1 3]);
    SH = circshift(SH, [-ac.delta_y, ac.delta_x, 0]);
    SH = (SH(:,:,1:floor(j_win/2)));

    tmp = abs(SH).^2;
    middle = ceil(size(SH,1)/2);
    profile = squeeze(mean(tmp(middle - 50 : middle + 50, middle - 50 : middle + 50, :),[1 2]));
    filter = ones(256, 1);
    filter(1 : 20) = 0;
    [~, peakLoc] = max(profile.*filter);
    enfaceLayer = SH(:, :, peakLoc);
    disp(peakLoc);

    figure;

    subplot(1,2,1); imagesc(rot90(abs(enfaceLayer))); title('Amplitude', 'FontSize', 24); axis square; axis off
    subplot(1,2,2); imagesc(rot90(angle(enfaceLayer))); title('Phase', 'FontSize', 24); axis square; axis off


    SH = real(SH).^2;
    hologram_stack = gather(SH);


end