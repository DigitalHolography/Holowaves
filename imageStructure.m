function images = imageStructure()

%fuction creating struct holding all of the image types
%they are accessed through their names and the structures hold:
% short name of the reconstruction
% select_boolean (we choose if we want this reconstruction in our output)
% field that can store reconstructed image


field_1 = 'power_Doppler'; values_1 = struct('short_name','power', 'select', 0 ,'image', [] , 'M0_sqrt', []);
field_2 = 'power_1_Doppler'; values_2 = struct('short_name','power1', 'select', 0 ,'image', []);
field_3 = 'power_2_Doppler'; values_3 = struct('short_name','power2', 'select', 0 ,'image', []);
field_4 = 'color_Doppler'; values_4 = struct('short_name','color', 'select', 0 ,'image', [] , 'M0_pos', [], 'M0_neg', []);
field_5 = 'directional_Doppler'; values_5 = struct('short_name','directional', 'select', 0 ,'image', [] , 'freq_low', [], 'freq_high', []);
field_6 = 'M0sM1r'; values_6 = struct('short_name','ratio', 'select', 0 ,'image', [] );
field_7 = 'velocity_estimate'; values_7 = struct('short_name','velocity', 'select', 0 ,'image', []);

%it takes a lot of time, would it be possible to unify the structure : have
%only the image field or only the additional images?

images = struct(field_1, values_1, field_2, values_2, field_3, values_3, field_4, values_4, field_5, values_5, field_6, values_6, field_7, values_7);

end
