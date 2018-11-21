function [x] = PolarEncode(u)
%PolorEncode x=BNFN
%   u, the input vector,length of u must be the pow of 2.
%   x,  the output vector.
x = FKroneckerPower(BitReverse(u));
end

