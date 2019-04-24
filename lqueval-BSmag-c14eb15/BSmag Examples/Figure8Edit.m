function [Gamma, offset, alpha] = Figure8Edit(Nwires,Hsteps,R)

    Npoints = 144;
    
    if (R==0)
        Rout1 = 0.049;
        Rout2 = 0.048;
        Rin1 = 0.022;
        Rin2 = 0.022;
    else
        Rin1 = R(1);
        Rin2 = R(2);
        Rout1 = R(3);
        Rout2 = R(4);
    end
    
    CenterLeft = -0.045;
    CenterRight = 0.047;
    W = 0.0015;
    H = 0.00725;
    offset = 0.00497;
    N = 9;

    d1 = (Rout1-Rin1)/N;
    d2 = (Rout2-Rin2)/N;
    
    dx = [];
    for n=0:Nwires-1 
        dx = [dx n*0.8*d1/Nwires];
    end
    %% Levogira (izquierda)
    alfa = [];
    for n=1:N
        alfa = [alfa (pi/2):-2*pi/Npoints:(pi/2-2*pi+2*pi/Npoints)];
%         alfa = [alfa (pi/2):-2*pi/Npoints:(pi/2-2*pi+2*pi/Npoints)];
    end
    alfa = [alfa pi/2];

    R = zeros(Nwires,N*Npoints+1);
    lpx = zeros(Nwires,N*Npoints+1);
    lpy = zeros(Nwires,N*Npoints+1);
    for n=1:Nwires

        R(n,:) = Rout1-d1/2+dx(n):(Rin1-Rout1+d1)/(N*Npoints):Rin1+d1/2+dx(n);

        lpx(n,:) = sin(alfa).*R(n,:);
        lpy(n,:) = cos(alfa).*R(n,:);

    end
    lpx=lpx(:,1:end-20);
    lpy=lpy(:,1:end-20);

    %% Dextrogira (derecha)
    alfa = [];
    for n=1:N
        alfa = [alfa -pi/4:2*pi/Npoints:(-pi/4+2*pi-2*pi/Npoints)];
%         alfa = [alfa pi/2:2*pi/Npoints:(pi/2+2*pi-2*pi/Npoints)];
    end
    alfa = [alfa pi/2];

    R = zeros(Nwires,N*Npoints+1);
    dpx = zeros(Nwires,N*Npoints+1);
    dpy = zeros(Nwires,N*Npoints+1);
    for n=1:Nwires

        R(n,:) = Rin1+d2/2+dx(n):(Rout1-Rin1-d2)/(N*Npoints):Rout1-d2/2+dx(n);

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
%         px = [px 0 lpx(n,:)-0.04663 dpx(n,:)+0.04711-0.0035 0];
        px = [px 0 lpx(n,:)+CenterLeft dpx(n,:)+CenterRight 0];
        py = [py -0.3 lpy(n,:) dpy(n,:) -0.3];
        index = [index length(px) - length(dpx) - 1];
    end
    
    % Source points (where there is a current source)
    Gamma = [px',py',zeros(length(px),1)]; 
    
    for n=1:Nwires
        Gamma(index(n),3) = W;
        Gamma(index(n)+1,3) = 2*W;
    end
    
    L = size(Gamma,1);
    GammaAux = Gamma;
    
    Gamma = [];
    for k=1:Hsteps
        if (Hsteps == 1)
            h = H/2;
        else
            h = (k-1)*(H/(Hsteps-1));
        end
        
        Gamma2 = GammaAux;
        Gamma2(:,3) = Gamma2(:,3) + h;
        Gamma = [Gamma; Gamma2];
        
        for n=1:Nwires           
            Gamma(index(n)+(k-1)*L,3) = H+W;
            Gamma(index(n)+(k-1)*L+1,3) = H+W;
        end
    end
    
    alpha = 1/(Nwires*Hsteps);
    plot3(Gamma(:,1),Gamma(:,2),Gamma(:,3))
end