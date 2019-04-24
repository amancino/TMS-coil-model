% load('variasMuestras'); % Variacion de Dz
load('variasMuestras2'); % Variacion de radios internos y externos

for (k=1:size(med.Bx,2))

    figure(k);

%     surf(med.X/1000,med.Y/1000,abs(med.Bx{k}));
    surf(abs(med.Bz{k}))
    xlabel('x');ylabel('y');legend(['dz = ' num2str(k-1) 'mm']);
    zlim([0 1.3]);
end