function [u,llr] = PolarDecode(y,N,Uac,noiseVar)
%PolarDecode
u=zeros(1,N);
llr=zeros(1,N);
for i=1:N
    llr(i)=LogarithmLikelihoodRatio(y,u,i,N,noiseVar);
    if(Uac(i)==1)
        u(i)=0;
    else
        if(llr(i)>=0)
            u(i)=0;
        else
            u(i)=1;   
        end
    end
end
