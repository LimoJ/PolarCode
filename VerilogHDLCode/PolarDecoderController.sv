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
        output reg  ram_read_sel,//0 is llr init ram ,1 is llr mid ram
        output reg  llr_cal_f_or_g_sel,//0 is f ,1 is g
        output reg  [LLR_RAM_ADDR_WIDTH-1:0] llr_init_ram_rd_addr,
        output reg  [LLR_RAM_ADDR_WIDTH-1:0] llr_mid_ram_rd_addr,
        output reg  [LLR_RAM_ADDR_WIDTH-1:0] llr_mid_ram_wr_addr,
        output reg  [FROZEN_BIT_INDICATION_RAM_ADDR_WIDTH-1:0] frozen_bit_indication_ram_rd_addr,
		output reg  sigle_op_fin,
		input wire  frozen_bit_indication_data
);


assign frozen_bit_indication_ram_rd_addr=op_id_counter;
assign ram_read_sel=llr_ram_read_counter<BOTTOM_LAYER_LLR_MAX_ID?0:1;
assign sigle_op_fin=(llr_ram_read_counter==CODE_LENGTH-1)&frozen_bit_indication_data?1:0;


reg [LLR_RAM_ADDR_WIDTH-1:0] llr_ram_read_counter=0;
reg [COUNTER_WIDTH-1:0] op_id_counter=0;
reg [COUNTER_WIDTH-1:0]layer_index=0;

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
								next_state<=CAL_STATE;	
                            end
                CAL_STATE:
                            begin
								if(sigle_op_fin==1'b1)
								begin
									next_state<=UPDATE_ID_STATE;
								end
								else
								begin
									next_state<=CAL_STATE;
								end
                            end
                UPDATE_ID_STATE:
                            begin
								next_state<=CAL_STATE;
                            end
				default:
							begin
								next_state<=IDLE_STATE;
							end
			endcase 
     end
end
//end of FSM for LLR CAL Controll

 
always_ff@(clk or reset)
begin
    if(reset)
    begin
        llr_ram_read_counter<=0;
    end
	else
	begin
            case(current_state)
                IDLE_STATE:
                            begin
								llr_ram_read_counter<=0;
                            end
                CAL_STATE:
                            begin
								llr_ram_read_counter<=llr_ram_read_counter+1'b1;
                            end
                UPDATE_ID_STATE:
                            begin
								llr_ram_read_counter<=0;
                            end
				default:
							begin
								llr_ram_read_counter<=0;	
							end
            endcase 
	end
end


always_ff@(clk or reset)
begin
    if(reset)
    begin
        op_id_counter<=0;
    end
	else
	begin
			case(current_state)
                IDLE_STATE:
                            begin
								op_id_counter<=0;
                            end
                CAL_STATE:
                            begin
								op_id_counter<=op_id_counter;
                            end
                UPDATE_ID_STATE:
                            begin
								op_id_counter<=op_id_counter+1'b1;
                            end
				default:
							begin
								op_id_counter<=0;	
							end	
			endcase
	end
end




endmodule
