function img_type_list = imageTypeList()

%fuction creating struct holding all of the image types
%they are accessed through their names and the structures hold:
% short name of the reconstruction
% select_boolean (we choose if we want this reconstruction in our output)
% field that can store reconstructed image


field_1 = 'power_Doppler'; values_1 = {'power', 0 , []};
field_2 = 'Power_1_Doppler'; values_2 = {'power', 0 ,[]};
field_3 = 'Power_2_Doppler'; values_3 = {'power', 0 ,[]};
field_4 = 'color_Doppler'; values_4 = {'power', 0 ,[]};
field_5 = 'directional_Doppler'; values_5 = {'power', 0 ,[]};
field_6 = 'M0sM1r'; values_6 = {'power', 0 ,[]};
field_7 = 'velocity_estimate'; values_7 = {'power', 0 ,[]};

img_type_list = struct(field_1, values_1, field_2, values_2, field_3, values_3, field_4, values_4, field_5, values_5, field_6, values_6, field_7, values_7);

end
