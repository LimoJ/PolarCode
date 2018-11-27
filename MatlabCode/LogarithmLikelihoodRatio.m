function [re] = LogarithmLikelihoodRatio(y,u_est,i,N,noiseVar)
%LogarithmLikliehoodRatio
%    
if(rem(i,2)==1)
    if(N==1)
        re=2*y/(noiseVar);  
    else
        u_xor=xor(u_est(1:2:i-1),u_est(2:2:i-1));
        u_even=u_est(2:2:i-1);
        re=LLRf(LogarithmLikelihoodRatio(y(1:N/2),u_xor,(i+1)/2,N/2,noiseVar),LogarithmLikelihoodRatio(y(1+N/2:N),u_even,(i+1)/2,N/2,noiseVar));
    end
else
    u_xor=xor(u_est(1:2:i-2),u_est(2:2:i-2));
    u_even=u_est(2:2:i-2);
	re=LLRg(LogarithmLikelihoodRatio(y(1:N/2),u_xor,i/2,N/2,noiseVar),LogarithmLikelihoodRatio(y(1+N/2:N),u_even,i/2,N/2,noiseVar),u_est(i-1));
end

end


