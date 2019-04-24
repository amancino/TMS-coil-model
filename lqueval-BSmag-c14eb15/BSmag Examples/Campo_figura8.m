%---------------------------------------------------
%  NAME:      example_1D_straight_filament.m
%  WHAT:      Calculation of the magnetic field of a finite straight filament
%             along a line (+ 1D plot).
%  REQUIRED:  BSmag Toolbox 20150407
%  AUTHOR:    20150407, L. Queval (loic.queval@gmail.com)
%  COPYRIGHT: 2015, Loic Qu�val, BSD License (http://opensource.org/licenses/BSD-3-Clause).
%----------------------------------------------------
function [bx,by,bz,x_M,y_M] = Campo_figura8(Nstep,Nx,Ny,px,py,pz,R,show,medOffset)

    % Initialize
    close all, clc;
    path(path,'/home/axel/Desktop/Gaussmeter-matlab/Magnetic Fields/lqueval-BSmag-c14eb15/BSmag Core');
    BSmag = BSmag_init(); % Initialize BSmag analysis


    % Figure 8 drawing
    if (show ~= 0) 
        figure(1);
    end
    
    Nwires = 1;
    Hsteps = 10;
    
%     Nwires = 1;
%     Hsteps = 1;

    % Source points (where there is a current source)
%     [Gamma,offset,alpha] = Figure8Best(Nwires,Hsteps);
    [Gamma,offset,alpha] = Figure8Edit(Nwires,Hsteps,R);

    % Distance to coils
    disp(['Distance: ' num2str((-pz)*1000) ' mm']);

    % Step taken to measure
    D = 25.4/24*Nstep/1000;

    I = alpha*5000; % filament current [A]
    dGamma = 1e-3; % filament max discretization step [m]      
    [BSmag] = BSmag_add_filament(BSmag,Gamma,I,dGamma);

    % Field points (where we want to calculate the field)
    x_M = px + ((-D*floor(Nx/2)):D:(D*floor(Nx/2))) + round(medOffset(1)/D)*D;
    y_M = py + ((-D*floor(Ny/2)):D:(D*floor(Ny/2))) + round(medOffset(2)/D)*D;
    z_M = pz -offset;



    [X_M,Y_M,Z_M]=meshgrid(x_M,y_M,z_M);
    if (show ~= 0) 
        BSmag_plot_field_points(BSmag,X_M,Y_M,Z_M); % -> shows the field point line
    end
    
    %% Biot-Savart Integration
    [BSmag,X,Y,Z,BX,BY,BZ] = BSmag_get_B(BSmag,X_M,Y_M,Z_M);      


    
    normB=sqrt(BX.^2+BY.^2+BZ.^2);
    if (show ~= 0) 
    figure;
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
    end

    %% Induced Electric Field calculation
    [BSmag,X,Y,Z,Ex,Ey,Ez] = BSmag_get_Induced_E(BSmag,X_M,Y_M,Z_M);
    
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
    title('Electri Field (Z) [V/m]');

    %% Magnetic Field
    % Plot B/|B|
    if (show ~= 0) 
        figure;
        quiver3(X,Y,Z,BX./normB,BY./normB,BZ./normB,'b')
        xlabel('X');ylabel('Y');
    end

    %% Induced Electric field
    %Plot E/|E|
    figure;
    hold all;
    quiver3(X,Y,Z,Ex./normE,Ey./normE,Ez./normE,'r')
    xlabel('X');ylabel('Y');
    legend({'Magnetic field','Electric Field'});
    
    L = length(z_M);
%     
%%
    bx = BX(:,:,1);
    by = BY(:,:,1);
    bz = BZ(:,:,1);
    
end