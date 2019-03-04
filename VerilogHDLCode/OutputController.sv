`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/27 15:07:50
// Design Name: 
// Module Name: OutputController
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


module OutputController#(
parameter CODE_LENGTH=1024,
parameter ADDR_WIDTH=10,
parameter DATA_WIDTH=1,
parameter STATE_WIDTH=8, 
parameter OUTPUT_WAIT_STATE=10'd256,
parameter OUTPUT_STATE=10'd512,
parameter INNER_COUNTER_WIDTH=10 
)(
    input wire clk,
    input wire reset,
    input wire [STATE_WIDTH-1:0]state,
    input wire [DATA_WIDTH-1:0] data_from_output_buffer_bram,
    input wire maxis_tready,
    output reg [DATA_WIDTH-1:0] maxis_tdata,
    output reg maxis_tlast,
    output reg maxis_tvalid,
    output reg [ADDR_WIDTH-1:0] addr_to_output_buffer_bram,
    output reg read_enable_to_output_buffer_bram
    );


// data to output_buffer bram
assign maxis_tdata=data_from_output_buffer_bram;
//inner counter 
reg [INNER_COUNTER_WIDTH-1:0] inner_counter;

always_ff@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        inner_counter<=0;
    end
    else if(state!=OUTPUT_STATE)
    begin
        inner_counter<=0;
    end
    else
    begin
        if(maxis_tready&maxis_tvalid)
        begin
            inner_counter<=inner_counter+1'b1;
        end
        else
        begin
             inner_counter<=inner_counter;
        end
    end    
end
// maxis_tvalid    
assign maxis_tvalid=((state==OUTPUT_STATE)||(state==OUTPUT_WAIT_STATE))&&(inner_counter<CODE_LENGTH);
assign maxis_tlast=(inner_counter==CODE_LENGTH-1);
//addr to output_buffer_bram
assign addr_to_output_buffer_bram=inner_counter;
//enable to output_buffer_bram
assign read_enable_to_output_buffer_bram=(state==OUTPUT_STATE)&&(maxis_tvalid&maxis_tready);

endmodule

