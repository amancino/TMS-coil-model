% dz: distancia en z al sensor Bx
% Nstep: 1 -> 1.0583mm
% Nx: muestras en x
% Ny: muestras en y
function [simulacion] = CalcularCamposSensados(dz,Nstep,Nx,Ny,offset)
    
    Px = [ 0        0       0       ];
    Py = [-1e-3    3.2e-3   -1e-3   ];
    Pz = [-1e-3    0.95e-3  3.45e-3 ];

    [bx,~,~,Xx,Yx] = Campo_figura8(Nstep,Nx,Ny,0,0,-dz,0,0,offset);
    Bx = bx;
    
    [~,by,~,Xy,Yy] = Campo_figura8(Nstep,Nx,Ny,Py(1),Py(2),-dz+Py(3),0,0,offset);
    By = by;
    
    [~,~,bz,Xz,Yz] = Campo_figura8(Nstep,Nx,Ny,Pz(1),Pz(2),-dz+Pz(3),0,0,offset);
    Bz = bz; 
    
    close all;
    figure(1);
    surf(Xx,Yx,Bx),colorbar;
    xlabel('X');ylabel('Y');
    title('Magnetic Field (X) [T]');
    figure(2);
    surf(Xy,Yy,By),colorbar;
    xlabel('X');ylabel('Y');
    title('Magnetic Field (Y) [T]');
    figure(3);
    surf(Xz,Yz,Bz),colorbar;
    xlabel('X');ylabel('Y');
    title('Magnetic Field (Z) [T]');
    
    simulacion.Bx = Bx;
    simulacion.By = By;
    simulacion.Bz = Bz;
    simulacion.Xx = Xx*1000; simulacion.Yx = Yx*1000;
    simulacion.Xy = Xy*1000; simulacion.Yy = Yy*1000;
    simulacion.Xz = Xz*1000; simulacion.Yz = Yz*1000;
    simulacion.dz = dz;
end