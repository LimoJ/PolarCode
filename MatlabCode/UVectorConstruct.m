function [u] = UVectorConstruct(s,Ua)
%UVectorConstruct
K=length(s);
N=length(Ua);
u=zeros(1,N);
j=1;
    for i=1:N
        if(Ua(i)==1)
            u(i)=s(j);
            j=j+1;
        end
    end
end

