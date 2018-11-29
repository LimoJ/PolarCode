function [u] = PolarDecode(y,N,Uac,noiseVar)
%PolarDecode
u=zeros(1,N);

for i=1:N
    if(Uac(i)==1)
        u(i)=0;
    else
        llr=LogarithmLikelihoodRatio(y,u,i,N,noiseVar);
        if(llr>=0)
            u(i)=0;
        else
            u(i)=1;   
        end
    end
end
