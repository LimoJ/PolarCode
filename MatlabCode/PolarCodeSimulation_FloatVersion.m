clear;
%Parameter
N=512;
K=59;
R=K/N;
EbNo = 0.5;% EbNo in dB
bps = 2;% bits per symbol, 1 for BPSK, 2 for QPSK
EsNo = EbNo + 10*log10(bps);
snrdB = EsNo + 10*log10(R);% in dB
noiseVar = 1./(10.^(snrdB/10));
[Ua,Uac]=ChannelPolar(N,K);

total_bit_err_num=0;
loop_num=10000;
for  i=1:loop_num
%Encode
s=randi([0,1],1,K);
u=UVectorConstruct(s,Ua);
x = PolarEncode(u);

% Modulator, Channel, Demodulator
qpskMod = comm.QPSKModulator('BitInput',true);
chan = comm.AWGNChannel('NoiseMethod','Variance','Variance',noiseVar);
qpskDemod = comm.QPSKDemodulator('BitOutput',true,'DecisionMethod','Approximate log-likelihood ratio','Variance',noiseVar);
signal=qpskMod(x');   
awgn_added_signal=chan(signal);   
demodedData=qpskDemod(awgn_added_signal)';   
%Decode
decoded_u=PolarDecode(demodedData,N,Uac,noiseVar);
decoded_s=UVectorDeconstruct(decoded_u,Ua);
[bit_err_num,bit_err_ratio]=biterr(s,decoded_s);
total_bit_err_num=total_bit_err_num+bit_err_num;
end
total_bit_err_ratio=total_bit_err_num/(C*K)

