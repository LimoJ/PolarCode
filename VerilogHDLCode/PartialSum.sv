`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/26 09:56:02
// Design Name: 
// Module Name: PartialSum
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


module PartialSum#(
)(
    input wire pre_f,
    input wire a,
    output reg f,
    output reg g,
    output reg g_valid,
    input f_g_select //0is f ,1s g
    );

assign f= (~f_g_select)?a:(a^pre_f);    
assign g=a;
assign g_valid=f_g_select;

endmodule
