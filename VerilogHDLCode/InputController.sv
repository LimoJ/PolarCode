`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/27 10:37:59
// Design Name: 
// Module Name: InputController
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


module InputController#(
parameter INPUT_LENGTH=1024,
parameter ADDR_WIDTH=10,
parameter DATA_WIDTH=8,
parameter STATE_WIDTH=10, 
parameter INPUT_STATE=10'd2,
parameter INNER_COUNTER_WIDTH=10, 
parameter RESET_WAIT_TIME=20 // for ram  reset
)(
    input wire clk,
    input wire reset,
    input wire [STATE_WIDTH-1:0]state,
    input wire saxis_tvalid,
    input wire saxis_tlast,
    input wire [DATA_WIDTH-1:0] saxis_tdata,
    output reg saxis_tready,
    output reg [ADDR_WIDTH-1:0] addr_to_bram,
    output reg [DATA_WIDTH-1:0] data_to_bram,
    output reg enablea_to_bram,
    output reg enableb_to_bram,
    output reg write_enable_to_bram,
    output reg error
    );


// data to llr init bram
assign data_to_bram=saxis_tdata;
//inner counter //for addr generator   
reg [INNER_COUNTER_WIDTH-1:0] inner_counter;
reg [INNER_COUNTER_WIDTH-1:0] inner_counter1;
//axis tready    
assign saxis_tready=(state==INPUT_STATE)&&(inner_counter1>RESET_WAIT_TIME);

always_ff@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        inner_counter1<=0;
    end
    else if((state==INPUT_STATE)&&inner_counter1<=RESET_WAIT_TIME)
    begin
        inner_counter1<=inner_counter1+1'b1;
    end
    else
    begin
        inner_counter1<=inner_counter1;
    end
 end   
    
always_ff@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        inner_counter<=0;
    end
    else if(state!=INPUT_STATE)
    begin
        inner_counter<=0;
    end
    else
    begin
        if(saxis_tready&saxis_tvalid)
        begin
            inner_counter<=inner_counter+1'b1;
        end
        else
        begin
             inner_counter<=inner_counter;
        end
    end    
end

//addr to bram
assign addr_to_bram=inner_counter;
assign enablea_to_bram=(state==INPUT_STATE);
assign enableb_to_bram=0;

assign write_enable_to_bram=saxis_tready&saxis_tvalid;
//err
assign error=saxis_tlast&&(inner_counter!=INPUT_LENGTH-1);
endmodule
