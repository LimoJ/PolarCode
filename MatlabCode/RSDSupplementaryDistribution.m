function [r] = RSDSupplementaryDistribution(i,k,delta,c)
%SupplementaryDistribution of RobustSolitonDistribution
assert(i<=k)
assert(i>=0)
R=c*log(k/delta)*sqrt(k);
    if(i>=1 && i<=k/(R-1))
        r=R/(i*k);
    elseif(i==k/R)
        r=R*log(R/delta);
    else
        r=0;
    end
           
end

