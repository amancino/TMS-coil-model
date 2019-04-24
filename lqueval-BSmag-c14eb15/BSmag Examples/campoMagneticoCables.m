
path(path,'C:\Users\axel\work\gaussmeter\Magnetic Fields\lqueval-BSmag-c14eb15\BSmag Core')
BSmag = BSmag_init(); % Initialize BSmag analysis

% Wire drawing
figure(1);

% Source points (where there is a current source)
Gamma = [[0 14e-3 -1e-3];[0 14e-3 1e-3]];
Gamma1 = [[0 10e-3 -1e-3];[0 10e-3 1e-3]];
Gamma2 = [[0 18e-3 -1e-3];[0 18e-3 1e-3]];

I = 5000; % filament current [A]

dGamma = 1e-5; % filament max discretization step [m]
[BSmag] = BSmag_add_filament(BSmag,Gamma,I,dGamma);
% [BSmag] = BSmag_add_filament(BSmag,Gamma1,I/2,dGamma);
% [BSmag] = BSmag_add_filament(BSmag,Gamma2,I/2,dGamma);

% Field points (where we want to calculate the electric field)
px = 0;
py = 0;
pz = 0;
Nx = 19;
Ny = 19;
D = 2e-3;

x_M = px + ((-D*floor(Nx/2)):D:(D*floor(Nx/2)));
y_M = py + ((-D*floor(Ny/2)):D:(D*floor(Ny/2)));
z_M = pz;

[X_M,Y_M,Z_M]=meshgrid(x_M,y_M,z_M);
BSmag_plot_field_points(BSmag,X_M,Y_M,Z_M); % -> shows the field point line

%% Biot-Savart Integration
[BSmag,X,Y,Z,BX,BY,BZ] = BSmag_get_B(BSmag,X_M,Y_M,Z_M);

%% Magnetic field graphics
figure;
normB=sqrt(BX.^2+BY.^2+BZ.^2);
surf(x_M,y_M,(abs(normB(:,:,1)))),colorbar;
xlabel('X');ylabel('Y');
title('Magnetic Field [T]');