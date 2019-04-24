%---------------------------------------------------
%  NAME:      example_1D_straight_filament.m
%  WHAT:      Calculation of the magnetic field of a finite straight filament
%             along a line (+ 1D plot).
%  REQUIRED:  BSmag Toolbox 20150407
%  AUTHOR:    20150407, L. Queval (loic.queval@gmail.com)
%  COPYRIGHT: 2015, Loic Qu�val, BSD License (http://opensource.org/licenses/BSD-3-Clause).
%----------------------------------------------------

% Initialize
clear all, close all, clc
BSmag = BSmag_init(); % Initialize BSmag analysis

% Source points (where there is a current source)
Gamma   = [0,0,-1; % x,y,z [m,m,m]
           0,0,1];
I = 1; % filament current [A]
dGamma = 1e-3; % filament max discretization step [m]      
[BSmag] = BSmag_add_filament(BSmag,Gamma,I,dGamma);

% Field points (where we want to calculate the field)
x_M = linspace(-0.1,0.1,81)'; % x [m]
y_M = linspace(-0.1,0.1,81)'; % x [m]
z_M = linspace(-1,1,1); % z [m]
z_M = 2; % z [m]
[X_M,Y_M,Z_M]=meshgrid(x_M,y_M,z_M);
BSmag_plot_field_points(BSmag,X_M,Y_M,Z_M); % -> shows the field point line

% Biot-Savart Integration
[BSmag,X,Y,Z,BX,BY,BZ] = BSmag_get_B(BSmag,X_M,Y_M,Z_M);      

% Plot B/|B|
figure(1)
    normB=sqrt(BX.^2+BY.^2+BZ.^2);
    quiver3(X,Y,Z,BX./normB,BY./normB,BZ./normB,'b')

% Plot By on the line
% figure(2), hold on, box on, grid on
% 	plot(X, BY, 'x-b')
% xlabel ('x [m]'), ylabel (' By [T]')

figure(2);
surf(x_M,y_M,normB(:,:,1)),colorbar;