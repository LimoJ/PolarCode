function [x] = BitReverse(u)
%BitReverse (B)
%   u, the input vector,length of u must be the pow of 2.
%   x,  the output vector.
%for example N=8: input  u000 u001 u010 u011 u100 u101 u110 u111
%                 output u000 u100 u010 u110 u001 u101 u011 u111
%		--->B4 = R4 
%B8 = R8
%		--->B4 = R4

%test code 
% u=[000 001 010 011 100 101 110 111];
% x=BitReverse(u);
% x


l = length(u);%vector length
N = log2(l);%bit width

assert(N>0);
assert(l>=4);
x=BitShuffle(u);
if(l>=8)
		x(1:l/2)  = BitReverse(x(1:l/2));
		x(l/2+1:l)= BitReverse(x(l/2+1:l));
end
    
end

