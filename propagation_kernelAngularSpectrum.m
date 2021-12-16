function kernel = propagation_kernelAngularSpectrum(Nx, Ny, z, lambda, x_step, y_step, use_double_precision)

u_step = 1.0 / (Nx * x_step);
v_step = 1.0 / (Ny * y_step);
u = ((1:Nx) - 1 - round(Nx / 2)) * u_step;
v = ((1:Ny) - 1 - round(Ny / 2)) * v_step;

[U, V] = meshgrid(u, v);

kernel = exp(2 * 1i * pi * z / lambda * sqrt(1 - lambda^2 * (U).^2 - lambda^2 * (V).^2));

if ~use_double_precision
    kernel = single(kernel);
end 
% imagesc(real(kernel));
% axis image;
% 1;
end