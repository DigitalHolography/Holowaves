
function H = svd_x_filter(H, f1, fs, NbSubAp)
% SVD filtering
%
% H: an frame batch already propagated to the distance of reconstruction
% f1: frequency
% fs: sampling frequency
% NbSubAp : number N of subapertures to divide SVD filtering over NxN zones


[width, height, batch_size] = size(H);
Lx = linspace(1,width,NbSubAp+1);
Ly = linspace(1,height,NbSubAp+1);
threshold = round(f1 * batch_size / fs)*2 + 1;

% SVDxVideo = zeros(width, height, length(threshold));
% for jj=1:length(threshold)
%     H1 = zeros(width, height, batch_size);
    for ii=1:NbSubAp
        for kk=1:NbSubAp
            H1 = H(round(Lx(ii)):round(Lx(ii+1)),round(Ly(kk)):round(Ly(kk+1)),:);
            H1 = reshape(H1, (round(Lx(ii+1))-round(Lx(ii))+1)*(round(Ly(kk+1))-round(Ly(kk))+1), batch_size);

            % SVD of spatio-temporal features
            cov = H1'*H1;
            [V,S] = eig(cov);
            [~, sort_idx] = sort(diag(S), 'descend');
            V = V(:,sort_idx);
            size(V);
            H_tissue = H1 * V(:,1:threshold) * V(:,1:threshold)';
            H1 = reshape(H1 - H_tissue, (round(Lx(ii+1))-round(Lx(ii))+1), (round(Ly(kk+1))-round(Ly(kk))+1), batch_size);
            H(round(Lx(ii)):round(Lx(ii+1)),round(Ly(kk)):round(Ly(kk+1)),:) = reshape(H1, (round(Lx(ii+1))-round(Lx(ii))+1), (round(Ly(kk+1))-round(Ly(kk))+1), batch_size);
        end
    end
%     SVDxVideo(:,:,jj) = mean(abs(H1), [3]);
%     jj
% end

% w = VideoWriter('H:\211006_BRZ0182\211006_BRZ0182_SVDxVideo.avi');
% open(w)
% SVDxVideo = im2uint8(mat2gray(SVDxVideo));
% for jj = 1:size(SVDxVideo,3) % ARIvideoRGB is three dimensional: height-by-width-by-frames
%     writeVideo(w,squeeze(SVDxVideo(:,:,jj)));
% end
% close(w);

end