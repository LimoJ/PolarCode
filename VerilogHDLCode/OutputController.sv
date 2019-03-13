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
parameter OUTPUT_LENGTH=1024,
parameter ADDR_WIDTH=10,
parameter DATA_WIDTH=1,
parameter STATE_WIDTH=8, 
parameter OUTPUT_WAIT_STATE=10'd256,
parameter OUTPUT_STATE=10'd512,
parameter INNER_COUNTER_WIDTH=11 
)(
    input wire clk,
    input wire reset,
    input wire [STATE_WIDTH-1:0]state,
    input wire [DATA_WIDTH-1:0] data_from_bram,
    input wire maxis_tready,
    output reg [DATA_WIDTH-1:0] maxis_tdata,
    output reg maxis_tlast,
    output reg maxis_tvalid,
    output reg [ADDR_WIDTH-1:0] addr_to_bram,
    output reg read_enable_to_bram
    );

// maxis_tvalid    
reg tmp_maxis_tlast;
reg tmp_maxis_tvalid;

// data to output_buffer bram
assign maxis_tdata=data_from_bram;
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
        if(maxis_tready&tmp_maxis_tvalid)
        begin
            inner_counter<=inner_counter+1'b1;
        end
        else
        begin
             inner_counter<=inner_counter;
        end
    end    
end

assign tmp_maxis_tvalid=((state==OUTPUT_STATE))&&(inner_counter<=OUTPUT_LENGTH-1);
assign tmp_maxis_tlast=(inner_counter==OUTPUT_LENGTH-1);

always_ff@(posedge clk)
begin
maxis_tvalid=tmp_maxis_tvalid;
end

always_ff@(posedge clk)
begin
maxis_tlast=tmp_maxis_tlast;
end
//addr to output_buffer_bram
assign addr_to_bram=inner_counter;
//enable to output_buffer_bram
assign read_enable_to_bram=(state==OUTPUT_STATE)&&(tmp_maxis_tvalid&maxis_tready);

endmodule

