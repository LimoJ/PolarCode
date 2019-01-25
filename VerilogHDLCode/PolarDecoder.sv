`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/18 18:55:22
// Design Name: PolarDecoder
// Module Name: PolarDecoder
// Project Name: CodelessPolarCode
// Target Devices:ZC706 
// Tool Versions:vivado 2016.4 
// Description: Polar Decoder
// 
// Dependencies: 
// 	LLRg.sv
//  LLRf.sv
//  LLR.sv
// Revision:
// Revision 0.01 - File Created
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////


module PolarDecoder#(
parameter DATA_WIDTH=8,
parameter CODE_LENGTH=1024,//the value must be the power of 2
parameter FROZEN_BITS_LENGTH=48
)
(
    input wire reset,
    input wire clk,
    input wire [DATA_WIDTH-1:0] data_in,
    input wire [DATA_WIDTH-1:0] data_out
    );
localparam COUNTER_WIDTH = $clog2(CODE_LENGTH);	



    
endmodule
