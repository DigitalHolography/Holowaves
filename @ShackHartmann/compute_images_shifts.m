function [shifts,moment_chunks_crop_array,correlation_chunks_array] = compute_images_shifts(obj, FH, f1, f2, gw, calibration, enable_svd, acquisition)
    
    % SubAp_margin
    % SubAp_idx < SubAp_idx
    % SubAp_idy < SubAp_idy
    % SubAp_Nx < n_SubAp Attention : Nx = nb de pixels et non nb de subAp
    % SubAp_Ny
    
    % FH: a preprocessed interferogram batch - already in the fourier plan
    % calibration: a boolean flag to compute shifts from a 2d phase array, e.g. FH(x,y) = exp(1i*phi(x,y))
    % in calibration mode, "compute_images_shifts" is called for each Zernike
    % mode FH(x,y) = exp(1i*ai Zi).
    % acquisition: experimental data
    % f1, f2: integration frequency bounds for power Doppler hologram
    % gaussian_width: size of gaussian filter for hologram reconstruction
    % use_gpu
    
    % the output moment_chunks is 2D (x,y) in measurement mode, and 3D (x,y,#chunk) in calibration
    % mode
    
    %Note:
    %2d index of subapertures in embedded "for" loops SubAp_idx, then SubAp_idy
    %(SubAp_idx-1)*floor(ac.Nx/obj.n_SubAp) + 1:SubAp_idx*floor(ac.Nx/obj.n_SubAp), (SubAp_idy-1)*floor(ac.Ny/obj.n_SubAp) + 1:SubAp_idy*floor(ac.Ny/obj.n_SubAp)
    %1d index of subapertures in embedded "for" loops SubAp_idx, then SubAp_idy
    %1 + (SubAp_idx - 1) + obj.n_SubAp * (SubAp_idy - 1)
    %1d index of ref subaperture
    %floor(obj.n_SubAp/2) * (obj.n_SubAp - 1)
    %2d index of ref subaperture
    % mid_SubAp = floor(obj.n_SubAp/2);
    %(mid_SubAp-1)*floor(ac.Nx/obj.n_SubAp) + 1:mid_SubAp*floor(ac.Nx/obj.n_SubAp),...
    %(mid_SubAp-1)*floor(ac.Ny/obj.n_SubAp) + 1:mid_SubAp*floor(ac.Ny/obj.n_SubAp)
    
    ac = acquisition;
    j_win = size(FH, 3);
    resize_ratio = 2;
    
    % shifts is a 1D vector
    % it maps the 2D SubApils grid by iterating column first
    % example of ordering for a 4x4 SubApil grid
    % 1  2  3  4
    % 5  6  7  8
    % 9  10 11 12
    % 13 14 15 16
    %
    shifts = zeros(obj.n_SubAp^2, 1);
    
    % reference SubApil
    % we take one of the four in the center as a reference
    % we then compute shifts of all images to the reference images
    % example : 6 here:
    % 1  2  3  4
    % 5  6  7  8
    % 9  10 11 12
    % 13 14 15 16
    ac.Nx = double(ac.Nx);
    ac.Nx = size(FH, 2);
    ac.Ny = ac.Nx;
    
    %render complete image
    if ~calibration
        H = ifft2(FH);
        if enable_svd
            H = svd_filter(H, f1, ac.fs);
        end
        SH = fft(H, [], 3);
        SH = abs(SH).^2;
        %     SH = permute(SH, [2 1 3]);
        M0 = moment0(SH, f1, f2, ac.fs, size(FH ,3), gw);
        M0 = flat_field_correction(M0, gw);
        M0 = imresize(M0, [ac.Ny/obj.n_SubAp ac.Nx/obj.n_SubAp]);
    end
%     M0 = mat2gray(M0);
%     figure; 
%     imshow(flip(M0));

    
    SubAp_idref = ceil(obj.n_SubAp/2); % Index of reference subaperture for correlations
    
    SubAp_init = max(1,floor(obj.SubAp_margin*floor(double(resize_ratio*ac.Nx)/obj.n_SubAp)));
    % SubAp_init = max(1,floor(double(ac.Nx)/obj.n_SubAp));
    SubAp_end = ceil(resize_ratio*ac.Nx/obj.n_SubAp - SubAp_init);
    
    %FIXME : make a flat mask at the center, with minimal apodization : DANGER xcorr
    %moment_chunk_mask = apodize_image(SubAp_end - SubAp_init + 1, SubAp_end - SubAp_init + 1, 5);
%     moment_chunk_mask  = ones(SubAp_end - SubAp_init + 1, SubAp_end - SubAp_init + 1);
    
    moment_chunks_array = zeros(ac.Nx,ac.Ny); %Stitched PowerDoppler moments in each subaperture
    moment_chunks_crop_array = zeros(resize_ratio*ac.Nx,resize_ratio*ac.Ny);%Stitched cropped PowerDoppler moments in each subaperture
    SubAp_id_range = [SubAp_idref:obj.n_SubAp 1:SubAp_idref-1];
    correlation_chunks_array = zeros((SubAp_end-SubAp_init+floor(ac.Nx/obj.n_SubAp))*obj.n_SubAp); %Stitched cropped correlations in each subaperture
    gw = (100 * (ac.Nx/obj.n_SubAp)/512)/obj.n_SubAp;
%     gw = 60;

    correlation_coef = zeros(1,obj.n_SubAp^2);

    for SubAp_idy = SubAp_id_range
        for SubAp_idx = SubAp_id_range
            %% Construction of subapertures
            
            % get the current index range and reference index ranges
            idx_range = (SubAp_idx-1)*floor(ac.Nx/obj.n_SubAp)+1:SubAp_idx*floor(ac.Nx/obj.n_SubAp);
            idy_range = (SubAp_idy-1)*floor(ac.Ny/obj.n_SubAp)+1:SubAp_idy*floor(ac.Ny/obj.n_SubAp);
            idx_range_ref = (SubAp_idref-1)*floor(ac.Nx/obj.n_SubAp)+1:SubAp_idref*floor(ac.Nx/obj.n_SubAp);
            idy_range_ref = (SubAp_idref-1)*floor(ac.Ny/obj.n_SubAp)+1:SubAp_idref*floor(ac.Ny/obj.n_SubAp);
            % get the current image chunk
            FH_chunk = FH(idy_range,idx_range,:);
            % propagate wave
            if calibration
                moment_chunk = abs(fftshift(fftshift(ifft2(FH_chunk),1),2)).^2;
            else
                moment_chunk = obj.reconstruct_moment_chunk(FH_chunk, enable_svd, f1, f2, ac.fs, gw);
            end % calibration

            if sum(moment_chunk(:))~=0
                moment_chunk = moment_chunk-mean(moment_chunk(:)); %centering
                moment_chunk = moment_chunk/max(moment_chunk(:)); %normalisation
            end
           
            moment_chunks_array(idy_range,idx_range) = moment_chunk;
%             original_size_moment_chunk = moment_chunk;
            moment_chunk = imresize(moment_chunk, resize_ratio);

%             moment_chunk = imgaussfilt(moment_chunk,2);
            moment_chunk = mat2gray(moment_chunk);
%             moment_chunk = logical(imbinarize(moment_chunk, 'adaptive', 'ForegroundPolarity', 'bright', 'Sensitivity', 0.5));
%             moment_chunk = logical(imbinarize(moment_chunk));


            %% Computation of the correlations between subapertures
            % get the reference image chunk
            if sum(moment_chunk(:))~=0
                %% Computation of the correlations between subapertures
                % get the reference image chunk
                if calibration
                    moment_chunk_ref = moment_chunks_array(idx_range_ref,idy_range_ref);
                else
                    moment_chunk_ref = M0;
                end
                % FIXME
                moment_chunk_ref = imresize(moment_chunk_ref, resize_ratio);
                % compute auxilliary correlation between current and reference image chunk
                moment_chunk_cropped = moment_chunk(SubAp_init:SubAp_end,SubAp_init:SubAp_end);
                %% FIXME additional processing
%                 moment_chunk_ref = imgaussfilt(moment_chunk_ref,2);
                moment_chunk_ref = mat2gray(moment_chunk_ref);
%                 moment_chunk_ref = logical(imbinarize(moment_chunk_ref, 'adaptive', 'ForegroundPolarity', 'bright', 'Sensitivity', 0.5));
%                 moment_chunk_ref = logical(imbinarize(moment_chunk_ref));
                
%                 moment_chunk_cropped_original = original_size_moment_chunk(SubAp_init:SubAp_end,SubAp_init:SubAp_end) .* moment_chunk_mask;
                c_aux = normxcorr2(moment_chunk_cropped,moment_chunk_ref);
%                 c_aux = normxcorr2(moment_chunk_cropped, M0);
                % margins (tails) to suppress in final correlation map
                inf_margin_corr = floor(obj.CorrMap_margin*size(c_aux,1));%floor((size(c_aux,1)+2*(SubAp_end-SubAp_init+1))/4);
                sup_margin_corr = size(c_aux,1)-inf_margin_corr;%floor((3*size(c_aux,1)-2*(SubAp_end-SubAp_init+1))/4);
                % correlation map, with zeros in margins
                c = zeros(size(c_aux));
                c(inf_margin_corr:sup_margin_corr,inf_margin_corr:sup_margin_corr)=c_aux(inf_margin_corr:sup_margin_corr,inf_margin_corr:sup_margin_corr);
                % sub pixel assesment of max of correlation peak
                aa = length((SubAp_idx-1)*size(correlation_chunks_array,1)/obj.n_SubAp+1:SubAp_idx*size(correlation_chunks_array,1)/obj.n_SubAp);
                bb = length((SubAp_idy-1)*size(correlation_chunks_array,2)/obj.n_SubAp+1:SubAp_idy*size(correlation_chunks_array,2)/obj.n_SubAp);
                
                correlation_chunks_array((SubAp_idx-1)*size(correlation_chunks_array,1)/obj.n_SubAp+1:SubAp_idx*size(correlation_chunks_array,1)/obj.n_SubAp,(SubAp_idy-1)*size(correlation_chunks_array,2)/obj.n_SubAp+1:SubAp_idy*size(correlation_chunks_array,2)/obj.n_SubAp)=c(1:aa, 1:bb);
                % find correlation peak
                [xpeak_aux, ypeak_aux] = find(c==max(c(:)));

                if ~calibration
                    correlation_coef(1 + (SubAp_idx - 1) + obj.n_SubAp * (SubAp_idy - 1)) = c(xpeak_aux, ypeak_aux);
                end
                xpeak = xpeak_aux+0.5*(c(xpeak_aux-1,ypeak_aux)-c(xpeak_aux+1,ypeak_aux))/(c(xpeak_aux-1,ypeak_aux)+c(xpeak_aux+1,ypeak_aux)-2.*c(xpeak_aux,ypeak_aux));
                ypeak = ypeak_aux+0.5*(c(xpeak_aux,ypeak_aux-1)-c(xpeak_aux,ypeak_aux+1))/(c(xpeak_aux,ypeak_aux-1)+c(xpeak_aux,ypeak_aux+1)-2.*c(xpeak_aux,ypeak_aux));
                xoffSet = ceil(size(c, 1)/2) - xpeak;
                yoffSet = ceil(size(c, 2)/2) - ypeak;
                % compute shift between images
                %                 shift_curr = xoffSet + 1i * yoffSet;
                shift_curr = (xoffSet + 1i * yoffSet)/resize_ratio;
                shifts(1 + (SubAp_idx - 1) + obj.n_SubAp * (SubAp_idy - 1)) = shift_curr(1); %To be sure no double correlation maximum
            else
                shifts(1 + (SubAp_idx - 1) + obj.n_SubAp * (SubAp_idy - 1)) = 0+1i*0;
            end
    
            % to show sub-apertures used in correlation        
            idx_range_out = (SubAp_idx-1)*floor(resize_ratio*ac.Nx/obj.n_SubAp)+SubAp_init:(SubAp_idx-1)*floor(resize_ratio*ac.Nx/obj.n_SubAp)+SubAp_init+numel(SubAp_init:SubAp_end)-1;
            idy_range_out = (SubAp_idy-1)*floor(resize_ratio*ac.Ny/obj.n_SubAp)+SubAp_init:(SubAp_idy-1)*floor(resize_ratio*ac.Ny/obj.n_SubAp)+SubAp_init+numel(SubAp_init:SubAp_end)-1;
            
            moment_chunks_crop_array(idy_range_out,idx_range_out) = moment_chunk_cropped;
    
        end %SubAp_idy
    end %SubAp_idx

%% Second loop for inter-strides
% parameters
vx = obj.n_SubAp_inter ; % num of SubAp between 2 initial SubAps in x direction 
vy = obj.n_SubAp_inter ; % num of SubAp between 2 initial SubAps in y direction 
Nxx = floor(ac.Nx/obj.n_SubAp); % size of new SubAp in x
Nyy = floor(ac.Nx/obj.n_SubAp); % size of new SubAp in y

% structures
moment_inter_chunks_array = zeros(ac.Nx, ac.Ny); %Stitched PowerDoppler moments in each subaperture
moment_inter_chunks_crop_array = zeros(resize_ratio*ac.Nx,resize_ratio*ac.Ny);
correlation_coef_inter = zeros(obj.n_SubAp, obj.n_SubAp, vx + 1, vy + 1);
% shifts_inter = zeros((obj.n_SubAp-1)*(vx*vy*(obj.n_SubAp-1)+(vx+vy)*obj.n_SubAp),1); 
% pos_inter = zeros((obj.n_SubAp-1)*(vx*vy*(obj.n_SubAp-1)+(vx+vy)*obj.n_SubAp),2);
shifts_inter = zeros(obj.n_SubAp, obj.n_SubAp, vx + 1, vy + 1);
pos_inter = zeros(obj.n_SubAp, obj.n_SubAp, vx + 1, vy + 1, 2);


for SubAp_idy = 1 : obj.n_SubAp
    for SubAp_idx = 1 : obj.n_SubAp
        % original subaperture offset
        idx_offset = (SubAp_idx - 1)*floor(ac.Nx/obj.n_SubAp);
        idy_offset = (SubAp_idy - 1)*floor(ac.Ny/obj.n_SubAp);

        if (SubAp_idy == obj.n_SubAp)
            vy_max = 0;
        else
            vy_max = vy;
        end
        if (SubAp_idx == obj.n_SubAp)
            vx_max = 0;
        else
            vx_max = vx;
        end

        for inter_SubAp_idy = 0 : vy_max
            for inter_SubAp_idx = 0 : vx_max

                if inter_SubAp_idy ~= 0 || inter_SubAp_idx ~= 0
                    %% Construction of subapertures
                    % get the current index range and reference index ranges
                    stride_x = floor(Nxx/(vx + 1));
                    stride_y = floor(Nyy/(vy + 1));

                    idx_range = idx_offset + stride_x * (inter_SubAp_idx) + 1 : idx_offset + stride_x * (inter_SubAp_idx) + Nxx;
                    idy_range = idy_offset + stride_y * (inter_SubAp_idy) + 1 : idy_offset + stride_y * (inter_SubAp_idy) + Nyy;
                    % get the current image chunk
%                     disp([SubAp_idy SubAp_idx inter_SubAp_idy inter_SubAp_idx]);
%                     disp([idx_offset]);
                    
                    FH_inter_chunk = FH(idy_range,idx_range,:);
                    % propagate wave
                    if calibration
                        moment_inter_chunk = abs(fftshift(fftshift(ifft2(FH_inter_chunk),1),2)).^2;
                    else
                        moment_inter_chunk = obj.reconstruct_moment_chunk(FH_inter_chunk, enable_svd, f1, f2, ac.fs, gw);
                    end % calibration

                    if sum(moment_inter_chunk(:))~=0
                        moment_inter_chunk = moment_inter_chunk-mean(moment_inter_chunk(:)); %centering
                        moment_inter_chunk = moment_inter_chunk/max(moment_inter_chunk(:)); %normalisation
                    end

                    %

                    moment_inter_chunks_array(idy_range,idx_range) = moment_inter_chunk;
                    %             original_size_moment_chunk = moment_chunk;
                    moment_inter_chunk = imresize(moment_inter_chunk, resize_ratio);
                    %             moment_chunk = imgaussfilt(moment_chunk,2);
                    moment_inter_chunk = mat2gray(moment_inter_chunk);
                    %             moment_chunk = logical(imbinarize(moment_chunk, 'adaptive', 'ForegroundPolarity', 'bright', 'Sensitivity', 0.5));
                    %             moment_chunk = logical(imbinarize(moment_chunk));


                    %% Computation of the correlations between subapertures
                    % get the reference image chunk
                    if sum(moment_inter_chunk(:))~=0
                        %% Computation of the correlations between subapertures
                        % get the reference image chunk
                        % FIXME
                        % no need for calculation of reference chunk because it
                        % didn't change
                        % compute auxilliary correlation between current and reference image chunk
                        moment_inter_chunk_cropped = moment_inter_chunk(SubAp_init:SubAp_end,SubAp_init:SubAp_end);

                        %                 moment_chunk_cropped_original = original_size_moment_chunk(SubAp_init:SubAp_end,SubAp_init:SubAp_end) .* moment_chunk_mask;
                        c_aux = normxcorr2(moment_inter_chunk_cropped,moment_chunk_ref);
                        %                 c_aux = normxcorr2(moment_chunk_cropped, M0);
                        % margins (tails) to suppress in final correlation map
                        inf_margin_corr = floor(obj.CorrMap_margin*size(c_aux,1));%floor((size(c_aux,1)+2*(SubAp_end-SubAp_init+1))/4);
                        sup_margin_corr = size(c_aux,1)-inf_margin_corr;%floor((3*size(c_aux,1)-2*(SubAp_end-SubAp_init+1))/4);
                        % correlation map, with zeros in margins
                        c = zeros(size(c_aux));
                        c(inf_margin_corr:sup_margin_corr,inf_margin_corr:sup_margin_corr)=c_aux(inf_margin_corr:sup_margin_corr,inf_margin_corr:sup_margin_corr);
                        % sub pixel assesment of max of correlation peak
                        %                 aa = length((SubAp_idx-1)*size(correlation_chunks_array,1)/obj.n_SubAp+1:SubAp_idx*size(correlation_chunks_array,1)/obj.n_SubAp);
                        %                 bb = length((SubAp_idy-1)*size(correlation_chunks_array,2)/obj.n_SubAp+1:SubAp_idy*size(correlation_chunks_array,2)/obj.n_SubAp);
                        %
                        %                 correlation_chunks_array((SubAp_idx-1)*size(correlation_chunks_array,1)/obj.n_SubAp+1:SubAp_idx*size(correlation_chunks_array,1)/obj.n_SubAp,(SubAp_idy-1)*size(correlation_chunks_array,2)/obj.n_SubAp+1:SubAp_idy*size(correlation_chunks_array,2)/obj.n_SubAp)=c(1:aa, 1:bb);
                        %                 % find correlation peak
                        [xpeak_aux, ypeak_aux] = find(c==max(c(:)));

                        if ~calibration
                            correlation_coef_inter(SubAp_idx, SubAp_idy, inter_SubAp_idx + 1, inter_SubAp_idy + 1) = c(xpeak_aux, ypeak_aux);
                        end
                        xpeak = xpeak_aux+0.5*(c(xpeak_aux-1,ypeak_aux)-c(xpeak_aux+1,ypeak_aux))/(c(xpeak_aux-1,ypeak_aux)+c(xpeak_aux+1,ypeak_aux)-2.*c(xpeak_aux,ypeak_aux));
                        ypeak = ypeak_aux+0.5*(c(xpeak_aux,ypeak_aux-1)-c(xpeak_aux,ypeak_aux+1))/(c(xpeak_aux,ypeak_aux-1)+c(xpeak_aux,ypeak_aux+1)-2.*c(xpeak_aux,ypeak_aux));
                        xoffSet = ceil(size(c, 1)/2) - xpeak;
                        yoffSet = ceil(size(c, 2)/2) - ypeak;
                        % compute shift between images
                        shift_curr = (xoffSet + 1i * yoffSet)/resize_ratio;
                        shifts_inter(SubAp_idx, SubAp_idy, inter_SubAp_idx + 1, inter_SubAp_idy + 1) = shift_curr(1);
                        pos_inter(SubAp_idx, SubAp_idy, inter_SubAp_idx + 1, inter_SubAp_idy + 1, 1) = floor(idx_range(1) + (idx_range(end) - idx_range(1))/2) ;
                        pos_inter(SubAp_idx, SubAp_idy, inter_SubAp_idx + 1, inter_SubAp_idy + 1, 2) = floor(idy_range(1) + (idy_range(end) - idy_range(1))/2) ;
                         
                    else
                        shifts_inter(SubAp_idx, SubAp_idy, inter_SubAp_idx, inter_SubAp_idy) = 0+1i*0;
                        pos_inter(SubAp_idx, SubAp_idy, inter_SubAp_idx + 1, inter_SubAp_idy + 1, 1) = floor(idx_range(1) + (idx_range(end) - idx_range(1))/2 ) ;
                        pos_inter(SubAp_idx, SubAp_idy, inter_SubAp_idx + 1, inter_SubAp_idy + 1, 2) = floor(idy_range(1) + (idy_range(end) - idy_range(1))/2) ;
                    end
                    %disp(pos_inter(crt,:))
                   
                    % to show sub-apertures used in correlation
                    idx_offset_out = resize_ratio * (SubAp_idx - 1)*floor(ac.Nx/obj.n_SubAp);
                    idy_offset_out = resize_ratio * (SubAp_idy - 1)*floor(ac.Ny/obj.n_SubAp);

                    stride_x = resize_ratio * floor(Nxx/(vx + 1));
                    stride_y = resize_ratio * floor(Nyy/(vy + 1));

                    idx_range_out = idx_offset_out + stride_x * (inter_SubAp_idx) + 1 + SubAp_init: idx_offset_out + stride_x * (inter_SubAp_idx) + SubAp_init + numel(SubAp_init:SubAp_end);
                    idy_range_out = idy_offset_out + stride_y * (inter_SubAp_idy) + 1 + SubAp_init : idy_offset_out + stride_y * (inter_SubAp_idy) + SubAp_init + numel(SubAp_init:SubAp_end);

                    moment_inter_chunks_crop_array(idy_range_out,idx_range_out) = moment_chunk_cropped;
                end % inter_SubAp_idy ~= 0 || inter_SubAp_idx ~= 0
            end %inter_SubAp_idy
        end %inter_SubAp_idx
    end %SubAp_idy
end %SubAp_idx

img_centers = zeros(ac.Nx, ac.Ny);

pos_inter_tmp = reshape(pos_inter, obj.n_SubAp*obj.n_SubAp*(vx+1)*(vy+1), 2);
for i = 1:size(pos_inter_tmp,1)
    if pos_inter_tmp(i,1) ~= 0
        img_centers(pos_inter_tmp(i,1)-2:pos_inter_tmp(i,1)+2,pos_inter_tmp(i,2)-2:pos_inter_tmp(i,2)+2) = ones(5,5);
    end
end


figure(1)
imagesc(moment_inter_chunks_crop_array);
    
figure(2)
imagesc(moment_inter_chunks_array);
    
figure(3)
imagesc(img_centers);

shift_tab = zeros(size(pos_inter,1)*size(pos_inter,3), size(pos_inter,2)*size(pos_inter,4));   


    if ~calibration
%         plop = flip(plop');
%         for SubAp_idy = 1:obj.n_SubAp
%             for SubAp_idx = 1:obj.n_SubAp
%                 fprintf("%f   ", plop(SubAp_idy, SubAp_idx));
%             end
%             fprintf("\n");    
%         end
        correlation_threshold = mean(correlation_coef, "all") - std(correlation_coef, 1, "all");
       
        central_shift = shifts(ceil(length(shifts)/2));
        shifts = shifts - central_shift;
        shifts(correlation_coef < correlation_threshold) = NaN ;

%         figure(1);
%         imagesc(moment_chunks_array);
%         axis square;
%         axis off;
%         colormap gray;
    end


for ix = 1:obj.n_SubAp
    for iy = 1:obj.n_SubAp
        
        offsetx = size(pos_inter,3)*(ix-1);
        offsety = size(pos_inter,4)*(iy-1);
        shift_tab(offsetx+1 : offsetx +  size(pos_inter,3), offsety+1 : offsety +  size(pos_inter,4)) = shifts_inter(ix,iy,:,:);
        correlation_tab(offsetx+1 : offsetx +  size(pos_inter,3), offsety+1 : offsety +  size(pos_inter,4)) = correlation_coef_inter(ix,iy,:,:);
        shift_tab(offsetx+1, offsety+1) = shifts(1 + (ix - 1) + obj.n_SubAp * (iy - 1));
        correlation_tab(offsetx+1, offsety+1) = correlation_coef(1 + (ix - 1) + obj.n_SubAp * (iy - 1));

    end
end

shift_tab(:, end-vy+1:end) = [];
shift_tab(end-vx+1 : end, :) = [];

correlation_tab(:, end-vy+1:end) = [];
correlation_tab(end-vx+1 : end, :) = [];

disp(shift_tab)

shifts_inter_tmp = reshape(shift_tab, 1, []);
shifts = (shifts_inter_tmp)';
correlation_coef = reshape(correlation_tab, 1, []);

if ~calibration
    %         plop = flip(plop');
    %         for SubAp_idy = 1:obj.n_SubAp
    %             for SubAp_idx = 1:obj.n_SubAp
    %                 fprintf("%f   ", plop(SubAp_idy, SubAp_idx));
    %             end
    %             fprintf("\n");
    %         end
    correlation_threshold = mean(correlation_coef, "all") - std(correlation_coef, 1, "all");

    central_shift = shifts(ceil(length(shifts)/2));
    shifts = shifts - central_shift;
    shifts(correlation_coef < correlation_threshold) = NaN ;

    %         figure(1);
    %         imagesc(moment_chunks_array);
    %         axis square;
    %         axis off;
    %         colormap gray;
end
    
 

moment_chunks_crop_array = flip(moment_chunks_crop_array');
moment_chunks_crop_array = imresize(moment_chunks_crop_array, 1/resize_ratio);


%     print('-f1','-dpng', fullfile('C:\Users\Novokuznetsk\Pictures\Shack_Hart', 'moment_chunk_crop_array')) ;
% 
%     figure(2);
%     imagesc(correlation_chunks_array);
%     axis square;
%     axis off;
%     colormap gray;
%     print('-f2','-dpng', fullfile('C:\Users\Novokuznetsk\Pictures\Shack_Hart', 'correlation_chunks_array')) ;
    
end