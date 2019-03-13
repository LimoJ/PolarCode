`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/12 20:49:59
// Design Name: 
// Module Name: LTDecoderControllerFSM
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


module LTDecoderControllerFSM#(
parameter STATE_WIDTH=10
)(
    input wire reset,
    input wire clk,
    output wire state_out,
    input wire start,
    input wire xor_all_fin,
    input wire xor_sigle_time_fin,
    input wire maxi_tlast,
    input wire saxi_tready,
    input wire saxi_tvalid,
    input wire maxi_tready
    );
    
    // begin of FSM 
    localparam IDLE_STATE=10'd1;
    localparam DEGREE_ONE_DATA_READ_STATE=10'd4;
    localparam DEGREE_ONE_DATA_CAL_AND_STORE=10'd8;
    localparam XOR_CAL_PROCESS_DATA_READ=10'd16;
    localparam XOR_CAL_PROCESS_DATA_CAL_AND_STORE=10'd32;
    localparam OUTPUT_WAIT_STATE=10'd64;
    localparam OUTPUT_STATE=10'd128;
    
    
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
                next_state=IDLE_STATE; 
            end
            else
            begin
                case(current_state)
                        IDLE_STATE:
                                    begin
                                        if(start)
                                        begin
                                            next_state=DEGREE_ONE_DATA_READ_STATE;    
                                        end
                                        else
                                        begin
                                             next_state=IDLE_STATE; 
                                        end 
                                    end
                        DEGREE_ONE_DATA_READ_STATE:
                                    begin                                    
                                       next_state=DEGREE_ONE_DATA_CAL_AND_STORE; 
                                    end
                        DEGREE_ONE_DATA_CAL_AND_STORE:
                                    begin
                                        next_state=XOR_CAL_PROCESS_DATA_READ; 
                                    end
                        XOR_CAL_PROCESS_DATA_READ:
                                    begin
                                        next_state=XOR_CAL_PROCESS_DATA_CAL_AND_STORE;
                                    end            
                        XOR_CAL_PROCESS_DATA_CAL_AND_STORE:
                                    begin
                                        if(xor_all_fin)
                                        begin
                                            next_state=OUTPUT_WAIT_STATE; 
                                        end
                                        else if((~xor_all_fin)&xor_sigle_time_fin)
                                        begin
                                            next_state=IDLE_STATE; 
                                        end
                                        else if((~xor_all_fin)&(~xor_sigle_time_fin))
                                        begin
                                             next_state=XOR_CAL_PROCESS_DATA_READ; 
                                        end
                                        else
                                        begin
                                             next_state=XOR_CAL_PROCESS_DATA_CAL_AND_STORE; 
                                        end
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
        
endmodule
