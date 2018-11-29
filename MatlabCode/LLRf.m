function [re] = LLRf(a,b)

%re=log((1+exp(a+b))/(exp(a)+exp(b)));
%simplied as   
re=sign(a)*sign(b)*min(abs(a),abs(b));
end

