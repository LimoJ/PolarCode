`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: LimoJ
// 
// Create Date: 2019/01/18 20:32:59
// Design Name: 
// Module Name: LLRf
// Project Name: RatelessPolarCode
// Target Devices: 
// Tool Versions: 
// Description: 
//  This Moudle is for LLRf Calculation
// Dependencies: 
//  None
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  Combine logic 
//////////////////////////////////////////////////////////////////////////////////


module LLRf#(
parameter DATA_WIDTH=8
)(
    input  wire signed [DATA_WIDTH-1:0] b,
    input  wire signed [DATA_WIDTH-1:0] a,
    output reg signed [DATA_WIDTH-1:0] llrf_data_out
    );

reg  signed_bit;
reg  significant_bits;
   
always_comb
begin
     signed_bit=a[DATA_WIDTH-1]^b[DATA_WIDTH-1];
end    

always_comb
begin
     significant_bits=a[DATA_WIDTH-2:0]<b[DATA_WIDTH-2:0]?a[DATA_WIDTH-2:0]:b[DATA_WIDTH-2:0];
end

always_comb
begin
    llrf_data_out={signed_bit,significant_bits};
end    
endmodule
