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
reg  signed [DATA_WIDTH-1:0]abs_a;
reg  signed [DATA_WIDTH-1:0]abs_b;
reg  signed [DATA_WIDTH-1:0]min_abs;   
always_comb
begin
     signed_bit=a[DATA_WIDTH-1]^b[DATA_WIDTH-1];
end    

always_comb
begin
     if(a[DATA_WIDTH-1]==0)
     begin
        abs_a=a;
     end
     else
     begin  
        abs_a=-a;
     end
end

always_comb
begin
     if(b[DATA_WIDTH-1]==0)
     begin
        abs_b=b;
     end
     else
     begin  
        abs_b=-b;
     end
end

assign  min_abs=abs_a<=abs_b?abs_a:abs_b;

always_comb
begin
    if(signed_bit==0)
    begin
        llrf_data_out=min_abs;
    end
    else
    begin
        llrf_data_out=-min_abs;
    end
end    
endmodule
