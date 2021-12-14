function images = clearImages(images)

images.power_Doppler.select = 0; images.Power_Doppler.image = []; 
images.power_1_Doppler.select = 0; images.Power_1_Doppler.image = [];
images.power_2_Doppler.select = 0; images.Power_2_Doppler.image = [];
images.color_Doppler.select = 0; images.color_Doppler.image = [];
images.directional_Doppler.select = 0; images.directional_Doppler.image = []; 
images.M0sM1r.select = 0; images.M0sM1r.image = [];
images.velocity_estimate.select = 0; images.velocity_estimate.image = [];

end