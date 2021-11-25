function video_3D= register_3D_video (video_3D)
% INPUT: 3D video
% 5D array of dimensions z_size, x_size, y_size, 1, video_length
% get consecutive volumes from the video
[optimizer,metric] = imregconfig('monomodal');

% In our case we don't need that because all parameters of the volume image
% are identical
fixedVolume = video_3D(:,:,:,:,1);

%Rmoving = imref3d(size(movingVolume),movingHeader.PixelSize(2),movingHeader.PixelSize(1),movingHeader.SliceThickness);

for i = 1 : size(video_3D, 5)
    movingVolume = video_3D(:,:,:,:,i);

    video_3D(:,:,:,:,i) = imregister(movingVolume, fixedVolume, 'translation', optimizer, metric);
end

