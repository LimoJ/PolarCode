`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: LimoJ
// 
// Create Date: 2019/01/18 19:28:51
// Design Name: 
// Module Name: LLRg
// Project Name: RatelessPolarCode
// Target Devices:ZC706 
// Tool Versions: 
// Description: 
//  This Moudle is for LLRg Calculation
// Dependencies: 
//  None  
// Revision 0.01 - File Created
// Additional Comments:
// 	Combine logic 
//////////////////////////////////////////////////////////////////////////////////


module LLRg#(
parameter DATA_WIDTH=8
)(
    input  wire signed [DATA_WIDTH-1:0]b,
    input  wire signed [DATA_WIDTH-1:0]a,
    input  wire us,//1b
    output reg signed [DATA_WIDTH-1:0]llrg_data_out
    );

reg signed [DATA_WIDTH:0]sum;
reg signed [DATA_WIDTH-1:0]concat_a;
reg signed [DATA_WIDTH:0]shifted_sum;
always_comb
begin
    if(us==0)
    begin
        concat_a=a;
    end
    else
    begin
        concat_a=-a;
    end
end

always_comb
begin
    sum=concat_a+b;
end

always_comb
begin
    shifted_sum=(sum>>>1);
end

always_comb
begin
    llrg_data_out=sum>0&&sum[0]==1?shifted_sum[DATA_WIDTH-1:0]+1:shifted_sum[DATA_WIDTH-1:0];
end


endmodule
