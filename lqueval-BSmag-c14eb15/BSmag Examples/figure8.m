function [px, py, index, height] = figure8(Nwires)

    Npoints = 144;
    Rout = 0.087/2;
    Rin = 0.056/2;
    N = 9;

    d = (Rout-Rin)/N;
    dx = [];
    for n=0:Nwires-1 
        dx = [dx n*0.8*d/Nwires];
    end
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

        R(n,:) = Rout-d/2+dx(n):(Rin-Rout)/(N*Npoints):Rin-d/2+dx(n);

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

        R(n,:) = Rin-d/2+dx(n):(Rout-Rin)/(N*Npoints):Rout-d/2+dx(n);

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
        px = [px 0 lpx(n,:)-0.087/2+d/2 dpx(n,:)+0.087/2-1.5*d 0];
        py = [py -0.1 lpy(n,:) dpy(n,:) -0.1];
        index = [index length(px) - length(dpx) - 1];
    end
    
    % Coil height
    height = d;
    plot(px,py);

end