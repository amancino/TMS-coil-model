for (k = 1:18)
    dz = -1*(k-1)*1e-3;
    
    [bx,by,bz] = Campo_figura8(5,31,23,0,0,dz);
    med.Bx{k} = bx;
    med.By{k} = by;
    med.Bz{k} = bz;
end

save('variasMuestras','med');