function [s,actuallyLoop,ifDecodeSucceed] = LTFountainDecode(c,G,MaxLoopNum)
%LTFountainDecode
%   This Function is LTcode Encode function
%   c is the receive bit
%   G is the generator matrix 

dVector=c(:,1);
c=c(:,2:end);
[m,n] = size(c);
[p,q] = size(G);
assert(m==q);
actuallyLoop=MaxLoopNum;
s=zeros(p,n);
sXorFlag=zeros(1,p);
sRecoverd =zeros(1,p);
ifDecodeSucceed='False';

for loop=1:MaxLoopNum
    
    for i=1:m
        if(dVector(i)==1)
            for j=1:p
                if(G(j,i)==1)
                    s(j,:)=c(i,:);
                    sRecoverd(j)=1;
                    dVector(i)=0;
                    G(j,i)=0;
                end
            end
        end
    end

   
    for i=1:p
        if(sXorFlag(i)==0 && sRecoverd(i)==1)
            sXorFlag(i)=1;
            for j=1:m 
               if(dVector(j)>1 && G(i,j)==1)
                    assert(dVector(j)~=1);
                    c(j,:)=xor(c(j,:),s(i,:));
                    dVector(j)=dVector(j)-1;
                    G(i,j)= 0;
               end
            end
        end
    end

    
    if(norm(G,2)==0 || sum(sRecoverd)==p)
        actuallyLoop=loop;
        if(sum(sRecoverd)==p)
            ifDecodeSucceed='True';
        end
        break;  
    end
    
end 
   s=reshape(s,1,[]);
end



