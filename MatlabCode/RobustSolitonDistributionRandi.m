function [r] = RobustSolitonDistributionRandi(k,delta,constp)
%RobustSolitonDistribution
%   delta is a bound on the probability that the decoder fails to complete decoding process after a certain number N of code signals has been received
%   constp is a constant greater than 0

IRSum=0;
    for index = 1:1:k
        IRSum=IRSum+IdealSolitonDistributionRandi(index,k)+RSDSupplementaryDistribution(index,k,delta,constp);
    end

beta=IRSum;
i=randi([1,k]);
r=(IdealSolitonDistributionRandi(i,k)+RSDSupplementaryDistribution(i,k,delta,constp))/beta;

end

