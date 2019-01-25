`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/24 15:11:05
// Design Name: 
// Module Name: PolarDecoderController
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


module PolarDecoderController#(
parameter LLR_RAM_DATA_WIDTH=8,
parameter CODE_LENGTH=1024,//the value must be the power of 2
parameter FROZEN_BITS_LENGTH=48,
parameter COUNTER_WIDTH=10,
parameter LLR_RAM_ADDR_WIDTH=11,
parameter FROZEN_BIT_INDICATION_RAM_ADDR_WIDTH=10
)
(
        input wire reset,
        input wire clk,
        input wire [COUNTER_WIDTH-1:0] id_count_value,
        output reg  id_counter_start_or_stop,
        output reg  ram_read_sel,//0 is llr init ram ,1 is llr mid ram
        output reg  llr_cal_f_or_g_sel,//0 is f ,1 is g
        output reg  [LLR_RAM_ADDR_WIDTH-1:0] llr_init_ram_rd_addr,
        output reg  [LLR_RAM_ADDR_WIDTH-1:0] llr_mid_ram_rd_addr,
        output reg  [LLR_RAM_ADDR_WIDTH-1:0] llr_mid_ram_wr_addr,
        output reg  [FROZEN_BIT_INDICATION_RAM_ADDR_WIDTH-1:0] frozen_bit_indication_ram_rd_addr
);


assign frozen_bit_indication_ram_rd_addr=id_count_value;
assign ram_read_sel=id_count_value<BOTTOM_LAYER_LLR_MAX_ID?0:1;

reg [LLR_RAM_ADDR_WIDTH-1:0] llr_cal_counter=0;
//FSM for LLR CAL Controll
localparam BOTTOM_LAYER_LLR_MAX_ID=CODE_LENGTH/2-1;
localparam IDLE_STATE=8'd0;
localparam CAL_STATE=8'd1;
localparam UPDATE_ID_STATE=8'd2;
reg [7:0] current_state=IDLE_STATE;
reg [7:0] next_state=IDLE_STATE;

always_ff@(clk or reset)
begin
    if(reset)
    begin
        current_state<=IDLE_STATE;
    end
    else
    begin
        current_state<=next_state;
    end
end

always_comb@(current_state or reset)
begin
    if(reset)
    begin
         next_state=IDLE_STATE;
    end
    else
    begin
            case(current_state)
                IDLE_STATE:
                            begin
                        
                            end
                CAL_STATE:
                            begin
                    
                            end
                UPDATE_ID_STATE:
                            begin
        
                            end         
            endcase 
     end
end
//end of FSM for LLR CAL Controll


always_ff@(clk or reset)
begin
    if(reset)
    begin
        llr_cal_counter<=0;
    end
end

endmodule
