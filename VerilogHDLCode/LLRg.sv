`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/18 19:28:51
// Design Name: 
// Module Name: LLRg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// combine logic 
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
    concat_a={us,a[DATA_WIDTH-2:0]};
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
    llrg_data_out=shifted_sum[DATA_WIDTH:0];
end


endmodule
