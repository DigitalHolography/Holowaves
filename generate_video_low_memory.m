function generate_video_low_memory(filename, Nx, Ny, Nc, num_frames, output_path, name, contrast_enhancement_tol, temporal_filter_sigma, contrast_inversion, export_raw, export_avg_img)
% Saves a raw pixel array to a video file, with some post processing
% commonly done for rendering hologram videos
%
% filename: a file name of a video saved on disk
% Nx, Ny, Nc, num_frames: the 4D size of the video saved on disk
% output_path: path of the output directory
% name: name of the generated video, e.g. M0, not the full file name
% contrast_enhancement_tol: a parameter to adjust video contrast ([] if not wanted)
% temporal_filter_sigma: magnitude of temporal gaussian filter ([] if no filter is wanted)
% contrast_inversion: if true, contrast of the video will be inverted
% export_raw: if true, the video is also exported as a raw file in the raw directory
% export_avg_img: if true, save the temporal average of the video as a png
%                 file in the 'png' directory 


[~, output_dirname] = fileparts(output_path);
output_filename = sprintf('%s_%s.%s', output_dirname, name, 'avi');
w_avi = VideoWriter(sprintf('%s\\avi\\%s', output_path, output_filename));

output_filename = sprintf('%s_%s.%s', output_dirname, name, 'mp4');
w_mp4 = VideoWriter(sprintf('%s\\mp4\\%s', output_path, output_filename), 'MPEG-4');
open(w_avi);
open(w_mp4);

num_frames = uint64(num_frames);
block_size = 1024;
frame_size = Nx*Ny*Nc;
fd = fopen(filename);

if ~isempty(temporal_filter_sigma)
    pad_size = floor(temporal_filter_sigma);
    padl = zeros(Nx,Ny,Nc,pad_size,'single');
    padr = zeros(Nx,Ny,Nc,pad_size,'single');
else
    pad_size = 0;
    padl = [];
    padr = [];
end

for batch_idx = 1:block_size:num_frames
   actual_block_size = min(batch_idx - 1 + block_size, num_frames) - batch_idx + 1;
   
   %% load data block from file
   if batch_idx - pad_size > 0
       fseek(fd,frame_size * 4 * (batch_idx - 1 - pad_size),'bof');
       padl(:) = fread(fd, frame_size*pad_size,'single');
   end
   fseek(fd,frame_size * 4 * (batch_idx - 1),'bof');
   block = fread(fd, frame_size*actual_block_size,'single');
   block = reshape(block, Nx, Ny, Nc, actual_block_size);
   if num_frames >= batch_idx - 1 + block_size + pad_size
      padr(:) =  fread(fd, frame_size*pad_size,'single');
   end
   
   
   %% temporal filter
    if ~isempty(temporal_filter_sigma)
       sigma = [0.0001 0.0001 temporal_filter_sigma];
       pad_block = cat(4, padl, block, padr);
       
       for c = 1:size(block, 3)
          pad_block(:,:,c,:) = imgaussfilt3(squeeze(pad_block(:,:,c,:)), sigma); 
       end
       
       block(:,:,:,:) = pad_block(:,:,:,pad_size+1:end-pad_size);
    end
    
    %% contrast enhancement
    if ~isempty(contrast_enhancement_tol)
        tol_pdi_low = contrast_enhancement_tol;  % default 0.0005
        tol_pdi = [tol_pdi_low 1-tol_pdi_low];
        block = enhance_video_constrast(block, tol_pdi);
    end
    
    %% fix intensity flashes
    block = block - mean(mean(block, 2), 1);
    
    %% flip video
    block = flip(block);
    
    %% contrast inversion
    if contrast_inversion
       block = -1.0 * block; 
    end
    
    %% prepare for writing
    block = mat2gray(block);
    
    
    writeVideo(w_avi, block);
    writeVideo(w_mp4, block);
    
end
close(w_avi);
close(w_mp4);
fclose(fd);
% %% save to raw format
% if export_raw
%     output_filename = sprintf('%s_%s.%s', output_dirname, name, 'raw');
%     export_raw_video(sprintf('%s\\raw\\%s', output_path, output_filename), block);
% end
% 
% %% save temporal average to png
% if export_avg_img
%     output_filename = sprintf('%s_%s.%s', output_dirname, name, 'png');
%     video_avg = mat2gray(mean(block, 4));
%     imwrite(video_avg,sprintf('%s\\png\\%s', output_path, output_filename));
% end
end