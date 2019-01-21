`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/18 20:43:01
// Design Name: 
// Module Name: LLR
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
// 
//////////////////////////////////////////////////////////////////////////////////


module LLR#(
parameter DATA_WIDTH=8
)(
    input  wire signed [DATA_WIDTH-1:0]b,
    input  wire signed [DATA_WIDTH-1:0]a,
    input  wire us,//1b
    output reg signed [DATA_WIDTH-1:0]llr_data_out
    );
    
    
endmodule
