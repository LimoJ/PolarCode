`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/25 10:15:22
// Design Name: 
// Module Name: PolarDecoderControllerFSM
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


module PolarDecoderControllerFSM#
(
    parameter STATE_WIDTH=10
)
(
    input wire reset,
    input wire clk,
    output reg [STATE_WIDTH-1:0] state_out,
    //state chanege source signals
    input wire saxi_tready,
    input wire saxi_tvalid,
    input wire saxi_tlast,
    input wire maxi_tready,
    input wire maxi_tvalid,
    input wire maxi_tlast,    
    input wire llr_cal_fin,
    input wire llr_sigle_bit_cal_fin,
    input wire partial_sum_sigle_bit_cal_fin
    );
            
    // begin of FSM 
    localparam IDLE_STATE=10'd1;
    localparam INPUT_STATE=10'd2;
    localparam LLR_READ_STATE=10'd4;
    localparam LLR_CAL_AND_STORE_STATE=10'd8;
    localparam PARTIAL_SUM_NEW_BIT_STORE_STATE=10'd16;
    localparam PARTIAL_SUM_READ_STATE=10'd32;
    localparam PARTIAL_SUM_CAL_AND_STORE_STATE=10'd64;
    localparam UPDATE_ID_STATE=10'd128;
    localparam OUTPUT_WAIT_STATE=10'd256;
    localparam OUTPUT_STATE=10'd512;
    
    reg [STATE_WIDTH-1:0] current_state;
    reg [STATE_WIDTH-1:0] next_state;
    
    assign state_out=current_state;
    
    always_ff@(posedge clk or posedge reset)
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
    
    always_comb
    begin
        if(reset)
        begin
            next_state=INPUT_STATE; 
        end
        else
        begin
            case(current_state)
                    IDLE_STATE:
                                begin
                                    if(saxi_tready&saxi_tvalid)
                                    begin
                                        next_state=INPUT_STATE;    
                                    end
                                    else
                                    begin
                                         next_state=IDLE_STATE; 
                                    end 
                                end
                    INPUT_STATE:
                                begin
                                    if(saxi_tlast)
                                    begin
                                        next_state=LLR_READ_STATE;    
                                    end
                                    else
                                    begin
                                        next_state=INPUT_STATE; 
                                    end 
                                end
                    LLR_READ_STATE:
                                begin
                                    next_state=LLR_CAL_AND_STORE_STATE; 
                                end
                    LLR_CAL_AND_STORE_STATE:
                                begin
                                    if(llr_cal_fin)
                                    begin
                                        next_state=OUTPUT_WAIT_STATE; 
                                    end
                                    else if((~llr_cal_fin)&llr_sigle_bit_cal_fin)
                                    begin
                                        next_state=PARTIAL_SUM_NEW_BIT_STORE_STATE; 
                                    end
                                    else if((~llr_cal_fin)&(~llr_sigle_bit_cal_fin))
                                    begin
                                         next_state=LLR_READ_STATE; 
                                    end
                                    else
                                    begin
                                         next_state=LLR_CAL_AND_STORE_STATE; 
                                    end
                                end
                    PARTIAL_SUM_NEW_BIT_STORE_STATE:
                                begin
                                next_state=PARTIAL_SUM_READ_STATE;
                                end
                    PARTIAL_SUM_READ_STATE:
                                begin
                                 next_state=PARTIAL_SUM_CAL_AND_STORE_STATE;
                                end
                    PARTIAL_SUM_CAL_AND_STORE_STATE:
                                begin
                                    if(partial_sum_sigle_bit_cal_fin)
                                    begin
                                        next_state=UPDATE_ID_STATE;
                                    end
                                    else
                                    begin
                                        next_state=PARTIAL_SUM_READ_STATE;
                                    end
                                end
                    UPDATE_ID_STATE:
                                begin
                                    next_state=LLR_READ_STATE;
                                end
                    OUTPUT_WAIT_STATE:
                                begin
                                    if(maxi_tready)
                                    begin
                                        next_state=OUTPUT_STATE;
                                    end
                                    else
                                    begin
                                        next_state=OUTPUT_WAIT_STATE;
                                    end
                                end                    
                    OUTPUT_STATE:
                                begin
                                    if(maxi_tlast)
                                    begin
                                        next_state=IDLE_STATE;
                                    end
                                    else
                                    begin
                                        next_state=OUTPUT_STATE;
                                    end
                                end            
                    default:
                                begin
                                    next_state=0;
                                end
            endcase 
        end
    end
    
    //end of FSM 
    

endmodule
