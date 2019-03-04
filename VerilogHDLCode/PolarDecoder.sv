`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/18 18:55:22
// Design Name: PolarDecoder
// Module Name: PolarDecoder
// Project Name: CodelessPolarCode
// Target Devices:ZC706 
// Tool Versions:vivado 2016.4 
// Description: Polar Decoder
// 
// Dependencies: 
// 	LLRg.sv
//  LLRf.sv
//  LLR.sv
// Revision:
// Revision 0.01 - File Created
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////


module PolarDecoder#(
parameter CODE_LENGTH=1024,//the value must be the power of 2
parameter FROZEN_BITS_LENGTH=48,
parameter LLR_DATA_WIDTH=8,
parameter FROZEN_BIT_INDICATION_RAM_ADDR_WIDTH=10
)
(
    input wire reset,
    input wire clk,
    input wire [LLR_DATA_WIDTH-1:0] s_axi_tdata,
    input wire s_axi_tvalid,
    input wire s_axi_tlast,
    output reg s_axi_tready,
    output reg error,
    output reg m_axi_tdata,
    output reg m_axi_tvalid,
    input wire m_axi_tready,
    output reg m_axi_tlast
    );
localparam BIT_ID_COUNTER_WIDTH = $clog2(CODE_LENGTH);
localparam ADDR_WIDTH=BIT_ID_COUNTER_WIDTH;
localparam STATE_WIDTH=10;

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

wire [STATE_WIDTH-1:0] state;
wire llr_cal_fin;
wire llr_sigle_bit_cal_fin;
wire partial_sum_sigle_bit_cal_fin;
wire [BIT_ID_COUNTER_WIDTH-1:0] id_counter_value;

PolarDecoderControllerFSM#(
    .STATE_WIDTH(STATE_WIDTH)
) PolarDecoderControllerFSMInst
(
    .reset(reset),
    .clk(clk),
    .state_out(state),
    //state chanege source signals
    .saxi_tready(s_axi_tready),
    .saxi_tvalid(s_axi_tvalid),
    .saxi_tlast(s_axi_tlast),
    .maxi_tready(m_axi_tready),
    .maxi_tvalid(m_axi_tvalid),
    .maxi_tlast(m_axi_tlast),
    .llr_cal_fin(llr_cal_fin),
    .llr_sigle_bit_cal_fin(llr_sigle_bit_cal_fin),
    .partial_sum_sigle_bit_cal_fin(partial_sum_sigle_bit_cal_fin)
    );
wire start_or_stop;
assign start_or_stop=(state==UPDATE_ID_STATE);
BitIDCounter#(
.COUNTER_WIDTH(BIT_ID_COUNTER_WIDTH)
) BitIDCounterInst
(
    .reset(reset),
    .clk(clk),
    .load_value(0),
    .load(s_axi_tlast),
    .start_or_stop(start_or_stop),
    .id_count_value(id_counter_value)
    );




wire [ADDR_WIDTH-1:0]addr_from_ipc_to_llr_init_bram;
wire [LLR_DATA_WIDTH-1:0]data_from_ipc_to_llr_init_bram;
wire enable_from_ipc_to_llr_init_bram;
wire write_enable_to_llr_init_bram;


InputController#(
.ADDR_WIDTH(10),
.DATA_WIDTH(LLR_DATA_WIDTH),
.STATE_WIDTH(STATE_WIDTH), 
.INNER_COUNTER_WIDTH(10) 
)InputControllerInst(
    .clk(clk),
    .reset(reset),
    .state(state),
    .saxis_tvalid(s_axi_tvalid),
    .saxis_tlast(s_axi_tlast),
    .saxis_tdata(s_axi_tdata),
    .saxis_tready(s_axi_tready),
    .addr_to_llr_init_bram(addr_from_ipc_to_llr_init_bram),
    .data_to_llr_init_bram(data_from_ipc_to_llr_init_bram),
    .enable_to_llr_init_bram(enable_from_ipc_to_llr_init_bram),
    .write_enable_to_llr_init_bram(write_enable_to_llr_init_bram),
    .error(error)
    );
    
wire data_from_frozen_bit_indication_bram;    
wire [LLR_DATA_WIDTH-1:0]data_a_from_llr_init_bram;
wire [LLR_DATA_WIDTH-1:0]data_b_from_llr_init_bram;
wire [LLR_DATA_WIDTH-1:0]data_a_from_llr_mid_bram;
wire [LLR_DATA_WIDTH-1:0]data_b_from_llr_mid_bram;
wire data_from_partial_sum_bram;

wire [ADDR_WIDTH-1:0]addr_b_to_llr_init_bram;
wire [ADDR_WIDTH-1:0]addr_a_from_llrc_to_llr_init_bram;
wire [ADDR_WIDTH-1:0]addr_a_to_llr_mid_bram;
wire [ADDR_WIDTH-1:0]addr_b_to_llr_mid_bram;
wire [ADDR_WIDTH-1:0]addr_from_llrc_to_partial_sum_bram;
wire [LLR_DATA_WIDTH-1:0]data_to_llr_mid_bram;
wire data_to_out_buffer_bram;
wire enable_from_llrc_to_llr_init_bram;
wire enable_to_llr_mid_bram;
wire enable_from_llrc_to_partial_sum_bram;
wire write_enable_to_llr_mid_bram;
wire write_enable_to_output_buffer_bram;
wire data_new_bit;
   
LLRCalculator#
        (
            .STATE_WIDTH(STATE_WIDTH),
            .DATA_WIDTH(LLR_DATA_WIDTH),
            .ADDR_WIDTH(ADDR_WIDTH),
            .INNER_COUNTER_WIDTH(10),
            .COUNTER_MAX_VALUE(10'd1022),
            .ID_COUNTER_WIDTH(10)
        )LLRCalculatorInst
        (
            .clk(clk),
            .reset(reset),
            //state from fsm
            .state(state),
            //signals to fsm
            .llr_cal_fin(llr_cal_fin),
            .llr_sigle_bit_fin(llr_sigle_bit_cal_fin),
            //signals to or from ram
            .data_from_frozen_bit_indication_bram(data_from_frozen_bit_indication_bram),
            .data_a_from_llr_init_bram(data_a_from_llr_init_bram),
            .data_b_from_llr_init_bram(data_b_from_llr_init_bram),
            .data_a_from_llr_mid_bram(data_a_from_llr_mid_bram),
            .data_b_from_llr_mid_bram(data_b_from_llr_mid_bram),
            .data_from_partial_sum_bram(data_from_partial_sum_bram),
            .addr_a_to_llr_init_bram(addr_a_from_llrc_to_llr_init_bram),
            .addr_b_to_llr_init_bram(addr_b_to_llr_init_bram),
            .addr_a_to_llr_mid_bram(addr_a_to_llr_mid_bram),
            .addr_b_to_llr_mid_bram(addr_b_to_llr_mid_bram),
            .addr_to_partial_sum_bram(addr_from_llrc_to_partial_sum_bram),
            .data_to_llr_mid_bram(data_to_llr_mid_bram),
            .data_to_out_buffer_bram(data_to_out_buffer_bram),
            .enable_to_llr_init_bram(enable_from_llrc_to_llr_init_bram),
            .enable_to_llr_mid_bram(enable_to_llr_mid_bram),
            .enable_to_partial_sum_bram(enable_from_llrc_to_partial_sum_bram),
            .write_enable_to_llr_mid_bram(write_enable_to_llr_mid_bram),
            .write_enable_to_output_buffer_bram(write_enable_to_output_buffer_bram),
            //ID counter value
            .id_counter_value(id_counter_value),
            .new_bit_data(new_bit_data)
            );    

wire data_a_from_partial_bram;                                    
wire data_b_from_partial_bram;                                    
wire [ADDR_WIDTH-1:0]addr_a_from_psc_to_partial_sum_bram;                                  
wire [ADDR_WIDTH-1:0]addr_b_to_partial_sum_bram;                                  
wire data_a_to_partial_sum_bram;                                  
wire data_b_to_partial_sum_bram;                                  
wire enable_from_psc_to_partial_sum_bram;                                  
wire write_enable_a_to_partial_sum_bram;                          
wire write_enable_b_to_partial_sum_bram;                          

    
PartialSumCalculator#(
.STATE_WIDTH(STATE_WIDTH),
.ADDR_WIDTH(10),
.ID_COUNTER_WIDTH(BIT_ID_COUNTER_WIDTH),
.INNER_COUNTER_WIDTH(10),
.INNER_COUNTER_MAX_VALUE(10'd1022)
)PartialSumCalculatorInst
(
    .clk(clk),
    .reset(reset),
    .state(state),
    .new_bit_data(new_bit_data),
    .id_counter_value(id_counter_value),
    .data_a_from_partial_bram(data_a_from_partial_bram),
    .data_b_from_partial_bram(data_b_from_partial_bram),
    .addr_a_to_partial_sum_bram(addr_a_from_psc_to_partial_sum_bram),
    .addr_b_to_partial_sum_bram(addr_b_to_partial_sum_bram),
    .data_a_to_partial_sum_bram(data_a_to_partial_sum_bram),
    .data_b_to_partial_sum_bram(data_b_to_partial_sum_bram),
    .enable_to_partial_sum_bram(enable_from_psc_to_partial_sum_bram),
    .write_enable_a_to_partial_sum_bram(write_enable_a_to_partial_sum_bram),
    .write_enable_b_to_partial_sum_bram(write_enable_b_to_partial_sum_bram),
    .partial_sum_sigle_bit_cal_fin(partial_sum_sigle_bit_cal_fin)
    );
    

wire data_from_output_buffer_bram;
wire [ADDR_WIDTH-1:0]addr_to_output_buffer_bram;
wire read_enable_to_output_buffer_bram;
    
OutputController#(
.CODE_LENGTH(CODE_LENGTH),
.ADDR_WIDTH(ADDR_WIDTH),
.STATE_WIDTH(STATE_WIDTH), 
.INNER_COUNTER_WIDTH(10) 
)OutputControllerInst(
    .clk(clk),
    .reset(reset),
    .state(state),
    .data_from_output_buffer_bram(data_from_output_buffer_bram),
    .maxis_tready(m_axi_tready),
    .maxis_tdata(m_axi_tdata),
    .maxis_tlast(m_axi_tlast),
    .maxis_tvalid(m_axi_tvalid),
    .addr_to_output_buffer_bram(addr_to_output_buffer_bram),
    .read_enable_to_output_buffer_bram(read_enable_to_output_buffer_bram)
    );
    
//brams 


FrozenBitIndicationBRAM#(
           .ADDR_WIDTH(14),
           .READ_REG_ENABLE(0)
           )FrozenBitIndicationBRAMInst
           (
               .DO(data_from_frozen_bit_indication_bram),       // Output read data port, width defined by DATA_WIDTH parameter
               .DI(0),        // Input write data port, width defined by DATA_WIDTH parameter
               .RDADDR({4'd0,id_counter_value}), // Input  address, width defined by read port depth
               .WRADDR(0), // Input  address, width defined by write port depth
               .RESET(reset),       // 1-bit input reset      
               .CLK(clk),   // 1-bit input read  and wrire clock
               .READ_ENABLE(1),     // 1-bit input read port enable
               .WRITE_ENABLE(0)      // 1-bit input write port enable
               );

wire [ADDR_WIDTH-1:0]addr_to_llr_init_bram_combine;
wire enable_to_llr_init_bram_combine;

assign addr_to_llr_init_bram_combine=(state==INPUT_STATE)?addr_from_ipc_to_llr_init_bram:addr_a_from_llrc_to_llr_init_bram;
assign enable_to_llr_init_bram_combine=enable_from_llrc_to_llr_init_bram|enable_from_ipc_to_llr_init_bram;

 LLRInitBRAM#(
    .DATA_WIDTH(LLR_DATA_WIDTH),
    .ADDR_WIDTH(11),
    .READ_REG_ENABLE(0)
) LLRInitBRAMInst
(
        .DOA(data_a_from_llr_init_bram),       // Output read data port, width defined by DATA_WIDTH parameter
        .DOB(data_b_from_llr_init_bram),       // Output read data port, width defined by DATA_WIDTH parameter
        .DI(data_from_ipc_to_llr_init_bram),        // Input write data port, width defined by DATA_WIDTH parameter
        .ADDRA({1'b0,addr_to_llr_init_bram_combine}), // Input read address, width defined by read port depth
        .ADDRB({1'b0,addr_b_to_llr_init_bram}), // Input write address, width defined by write port depth
        .RESET(reset),       // 1-bit input reset      
        .CLK(clk),   // 1-bit input read clock
        .ENABLE(enable_to_llr_init_bram_combine),     // 1-bit input read port enable
        .WRITE_ENABLE(write_enable_to_llr_init_bram)      // 1-bit input write port enable
    );
    
 LLRMidBRAM#(
       .DATA_WIDTH(LLR_DATA_WIDTH),
       .ADDR_WIDTH(11),
       .READ_REG_ENABLE(0)
   ) LLRMidBRAMInst
   (
           .DOA(data_a_from_llr_mid_bram),       // Output read data port, width defined by DATA_WIDTH parameter
           .DOB(data_b_from_llr_mid_bram),       // Output read data port, width defined by DATA_WIDTH parameter
           .DI(data_to_llr_mid_bram),        // Input write data port, width defined by DATA_WIDTH parameter
           .ADDRA({1'b0,addr_a_to_llr_mid_bram}), // Input read address, width defined by read port depth
           .ADDRB({1'b0,addr_b_to_llr_mid_bram}), // Input write address, width defined by write port depth
           .RESET(reset),       // 1-bit input reset      
           .CLK(clk),   // 1-bit input read clock
           .ENABLE(enable_to_llr_mid_bram),     // 1-bit input read port enable
           .WRITE_ENABLE(write_enable_to_llr_mid_bram)      // 1-bit input write port enable
       );

wire [ADDR_WIDTH-1:0]addr_a_to_partial_sum_bram_combine=(state==PARTIAL_SUM_NEW_BIT_STORE_STATE)||(state==PARTIAL_SUM_READ_STATE)||(state==PARTIAL_SUM_CAL_AND_STORE_STATE)?addr_a_from_psc_to_partial_sum_bram:addr_from_llrc_to_partial_sum_bram;
wire enable_to_partial_sum_bram_combine=enable_from_llrc_to_partial_sum_bram|enable_from_psc_to_partial_sum_bram;
assign data_from_partial_sum_bram=data_a_from_partial_bram;                                    
PartialSumBRAM#(
       .DATA_WIDTH(1),
       .ADDR_WIDTH(14),
       .READ_REG_ENABLE(0)
       )PartialSumBRAMInst
       (
               .DOA(data_a_from_partial_bram),       // Output read data port, width defined by DATA_WIDTH parameter
               .DOB(data_b_from_partial_bram),       // Output read data port, width defined by DATA_WIDTH parameter        input wire  [DATA_WIDTH-1:0] DIA,        // Input write data port, width defined by DATA_WIDTH parameter
               .DIA(data_a_to_partial_sum_bram),        // Input write data port, width defined by DATA_WIDTH parameter
               .DIB(data_b_to_partial_sum_bram),        // Input write data port, width defined by DATA_WIDTH parameter
               .ADDRA({4'b0,addr_a_to_partial_sum_bram_combine}), // Input  address, width defined by read port depth
               .ADDRB({4'b0,addr_b_to_partial_sum_bram}), // Input  address, width defined by write port depth
               .RESET(reset),       // 1-bit input reset      
               .CLK(clk),   // 1-bit input read clock
               .ENABLE(enable_to_partial_sum_bram_combine),      // 1-bit input read port enable
               .WRITE_ENABLE_A(write_enable_a_to_partial_sum_bram), // 1-bit input write port enable
               .WRITE_ENABLE_B(write_enable_b_to_partial_sum_bram) // 1-bit input write port enable
           );
           
 OutputBufferBRAM#(
           .ADDR_WIDTH(14),
           .READ_REG_ENABLE(0)
           )OutputBufferBRAMInst
           (
               .DO(data_from_output_buffer_bram),       // Output read data port, width defined by DATA_WIDTH parameter
               .DI(data_to_out_buffer_bram),        // Input write data port, width defined by DATA_WIDTH parameter
               .RDADDR({4'b0,addr_to_output_buffer_bram}), // Input  address, width defined by read port depth
               .WRADDR({4'b0,id_counter_value}), // Input  address, width defined by write port depth
               .RESET(reset),       // 1-bit input reset      
               .CLK(clk),   // 1-bit input read  and wrire clock
               .READ_ENABLE(read_enable_to_output_buffer_bram),     // 1-bit input read port enable
               .WRITE_ENABLE(write_enable_to_output_buffer_bram)      // 1-bit input write port enable
               );                   
endmodule
