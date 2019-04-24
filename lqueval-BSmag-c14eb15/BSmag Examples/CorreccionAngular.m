
e1 = 10;
e2 = 0;
e3 = 0;

% alfaij = desvío en la direcion del campo j del angulo del sensor i 
alfaxy = deg2rad(0.23 + e3);
alfaxz = deg2rad(0 + e2);
alfayx = deg2rad(0.5 - e3);
alfayz = deg2rad(0.48 - e1);
alfazx = deg2rad(1.08 - e2);
alfazy = deg2rad(0 + e1);

bx = Bx*cos(alfaxy)*cos(alfaxz) + By*sin(alfaxy) + Bz*sin(alfaxz);
by = By*cos(alfayx)*cos(alfayz) + Bx*sin(alfayx) + Bz*sin(alfayz);
bz = Bz*cos(alfazx)*cos(alfazy) + Bx*sin(alfaxz) + By*sin(alfazy);

Bx_aprox = (bx - bz*sin(alfaxz) -by*sin(alfaxy))/(cos(alfaxy)*cos(alfaxz));
By_aprox = (by - bz*sin(alfayz) -bx*sin(alfayx))/(cos(alfayx)*cos(alfayz));
Bz_aprox = (bz - by*sin(alfazy) -bx*sin(alfaxz))/(cos(alfazx)*cos(alfazy));

std2(Bx-bx)
std2(Bx-Bx_aprox)