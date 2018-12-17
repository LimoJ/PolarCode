function [c,G] = LTFountainEncode(s,k,o)
%LTFountainEncode
%   This Function is LTcode Encode function
%   s is the source
%   k means that s should be divided to k groups.
%   d is the degree
%   o is the overhead num ,the output c will be a (s/k)*(k+o) 
%   G is generatoe matrix of encode
N=length(s);
sGruops=reshape(s,k,N/k);
c=(zeros(o+k,N/k));

constp=0.03;
delta=0.5;

dVector=zeros(o+k,1);
    for i=1:(o+k)
        dVector(i)=round(RobustSolitonDistributionRandi(k,delta,constp)*(k-1)+1);
    end
    
G=zeros(k,o+k);
    for i=1:o+k
        selectGroup=randperm(k,dVector(i));
        for j=1:dVector(i)
            c(i,:)=xor(sGruops(selectGroup(j),:),c(i,:));
            G(selectGroup(j),i)=1;
        end
    end

c=[dVector c];
end

