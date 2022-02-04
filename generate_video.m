function generate_video(video, audio, output_path, name, contrast_enhancement_tol, temporal_filter_sigma, contrast_inversion, export_raw, export_avg_img, batch_stride, Fs)
% Saves a raw pixel array to a video file, with some post processing
% commonly done for rendering hologram videos
%
% video: a 4D array containing a raw video to save to a file
% output_path: path of the output directory
% name: name of the generated video, e.g. M0, not the full file name
% contrast_enhancement_tol: a parameter to adjust video contrast ([] if not wanted)
% temporal_filter_sigma: magnitude of temporal gaussian filter ([] if no filter is wanted)
% contrast_inversion: if true, contrast of the video will be inverted
% export_raw: if true, the video is also exported as a raw file in the raw directory
% export_avg_img: if true, save the temporal average of the video as a png
%                 file in the 'png' directory 

%% temporal filter
if ~isempty(temporal_filter_sigma)
   sigma = [0.0001 0.0001 temporal_filter_sigma];
   for c = 1:size(video, 3)
      video(:,:,c,:) = imgaussfilt3(squeeze(video(:,:,c,:)), sigma); 
   end
end

%% fix intensity flashes
video = video - mean(mean(video, 2), 1);

%% contrast enhancement
if ~isempty(contrast_enhancement_tol)
    tol_pdi_low = contrast_enhancement_tol;  % default 0.0005
    tol_pdi = [tol_pdi_low 1-tol_pdi_low];
    video = enhance_video_constrast(video, tol_pdi);
end

%% flip video
video = flip(video);

%% contrast inversion
if contrast_inversion
   video = -1.0 * video; 
end

%% prepare for writing
video = mat2gray(video);

[~, output_dirname] = fileparts(output_path);
output_filename = sprintf('%s_%s.%s', output_dirname, name, 'avi');
w = VideoWriter(sprintf('%s\\avi\\%s', output_path, output_filename));

% create audio track
% audio = normalize(log(abs(fft(audio, 1024, 2))), 'range', [-1, 1]);
tsize = floor(batch_stride * 44100 / Fs);
audio_source = zeros(size(audio,1),tsize);
for pp = 1:size(audio,1)% == size(video,3)
    audio_source(pp,:) = real(fft(audio(pp,:),tsize,2));
end%pp
audio_source = reshape(audio_source,1,size(audio,1)*tsize);
audio_source = normalize(audio_source,2,'range', [-1, 1]);
output_filename_audio = sprintf("%s\\plop.mp4", output_path);
audiowrite(output_filename_audio, audio_source, 44100);

open(w);
for i = 1:size(video,4)
 writeVideo(w, video(:,:,:,i));
end
close(w)

%% save to mp4 format
output_filename = sprintf('%s_%s.%s', output_dirname, name, 'mp4');
w = VideoWriter(sprintf('%s\\mp4\\%s', output_path, output_filename), 'MPEG-4');
open(w);
for i = 1:size(video,4)
 writeVideo(w, video(:,:,:,i));   
end
close(w)

%% save to raw format
if export_raw
    output_filename = sprintf('%s_%s.%s', output_dirname, name, 'raw');
    export_raw_video(sprintf('%s\\raw\\%s', output_path, output_filename), video);
end

%% save temporal average to png
if export_avg_img
    output_filename = sprintf('%s_%s.%s', output_dirname, name, 'png');
    video_avg = mat2gray(mean(video, 4));
    imwrite(video_avg,sprintf('%s\\png\\%s', output_path, output_filename));
end
end