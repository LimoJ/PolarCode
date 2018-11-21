function [x] = FKroneckerPower(u)
%F KroneckerPower
%   u, the input vector,length of u must be the pow of 2.
%   x, the output vector.
%for example 1 N=8:
%               1 1 1 1 0 0 0 0 --->0 0 0 1 0 0 0 0   
%testcode 
% u=[1 1 1 1 0 0 0 0];
% x = FKroneckerPower(u);

l = length(u);%vector length
x =u;
    if(l>=2)

        x(1:l/2)=xor(logical(u(1:l/2)),u(l/2+1:l));
        x(1:l/2)= FKroneckerPower( x(1:l/2));
        x(l/2+1:l)= FKroneckerPower(x(l/2+1:l));
    end
    
end

