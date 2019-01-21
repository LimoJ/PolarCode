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
// Dependencies: LLRg.sv
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PolarDecoder#(
parameter DATA_WIDTH=8
)
(
    input wire clk,
    input wire [DATA_WIDTH-1:0] data_in,
    input wire [DATA_WIDTH-1:0] data_out
    );
    
always_ff @(posedge clk)
begin    

end
    
endmodule
