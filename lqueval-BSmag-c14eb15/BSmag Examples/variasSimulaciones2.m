close all;
clear all;
Rin1 = 0.02836;
Rin2 = 0.02811;
Rout1 = 0.04498;
Rout2 = 0.04443;
dR = 1e-3;

load('C:\Users\MANCINO\Desktop\nTMS\MATLAB\lqueval-BSmag-c14eb15\BSmag Examples\BUEN_SAMPLEO_2mm_77x57_dz=15,5mm_pot=9.mat');

D = 25.4/24;

for (i = 1:2)
    despX = -D*(i-3)*1e-3;
    for (k = 1:5)

    %     R(1) = Rin1 + (k-3)*dR;
    %     R(2) = Rin2 + (k-3)*dR;
    %     R(3) = Rout1 + (k-3)*dR;
    %     R(4) = Rout2 + (k-3)*dR;
        R = 0;
        
        despY = -D*(k-1)*1e-3;
        sim = CalcularCamposSensados(15.5e-3,2,77,57,[despX despY]);
    %     [bx,by,bz] = Campo_figura8(2,77,57,0,0,-15.5e-3,R);


        med.Bx{i,k} = sim.Bx;
        med.By{i,k} = sim.By;
        med.Bz{i,k} = sim.Bz;
        Bmed = max(abs(ud.Bx(:)));
        Bsim = max(abs(med.Bx{i,k}(:)));
        med.stdX{i,k} = 100 - 100*std2(med.Bx{i,k}/Bsim - ud.Bx/Bmed);
        med.stdY{i,k} = 100 - 100*std2(med.By{i,k}/Bsim - ud.By/Bmed);
        med.stdZ{i,k} = 100 - 100*std2(med.Bz{i,k}/Bsim - ud.Bz/Bmed);
        med.despX(i) = despX;
        med.despY(k) = despY;
        
        matX(i,k) = med.stdX{i,k};
        matY(i,k) = med.stdY{i,k};
        matZ(i,k) = med.stdZ{i,k};
    end
end

save('variasMuestras3','med');