`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/23 20:25:36
// Design Name: 
// Module Name: LLRCalIDCounter
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


module BitIDCounter#(
parameter COUNTER_WIDTH=10
)
(
    input wire reset,
    input wire clk,
    input wire [COUNTER_WIDTH-1:0] load_value,
    input wire load,
    input wire start_or_stop,
    output reg [COUNTER_WIDTH-1:0] id_count_value
    );
    
reg [COUNTER_WIDTH-1:0] operation_id_counter;
         
always_ff @(posedge clk or negedge reset)
begin    
    if(reset)
    begin
       operation_id_counter<=0;
    end
    else if(load)
       operation_id_counter<=load_value;
    else if(start_or_stop)
    begin
        operation_id_counter<=operation_id_counter+1'b1;
    end
    else
    begin
        operation_id_counter<=operation_id_counter;
    end
end
    
assign id_count_value=operation_id_counter;

endmodule
