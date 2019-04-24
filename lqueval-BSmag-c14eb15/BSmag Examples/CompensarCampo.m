function [Bx,By,Bz] = CompensarCampo(bx,by,bz,e1,e2,e3,e4)
 
    % alfaij = desvío en la direcion del campo j del angulo del sensor i 
    alfaxy = deg2rad(0.23 + e3);
    alfaxz = deg2rad(0 + e2);
    alfayx = deg2rad(0.5 - e3);
    alfayz = deg2rad(0.48 - e1);
    alfazx = deg2rad(1.08 - e2);
    alfazy = deg2rad(0 + e1);

    Bx_aprox = (bx - bz*sin(alfaxz) -by*sin(alfaxy))/(cos(alfaxy)*cos(alfaxz));
    By_aprox = (by - bz*sin(alfayz) -bx*sin(alfayx))/(cos(alfayx)*cos(alfayz));
    Bz_aprox = (bz - by*sin(alfazy) -bx*sin(alfaxz))/(cos(alfazx)*cos(alfazy));
    
    a = cos(alfaxy)*cos(alfaxz);
    b = sin(alfayx);
    c = sin(alfazx);
    d = sin(alfaxy);
    e = cos(alfayx)*cos(alfayz);
    f = sin(alfazy);
    g = sin(alfaxz);
    h = sin(alfayz);
    i = cos(alfazx)*cos(alfazy);
    
    A = [[a b c];[d e f];[g h i]];
    
    Bx = zeros(size(bx));
    By = zeros(size(bx));
    Bz = zeros(size(bx));
    
    for x=1:size(bx,1)
        for y=1:size(bx,2)
            b = [bx(x,y);by(x,y);bz(x,y)];

            B = A\b;
            Bx(x,y) = B(1);
            By(x,y) = B(2);
            Bz(x,y) = B(3);
        end
    end
    
    if (e4 ~= 0)
        % Rotacion de ejes
        Fo = size(bx,1);
        Co = size(bx,2);
        Bx2 = imrotate(Bx,e4);
        By2 = imrotate(By,e4);
        Bz2 = imrotate(Bz,e4);
        F = size(Bx2,1);
        C = size(Bx2,2);
        dF = (F-Fo)/2;
        dC = (C-Co)/2;
        Bx = Bx2(dF+1:F-dF,dC+1:C-dC);
        By = By2(dF+1:F-dF,dC+1:C-dC);
        Bz = Bz2(dF+1:F-dF,dC+1:C-dC);
    end
    
    
end