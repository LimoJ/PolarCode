function [y] = BinCyclicLeftShift(x,MaxBitNum)
%   BinCyclicLeftShift
%   x ,input to be cyclic shifted 
%   y , output cyclic left shifted 1 bit

binFormatX=dec2bin(x,MaxBitNum);
maxBit=binFormatX(1);
    for i=1:MaxBitNum-1
        binFormatX(i)= binFormatX(i+1);
    end
binFormatX(MaxBitNum)=maxBit;
y=bin2dec(binFormatX);
end

