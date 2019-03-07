function [re] = LLRg(a,b,us)
% g(a,b,us)= power(-1,us)*a+b 
%  re=(power(-1,us)*a+b) divide 2 to make aggreement with verilog
%  trans re to integer in direction which make abs(re) greater to make aggreement with verilog. 
re=(power(-1,us)*a+b)/2;
if(re>=0)
    re=ceil(re);
else
    re=floor(re);
end

