close all, clc;
path(path,'C:\Users\MANCINO\Desktop\nTMS\MATLAB\lqueval-BSmag-c14eb15\BSmag Core')
BSmag = BSmag_init(); % Initialize BSmag analysis

% Wire drawing
figure(1);

% Source points (where there is a current source)
Gamma = [[0.0 0.0 -1];[0.0 0.0 1]];

I = 1; % filament current [A]

dGamma = 1e-4; % filament max discretization step [m]      
[BSmag] = BSmag_add_filament(BSmag,Gamma,I,dGamma);


% Field points (where we want to calculate the electric field)
px = 0;
py = 0;
pz = 0;
Nx = 5;
Ny = 5;
D = 5e-3;

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

figure;
surf(x_M,y_M,((BX(:,:,1)))),colorbar;
xlabel('X');ylabel('Y');
title('Magnetic Field (X) [T]');
figure;
surf(x_M,y_M,((BY(:,:,1)))),colorbar;
xlabel('X');ylabel('Y');
title('Magnetic Field (Y) [T]');
figure;
surf(x_M,y_M,((BZ(:,:,1)))),colorbar;
xlabel('X');ylabel('Y');
title('Magnetic Field (Z) [T]');

%% Biot-Savart Integration
[BSmag,X,Y,Z,Ex,Ey,Ez] = BSmag_get_Induced_E(BSmag,X_M,Y_M,Z_M);

%% Electric field graphics
figure;
normE=sqrt(Ex.^2+Ey.^2+Ez.^2);
surf(x_M,y_M,(abs(normE(:,:,1)))),colorbar;
xlabel('X');ylabel('Y');
title('Induced Electric Field [V/m]');

figure;
surf(x_M,y_M,(abs(Ex(:,:,1)))),colorbar;
title('Electric Field (X) [V/m]');
figure;
surf(x_M,y_M,(abs(Ey(:,:,1)))),colorbar;
title('Electric Field (Y) [V/m]');
figure;
surf(x_M,y_M,(abs(Ez(:,:,1)))),colorbar;
title('Electric Field (Z) [V/m]');

%% Magnetic Field
% Plot B/|B|
figure;
quiver3(X,Y,Z,BX./normB,BY./normB,BZ./normB,'b')
xlabel('X');ylabel('Y');
legend({'Magnetic Field'});


%% Induced Electric field
%Plot E/|E|
figure;
hold all;
quiver3(X,Y,Z,Ex./normE,Ey./normE,Ez./normE,'r')
xlabel('X');ylabel('Y');
legend({'Electric Field'});

L = length(z_M);

bx = BX(:,:,1);
by = BY(:,:,1);
bz = BZ(:,:,1);