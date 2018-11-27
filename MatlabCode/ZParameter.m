function [y] = ZParameter(Z,N)
z=zeros(1,N);
z(1)=Z;
    for i = 1:log2(N)
            Zpre = z;              
        for j = 1 : 2^(i-1)   
            z(2*j-1) = 2*Zpre(j) - Zpre(j)^2;
            z(2*j) = Zpre(j)^2;    
        end
    end
    y = z;
end

