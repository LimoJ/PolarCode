`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: LimoJ
// 
// Create Date: 2019/01/18 20:43:01
// Design Name: 
// Module Name: LLR
// Project Name: RatelessPolarCode
// Target Devices: 
// Tool Versions: vivado 2016.4
// Description: 
// 	This Moudle is for LLR Calculation
// Dependencies: 
// 	LLRf.sv
// 	LLRg.sv
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  Combine logic 
//////////////////////////////////////////////////////////////////////////////////


module LLR#(
parameter DATA_WIDTH=8
)(
    input  wire signed [DATA_WIDTH-1:0]b,
    input  wire signed [DATA_WIDTH-1:0]a,
    input  wire us,//1b
	input  wire sel,//1b
    output reg signed [DATA_WIDTH-1:0]llr_data_out
    );

wire llrf_data_out;
wire llrg_data_out;

    LLRf#(
	.DATA_WIDTH(DATA_WIDTH)
	) LLRf_inst(
	.b(b)
	.a(a)
	.llrf_data_out(llrf_data_out)
	)

    LLRg#(
	.DATA_WIDTH(DATA_WIDTH)
	) LLRg_inst(
	.b(b)
	.a(a)
	.us(us)
	.llrg_data_out(llrg_data_out)
	)
	
assign llr_data_out= (sel==1)?llrf_data_out:llrg_data_out;
   
endmodule
