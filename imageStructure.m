function images = imageStructure()

%fuction creating struct holding all of the image types
%they are accessed through their names and the structures hold:
% short name of the reconstruction
% select_boolean (we choose if we want this reconstruction in our output)
% field that can store reconstructed image


field_1 = 'power_Doppler'; values_1 = struct('short_name','power', 'select', 0 ,'image', [] , 'M0_sqrt', []);
field_2 = 'power_1_Doppler'; values_2 = struct('short_name','power1', 'select', 0 ,'image', []);
field_3 = 'power_2_Doppler'; values_3 = struct('short_name','power2', 'select', 0 ,'image', []);
field_4 = 'color_Doppler'; values_4 = struct('short_name','color', 'select', 0 ,'image', [] , 'freq_low', [], 'freq_high', []);
field_5 = 'directional_Doppler'; values_5 = struct('short_name','directional', 'select', 0 ,'image', [] , 'M0_pos', [], 'M0_neg', []);
field_6 = 'M0sM1r'; values_6 = struct('short_name','ratio', 'select', 0 ,'image', [] );
field_7 = 'velocity_estimate'; values_7 = struct('short_name','velocity', 'select', 0 ,'image', []);
field_8 = 'phase_variation'; values_8 = struct('short_name','phase_variation', 'select', 0 ,'image', []);
field_9 = 'dark_field_image'; values_9 = struct('short_name','dark_field', 'select', 0 ,'image', [], 'H', []);
field_10 = 'pure_PCA'; values_10 = struct('short_name','PCA', 'select', 0 ,'image', []);
field_11 = 'spectrogram'; values_11 = struct('short_name', 'spectrogram', 'select', 0, 'image', [], 'vector', [], 'H', []);

field_12 = 'moment0'; values_12 = struct('short_name','M0', 'select', 0 ,'image', [] , 'M0_sqrt', []);
field_13 = 'moment1'; values_13 = struct('short_name','M1', 'select', 0 ,'image', []);
field_14 = 'moment2'; values_14 = struct('short_name','M2', 'select', 0 ,'image', []);

%it takes a lot of time, would it be possible to unify the structure : have
%only the image field or only the additional images?

images = struct(field_1, values_1, field_2, values_2, field_3, values_3, field_4, values_4, field_5, values_5, field_6, values_6, ...
    field_7, values_7, field_8, values_8, field_9, values_9, field_10, values_10, field_11, values_11, field_12, values_12, field_13, values_13, field_14, values_14);

end
