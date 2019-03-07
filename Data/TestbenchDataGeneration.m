clear;
addpath('../MatlabCode/');

%Parameter
N=1024;
K=512;
R=K/N;
EbNo = 3;% EbNo in dB
bps = 2;% bits per symbol, 1 for BPSK, 2 for QPSK
EsNo = EbNo + 10*log10(bps);
snrdB = EsNo + 10*log10(R);% in dB
noiseVar = 1./(10.^(snrdB/10));
[Ua,Uac]=ChannelPolar(N,K,noiseVar);

total_bit_err_num=0;
loop_num=1;
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


PolarDecoderTBDataIn=floor(127*demodedData/max(abs(demodedData)));
max(PolarDecoderTBDataIn)
min(PolarDecoderTBDataIn)
%demodedData=x;
%Decode
[decoded_u,llr]=PolarDecode(PolarDecoderTBDataIn,N,Uac,noiseVar);
decoded_s=UVectorDeconstruct(decoded_u,Ua);
[bit_err_num,bit_err_ratio]=biterr(s,decoded_s);
total_bit_err_num=total_bit_err_num+bit_err_num;
end
total_bit_err_ratio=total_bit_err_num/(loop_num*K)

PolarDecoderTBDataInfileID = fopen('PolarDecoderTBDataIn.txt','w');
fprintf(PolarDecoderTBDataInfileID, '%d\n', floor(PolarDecoderTBDataIn));
fclose(PolarDecoderTBDataInfileID);

UacCoefileID = fopen('Uac.coe','w');
fprintf(UacCoefileID,'MEMORY_INITIALIZATION_RADIX=2;\n');
fprintf(UacCoefileID,'MEMORY_INITIALIZATION_VECTOR=\n');
fprintf(UacCoefileID,'%d\n',Uac);
fclose(UacCoefileID);


UacMiffileID = fopen('Uac.mif','w');
fprintf(UacMiffileID,'%x\n',Uac);
fclose(UacMiffileID);

ufileID = fopen('u.txt','w');
fprintf(ufileID, '%d\n', u);
fclose(ufileID);

LLRfileID=fopen('LLR.txt','w');
fprintf(LLRfileID, '%d\n',llr);
fclose(LLRfileID);