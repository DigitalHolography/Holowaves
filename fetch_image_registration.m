function [image_registration, found] = fetch_image_registration(filepath, filename, file_ext)
% check if there is already an output folder for the current
% file_M0. If there is one, load GUI parameters cache from
% exported data
%
% file_ext: '.cine' or '.raw'

[selected_dir, found] = get_last_output_dir(filepath, filename, file_ext);

if ~isempty(selected_dir)
    found = true;
    image_registration = load(fullfile(filepath, selected_dir,'mat', sprintf('%s.mat', selected_dir)), 'image_registration');
    image_registration = image_registration.image_registration;
else
    image_registration = [];
end
end