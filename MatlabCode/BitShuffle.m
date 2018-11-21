function [x] = BitShuffle(u)
%BitShuffle (R)
%for example N=8: input  u000 u001 u010 u011 u100 u101 u110 u111
%                 output u000 u010 u100 u110 u001 u011 u101 u111
%   u, the input vector,length of u must be the pow of 2.
%   x,  the output vector.
l = length(u);%vector length
N = log2(l);%bit width
assert(N>0);
assert(l>=4);
x = zeros(1,l);
    for CIndex=0:l-1
        x((CIndex2MIndex(CIndex)))=u(CIndex2MIndex(BinCyclicLeftShift(CIndex,N)));
    end
end

