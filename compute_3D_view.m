function view_3D = compute_3D_view(FH, f1, f2, acquisition, gaussian_width, svd, phase_correction)

view_3D = zeros(size(FH,1),9, size(FH,2));

[hologram_stack, sqrt_hologram_stack] = reconstruct_holograms_stack(FH, f1, f2, acquisition, gaussian_width, false, false, phase_correction,1000);


% size(view_3D(:,120,:))

hologram_stack = permute(hologram_stack, [3 1 2]);

figure(1)
imagesc(hologram_stack(:,:,256))
%colormap("gray")
