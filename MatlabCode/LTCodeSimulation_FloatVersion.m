k=8;  %signal source will be divide to k group  ;
overhead=13;
signal_length=1024;

s=randi([0,1],1,signal_length);
[c,G]=LTFountainEncode(s,k,overhead);
[decoded_s,actually_loop,if_decoded_succeed]=LTFountainDecode(c,G,200);
[bit_err_num,bit_err_ratio]=biterr(s,decoded_s);