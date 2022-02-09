function [FH] = subaperture_PCA (FH, SubAp_PCA, acquisition, enable_svd, f1, f2, gw)

ac = acquisition;
batch_size = size(FH,3);
% shifts is a 1D vector
% it maps the 2D SubApils grid by iterating column first
% example of ordering for a 4x4 SubApil grid
% 1  2  3  4
% 5  6  7  8
% 9  10 11 12
% 13 14 15 16
%

ac.Nx = double(ac.Nx);
n_subAp_x = 8;
n_subAp_y = 8;
subAp_Nx = floor(ac.Nx/n_subAp_x); % assume : image is square
subAp_Ny = floor(ac.Nx/n_subAp_x); % assume : image is square

subAp_M0 = ones(subAp_Nx, subAp_Ny, n_subAp_x * n_subAp_y);

FH_4D = ones(subAp_Nx, subAp_Ny, batch_size, n_subAp_x * n_subAp_y)+1i*ones(subAp_Nx, subAp_Ny, batch_size, n_subAp_x * n_subAp_y);

skip = ones(n_subAp_x + 2, n_subAp_y + 2);
skip = skip .* hann(n_subAp_x + 2);
skip = skip .* hann(n_subAp_y + 2)';
skip = skip(2:end-1,2:end-1);

for id_y = 1 : n_subAp_y
    for id_x = 1 : n_subAp_x
        FH_4D(:,:,:,id_x+(id_y-1)*n_subAp_x) = FH((id_y-1)*subAp_Nx+1 : id_y*subAp_Nx, (id_x-1)*subAp_Nx+1 : id_x*subAp_Nx, :);

        if (skip(id_x, id_y) >= 0.10)
            H_chunk = ifft2(FH_4D(:,:,:,id_x+(id_y-1)*n_subAp_x));
            % Statistical filtering
            if enable_svd
                sz1 = size(H_chunk,1);
                sz2 = size(H_chunk,2);
                sz3 = size(H_chunk,3);
                H_chunk   = reshape(H_chunk, [sz1*sz2, sz3]);
                threshold = round(f1 * batch_size / ac.fs)*2 + 1;
                % Singular Value Decomposition (SVD) of spatio-temporal
                % features
                COV              = H_chunk'*H_chunk;
                [V, S]           = eig(COV);
                [~, sortIdx]     = sort(diag(S),'descend');
                V                = V(:,sortIdx);
                H_chunk_Tissue   = H_chunk*V(:, 1:threshold) * V(:, 1:threshold)';
                H_chunk   = reshape(H_chunk - H_chunk_Tissue, [sz1,sz2, sz3]);
            end % enable_svd
    
            SH_chunk = fft(H_chunk,[],3);
            hologram_chunk = abs(SH_chunk).^2; % stack of holograms
    
            % frequency integration
            n1 = round(f1 * batch_size / ac.fs) + 1;
            n2 = round(f2 * batch_size / ac.fs);
            n3 = size(hologram_chunk, 3) - n2 + 2;
            n4 = size(hologram_chunk, 3) - n1 + 2;
    
            moment = squeeze(sum(hologram_chunk(:, :, n1:n2), 3)) + squeeze(sum(hologram_chunk(:, :, n3:n4), 3));
            ms = sum(sum(moment,1),2);
    
            % apply flat field correction
            if ms~=0
                moment = moment ./ imgaussfilt(moment, gw/(n_subAp_x));
                ms2 = sum(sum(moment,1),2);
                moment = (ms / ms2) * moment;
            end
            moment_chunk = gather(moment); % PowerDoppler moments
    
            %          moment_chunk  = moment_chunk.^obj.PowFilterPreCorr; % mettre un flag
            %          if (obj.SigmaFilterPreCorr ~= 0)
            %              moment_chunk = imgaussfilt(moment_chunk,obj.SigmaFilterPreCorr); % filtering to ease correlation
            %          end
    
            if sum(moment_chunk(:))~=0
                moment_chunk = moment_chunk-mean(moment_chunk(:)); %centering
                moment_chunk = moment_chunk/max(moment_chunk(:)); %normalisation
            end
            gauss = ones(subAp_Nx, subAp_Ny);
            gauss = gauss .* hann(subAp_Nx);
            gauss = gauss .* hann(subAp_Ny)';
            moment_chunk = moment_chunk .* gauss;
            subAp_M0(:, :, id_x+(id_y-1)*n_subAp_x) = ifft2(moment_chunk);
        end
    end
end

imagesc(abs(subAp_M0(:,:,3)).^2);

FH_2D = reshape(FH_4D, subAp_Nx * subAp_Ny * batch_size, n_subAp_x * n_subAp_y);

cov = FH_2D' * FH_2D;

[V,S] = eig(cov);
[~, sort_idx] = sort(diag(S), 'descend');
V = V(:,sort_idx);

%singular value selection
% %FIXME ATTN 2f1
% threshold = round(f1 * batch_size / ac.fs)*2 + 1;

%PCA (reciprocal space)
% FH_2D = FH_2D * V(:,3:end);
%SVD (+ return to direct space)
FH_2D = FH_2D * V(:,SubAp_PCA.min:SubAp_PCA.max) * V(:,SubAp_PCA.min:SubAp_PCA.max)';

FH_4D = reshape(FH_2D,subAp_Nx, subAp_Ny, batch_size, n_subAp_x * n_subAp_y);

for id_y = 1 : n_subAp_y
    for id_x = 1 : n_subAp_x  
         FH((id_y-1)*subAp_Nx+1 : id_y*subAp_Nx, (id_x-1)*subAp_Nx+1 : id_x*subAp_Nx, :) = FH_4D(:,:,:,id_x+(id_y-1)*n_subAp_x);
    end
end 

end