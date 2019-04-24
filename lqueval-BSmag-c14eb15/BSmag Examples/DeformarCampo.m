
function [bx,by,bz] = DeformarCampo(Bx,By,Bz,e1,e2,e3)

    % alfaij = desvío en la direcion del campo j del angulo del sensor i 
    alfaxy = deg2rad(0.23 + e3);
    alfaxz = deg2rad(0 + e2);
    alfayx = deg2rad(0.5 - e3);
    alfayz = deg2rad(0.48 - e1);
    alfazx = deg2rad(1.08 - e2);
    alfazy = deg2rad(0 + e1);

    bx = Bx*cos(alfaxy)*cos(alfaxz) + By*sin(alfayx) + Bz*sin(alfazx);
    by = By*cos(alfayx)*cos(alfayz) + Bx*sin(alfaxy) + Bz*sin(alfazy);
    bz = Bz*cos(alfazx)*cos(alfazy) + Bx*sin(alfaxz) + By*sin(alfayz);
end