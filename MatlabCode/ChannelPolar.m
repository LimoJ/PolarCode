function [Ua,Uac] = ChannelPolar(N,K,noiseVar)
%BEC-Z(W) ChannelPolar
% Z(W) init value is 0.5

y=ZParameter(exp(-1/(2*noiseVar)),N);
[i,j]=sort(y);
freeze_bit_set=j(K+1:N);
free_bit_set=j(1:K);
Uac=zeros(1,N);
Ua=zeros(1,N);
for i=freeze_bit_set(1:N-K)
    Uac(i)=1;
end
for i=free_bit_set(1:K)
    Ua(i)=1;
end
end

