% 
u=load('u.txt');
sim_data=load('Data_out.txt');
[~,ratio]=biterr(u,sim_data)
figure(1);
stem(sim_data,'r');
hold on;
stem(u,'b');


llr=load('LLR.txt');
llr_out=load('LLR_out.txt');
figure(2);
plot(llr,'r');
hold on;
plot(llr_out,'b');