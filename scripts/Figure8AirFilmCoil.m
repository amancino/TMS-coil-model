function [Gamma, offset, alpha] = Figure8AirFilmCoil(Nwires,Hsteps,conf,varargin)

    if (isempty(varargin))
      Npoints = 144;
    else
      Npoints = varargin{1};
    end
      
    % Izquierda
    Rinx1Izq = conf.Rinx1Izq;
    Rinx1Der = conf.Rinx1Der;
    
    Riny1Arriba = conf.Riny1Arriba;
    Riny1Abajo = conf.Riny1Abajo;
    
    Routx1Izq = conf.Routx1Izq;
    Routx1Der = conf.Routx1Der;
    
    Routy1Arriba = conf.Routy1Arriba;
    Routy1Abajo = conf.Routy1Abajo;
    
    CenterLeft = conf.CenterXLeft;

    % Derecha
    Rinx2Izq = conf.Rinx2Izq;
    Rinx2Der = conf.Rinx2Der;
    
    Riny2Arriba = conf.Riny2Arriba;
    Riny2Abajo = conf.Riny2Abajo;
    
    Routx2Izq = conf.Routx2Izq;
    Routx2Der = conf.Routx2Der;
    
    Routy2Arriba = conf.Routy2Arriba;
    Routy2Abajo = conf.Routy2Abajo;
    
    CenterRight = conf.CenterXRight;
    
    CenterYLeft = conf.CenterYLeft;
    CenterYRight = conf.CenterYRight;
    
    H = conf.H;
    
    % Air film coil (see TAC_F8)
    W = 1.5e-3;
%     H = 15e-3;
%     H = 22e-3;
    N = 16;

    % Ancho del plastico 
      offset = conf.offset;


    %% Levogira
    alfa = [];
    for n=1:N
        % N loops of 2pi radians
        alfa = [alfa (-pi/2:-2*pi/Npoints:-pi/2-2*pi)];
    end
    alfa = [alfa (-pi/2:-2*pi/Npoints:-pi/2-5*pi/4)];
    
    
    Rx = zeros(Nwires,length(alfa));
    Ry = zeros(Nwires,length(alfa));
    lpx = zeros(Nwires,length(alfa));
    lpy = zeros(Nwires,length(alfa));
    
    for n=1:Nwires
      
      d1x = (Routx1Der-Rinx1Der)/N;
      d1y = (Routy1Arriba-Riny1Arriba)/N;
      dxx(n) = (n-1)*0.8*d1x/Nwires;
      dxy(n) = (n-1)*0.8*d1y/Nwires;
      Rx(n,1) = Routx1Der-d1x/2+dxx(n);
      Ry(n,1) = Routy1Arriba-d1y/2+dxy(n);
      
      for k=2:length(alfa)
        if (sin(alfa(k)) < 0)
          Riny1 = Riny1Abajo; 
          Routy1 = Routy1Abajo; 
        else
          Riny1 = Riny1Arriba; 
          Routy1 = Routy1Arriba; 
        end
        
        if ( cos(alfa(k)) < 0 )
          Rinx1 = Rinx1Izq;
          Routx1 = Routx1Izq;
        else
          Rinx1 = Rinx1Der; 
          Routx1 = Routx1Der; 
        end
        
        d1x = (Routx1-Rinx1)/N;
        d1y = (Routy1-Riny1)/N;

        Rx(n,k) = Routx1-d1x/2+dxx(n) - d1x*(k-1)/Npoints;
        Ry(n,k) = Routy1-d1y/2+dxy(n) - d1y*(k-1)/Npoints;
      end
      
      lpx(n,:) = cos(alfa).*Rx(n,:);
      lpy(n,:) = sin(alfa).*Ry(n,:);
    end
    
    

    %% Dextrogira
    alfa = [];
    for n=1:N
        alfa = [alfa (-pi/2:2*pi/Npoints:-pi/2+2*pi)];
    end
    alfa = [alfa -pi/2:2*pi/Npoints:-pi/2+5*pi/4];

    
    Rx = zeros(Nwires,length(alfa));
    Ry = zeros(Nwires,length(alfa));
    dpx = zeros(Nwires,length(alfa));
    dpy = zeros(Nwires,length(alfa));
    
    for n=1:Nwires
      
      d2x = (Routx2Der-Rinx2Der)/N;
      d2y = (Routy2Arriba-Riny2Arriba)/N;
      dxx(n) = (n-1)*0.8*d2x/Nwires;
      dxy(n) = (n-1)*0.8*d2y/Nwires;
      Rx(n,1) = Routx2Der-d2x/2+dxx(n);
      Ry(n,1) = Routy2Arriba-d2y/2+dxy(n);
      
      for k=2:length(alfa)
        if ( sin(alfa(k)) >= 0 )
          Riny2 = Riny2Arriba; 
          Routy2 = Routy2Arriba; 
        else
          Riny2 = Riny2Abajo; 
          Routy2 = Routy2Abajo; 
        end
        
        if ( cos(alfa(k)) >= 0 )
          Rinx2 = Rinx2Der;
          Routx2 = Routx2Der;
        else
          Rinx2 = Rinx2Izq; 
          Routx2 = Routx2Izq; 
        end
        
        d2x = (Routx2-Rinx2)/N;
        d2y = (Routy2-Riny2)/N;
        
        Rx(n,k) = Routx2-d2x/2+dxx(n) - d2x*(k-1)/Npoints;
        Ry(n,k) = Routy2-d2y/2+dxy(n) - d2y*(k-1)/Npoints;
        
      end
      
      dpx(n,:) = cos(alfa).*Rx(n,:);
      dpy(n,:) = sin(alfa).*Ry(n,:);  

    end


    %% Figure 8 coil
    px = [];
    py = [];
    
    px2=[];
    py2=[];
    index = [];
    % Concateno ambos enrrollados
    for n=1:Nwires     
        
        px = [px lpx(n,:)+CenterLeft];
        py = [py lpy(n,:)+CenterYLeft];
        
        px2 = [px2 dpx(n,:)+CenterRight];
        py2 = [py2 dpy(n,:)+CenterYRight];
        
    end
    
    % Source points (where there is a current source)
    GammaLeft = [px',py',zeros(length(px),1)];
    GammaRight = [px2',py2',zeros(length(px2),1)];

    if (Hsteps>1)
        dH = H/Hsteps;
    else
        dH = 0;
    end
    
    % Left
    L = size(GammaLeft,1);
    GammaAux = GammaLeft;
    GammaLeft = [];
    for k=1:Hsteps
        if (Hsteps == 1)
            h = H/2;
        else
            h = (k-1)*(H/(Hsteps-1));
        end
        
        Gamma2 = GammaAux;
        Gamma2(:,3) = Gamma2(:,3) + h;
        GammaLeft{k} = Gamma2;
    end
    
    % Right
    L = size(GammaRight,1);
    GammaAux = GammaRight;
    GammaRight = [];
    for k=1:Hsteps
        if (Hsteps == 1)
            h = H/2;
        else
            h = (k-1)*(H/(Hsteps-1));
        end
        
        Gamma2 = GammaAux;
        Gamma2(:,3) = Gamma2(:,3) + h;
        GammaRight{k} = Gamma2;
    end
    
    alpha = -1/(Nwires*Hsteps);
%     figure(1);hold on;
%     for i=1:length(GammaLeft)
%       plot3(GammaLeft{i}(:,1),GammaLeft{i}(:,2),GammaLeft{i}(:,3),'b');zlim([0 0.2]);
%       plot3(GammaRight{i}(:,1),GammaRight{i}(:,2),GammaRight{i}(:,3),'b');zlim([0 0.2]);
%     end
    
    Gamma = [];
    for i=1:length(GammaLeft)
      Gamma{2*i-1} = GammaLeft{i};
      Gamma{2*i} = GammaRight{i};
    end
end
