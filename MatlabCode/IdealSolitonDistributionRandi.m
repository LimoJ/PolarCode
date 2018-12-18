function [r] = IdealSolitonDistributionRandi(i,k)
%IdealSolitonDistributionRandi
assert(i<=k)
assert(i>=0)
    if(i==1)
        r=1/k;
    else
        r=1/(i*(i-1));
    end
end

