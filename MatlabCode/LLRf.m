function [re] = LLRf(a,b)
re=log((1+exp(a+b))/(exp(a)+exp(b)));
end

