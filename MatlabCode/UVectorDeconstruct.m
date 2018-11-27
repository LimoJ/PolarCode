function [s] = UVectorDeconstruct(u,Ua)
%UVectorDeconstruct
K=sum(Ua);
N=length(Ua);
s=zeros(1,K);
j=1;
    for i=1:N
        if(Ua(i)==1)
            s(j)=u(i);
            j=j+1;
        end
    end
end

