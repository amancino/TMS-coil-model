function [px, py, index, height] = figure8(Nwires)

    Npoints = 144;
    Rout1 = 0.04498;
    Rout2 = 0.04443;
    Rin1 = 0.02836;
    Rin2 = 0.02811;
    W = 0.0015;
    H = 0.00725;
    offset = 0.00497;
    N = 9;

    %% Levógira
    alfa = [];
    for n=1:N
        alfa = [alfa (pi/2):-2*pi/Npoints:(pi/2-2*pi+2*pi/Npoints)];
    end
    alfa = [alfa pi/2];

    R = zeros(Nwires,N*Npoints+1);
    lpx = zeros(Nwires,N*Npoints+1);
    lpy = zeros(Nwires,N*Npoints+1);
    for n=1:Nwires

        R(n,:) = Rout1:(Rin1-Rout1)/(N*Npoints):Rin1;

        lpx(n,:) = sin(alfa).*R(n,:);
        lpy(n,:) = cos(alfa).*R(n,:);

    end
    lpx=lpx(:,1:end-20);
    lpy=lpy(:,1:end-20);

    %% Dextrógira
    alfa = [];
    for n=1:N
        alfa = [alfa -pi/4:2*pi/Npoints:(-pi/4+2*pi-2*pi/Npoints)];
    end
    alfa = [alfa pi/2];

    R = zeros(Nwires,N*Npoints+1);
    dpx = zeros(Nwires,N*Npoints+1);
    dpy = zeros(Nwires,N*Npoints+1);
    for n=1:Nwires

        R(n,:) = Rin2:(Rout2-Rin2)/(N*Npoints):Rout2;

        dpx(n,:) = sin(alfa).*R(n,:);
        dpy(n,:) = cos(alfa).*R(n,:);

    end
    dpx=dpx(:,1:end-28);
    dpy=dpy(:,1:end-28);


    %% Figure 8 coil
    px = [];
    py = [];
    index = [];
    for n=1:Nwires     
        px = [px 0 lpx(n,:)-0.04663 dpx(n,:)+0.04711 0];
        py = [py -0.1 lpy(n,:) dpy(n,:) -0.1];
        index = [index length(px) - length(dpx) - 1];
    end
    
    % Coil height
    height = offset;
    plot(px,py);

end