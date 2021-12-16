function kernel = propagation_kernelFresnel(Nx, Ny, z, lambda, x_step, y_step, use_double_precision)

x(1:Nx)=(((1:Nx)-1)-round(Nx/2))*x_step; %Valeurs de l'axe x
y(1:Ny)=(((1:Ny)-1)-round(Ny/2))*y_step; %Valeurs de l'axe y
[X,Y]=meshgrid(x,y); %Grille de calcul

kernel = exp(1i*pi/(lambda*z)*(X.^2+Y.^2));

if ~use_double_precision
    kernel = single(kernel);
end
end