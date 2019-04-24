function [ud] = corregir_medicion(ud)
    ind = find(ud.stdX > std2(ud.stdX));
    
    if isempty(ind)
        return;
    end
    
    c = ceil(ind/size(ud.stdX,1));
    f = 1+mod(ind-1,size(ud.stdX,1));
    
    L = size(ud.BxAcum,3);
    for k=1:length(c)
        med(1:L) = ud.BxAcum(f(k),c(k),:);
        
        dif = (abs(med-mean(med)));
        pos = find(dif == max(dif));
        
        new_med = [med(1:pos-1) med(pos+1:end)];
        
        ud.Bx(f(k),c(k)) = mean(new_med);
        ud.stdX(f(k),c(k)) = std(new_med);
        
    end
    
end