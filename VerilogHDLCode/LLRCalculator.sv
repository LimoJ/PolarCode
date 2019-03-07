`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/25 11:22:33
// Design Name: 
// Module Name: LLRCalculator
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


module LLRCalculator#
(
    parameter STATE_WIDTH=10,
    parameter INPUT_STATE=8'd2,
    parameter LLR_READ_STATE=8'd4,
    parameter LLR_CAL_AND_STORE_STATE=8'd8,
    parameter DATA_WIDTH=8,
    parameter ADDR_WIDTH=10,
    parameter INNER_COUNTER_WIDTH=10,
    parameter ID_COUNTER_MAX_VALUE=1023,
    parameter ID_COUNTER_WIDTH=10
)
(
    input wire clk,
    input wire reset,
    //state from fsm
    input wire [STATE_WIDTH-1:0]state,
    //signals to fsm
    output reg llr_cal_fin,
    output reg llr_sigle_bit_fin,
    //signals to or from ram
    input wire data_from_frozen_bit_indication_bram,
    input wire [DATA_WIDTH-1:0]data_a_from_llr_init_bram,
    input wire [DATA_WIDTH-1:0]data_b_from_llr_init_bram,
    input wire [DATA_WIDTH-1:0]data_a_from_llr_mid_bram,
    input wire [DATA_WIDTH-1:0]data_b_from_llr_mid_bram,
    input wire data_from_partial_sum_bram,
    output reg [ADDR_WIDTH-1:0]addr_a_to_llr_init_bram,
    output reg [ADDR_WIDTH-1:0]addr_b_to_llr_init_bram,
    output reg [ADDR_WIDTH-1:0]addr_a_to_llr_mid_bram,
    output reg [ADDR_WIDTH-1:0]addr_b_to_llr_mid_bram,
    output reg [ADDR_WIDTH-1:0]addr_to_partial_sum_bram,
    output reg signed [DATA_WIDTH-1:0]data_to_llr_mid_bram,
    output reg data_to_out_buffer_bram,
    output reg enablea_to_llr_init_bram,
    output reg enableb_to_llr_init_bram,
    output reg enablea_to_llr_mid_bram,
    output reg enableb_to_llr_mid_bram,
    output reg enable_to_partial_sum_bram,
    output reg write_enable_to_llr_mid_bram,
    output reg write_enable_to_output_buffer_bram,
    //ID counter value
    input  wire [ID_COUNTER_WIDTH-1:0] id_counter_value,
    //data new_bit
    output reg new_bit_data
    );


//StartLayerCal Inst
localparam LAYER_OUT_WIDTH = $clog2(ID_COUNTER_WIDTH);	
wire [ADDR_WIDTH:0] start_layer_init_addr;//width is ADDR_WIDTH +1
StartLayerCal#(
    .ID_COUNTER_WIDTH(10),
    .LAYER_OUT_WIDTH(LAYER_OUT_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH+1)
)StartLayerCalInst(
   .id_counter_value(id_counter_value),
   .start_layer_num(),
   .start_layer_init_addr(start_layer_init_addr)
    );

//inner counter 
localparam RAM_SELECT_THRESHOLD=10'd512;
reg [INNER_COUNTER_WIDTH-1:0] inner_counter;


always_ff@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        inner_counter<=0;
    end
    else
    begin
        if(state==LLR_CAL_AND_STORE_STATE)
        begin
            inner_counter<=inner_counter+1'b1;
        end
        else if(state==LLR_READ_STATE)
        begin
            inner_counter<=inner_counter; 
        end
        else
        begin
            inner_counter<=start_layer_init_addr[INNER_COUNTER_WIDTH-1:0];
        end
    end
end

//CurrentLayerCal Inst 
wire [LAYER_OUT_WIDTH-1:0] current_layer_num;     
 CurrentLayerCal#(
       .COUNTER_WIDTH(INNER_COUNTER_WIDTH),
       .LAYER_OUT_WIDTH(LAYER_OUT_WIDTH)
)CurrentLayerCalInst(
       .counter_value(inner_counter),
       .current_layer_num(current_layer_num)
       );
       
//ram select signal
reg sel_init_ram;
assign sel_init_ram=((state==LLR_READ_STATE)||(state==LLR_CAL_AND_STORE_STATE))&&inner_counter<RAM_SELECT_THRESHOLD?1:0;

//enable signals 
assign enablea_to_llr_init_bram=((state==LLR_READ_STATE))&&(sel_init_ram==1)?1:0;
assign enableb_to_llr_init_bram=((state==LLR_READ_STATE))&&(sel_init_ram==1)?1:0;

assign enablea_to_llr_mid_bram=((state==LLR_READ_STATE&&(sel_init_ram==0))||(state==LLR_CAL_AND_STORE_STATE))?1:0;
assign enableb_to_llr_mid_bram=((state==LLR_READ_STATE))&&(sel_init_ram==0)?1:0;

assign enable_to_partial_sum_bram=((state==LLR_READ_STATE)||(state==LLR_CAL_AND_STORE_STATE))?1:0;
//write enable signal 
assign write_enable_to_llr_mid_bram=(state==LLR_CAL_AND_STORE_STATE)?1:0;

//addrs
assign addr_a_to_llr_init_bram=enablea_to_llr_init_bram?{inner_counter[ADDR_WIDTH-2:0],1'b0}:0;
assign addr_b_to_llr_init_bram=enableb_to_llr_init_bram?{inner_counter[ADDR_WIDTH-2:0],1'b1}:0;
assign addr_b_to_llr_mid_bram=enableb_to_llr_mid_bram?{inner_counter[ADDR_WIDTH-2:0],1'b1}:0;
assign addr_to_partial_sum_bram=inner_counter;

always_comb
begin
    if(state==LLR_READ_STATE)
    begin
        addr_a_to_llr_mid_bram={inner_counter[ADDR_WIDTH-2:0],1'b0};
    end
    else if(state==LLR_CAL_AND_STORE_STATE)
    begin
        addr_a_to_llr_mid_bram=inner_counter;
    end
    else
    begin
        addr_a_to_llr_mid_bram=0;
    end
end

//f g sel signal , 0 is f ,1 is g
reg f_g_select;
assign f_g_select=id_counter_value[current_layer_num];

reg [DATA_WIDTH-1:0] data_b;
reg [DATA_WIDTH-1:0] data_a;
assign data_a=(sel_init_ram==1)?data_a_from_llr_init_bram:data_a_from_llr_mid_bram;
assign data_b=(sel_init_ram==1)?data_b_from_llr_init_bram:data_b_from_llr_mid_bram;
//LLR Inst
LLR#(
.DATA_WIDTH(DATA_WIDTH)
)LLRInst(
    .b(data_b),
    .a(data_a),
    .us(data_from_partial_sum_bram),//1b
	.sel(f_g_select),//1b
    .llr_data_out(data_to_llr_mid_bram)
    );
assign llr_sigle_bit_fin=(current_layer_num==0)&&(state==LLR_CAL_AND_STORE_STATE);


integer  file_out_llr;
    initial 
    begin                                              
        file_out_llr = $fopen("M:\\CodesAndHardware\\Github\\PolarCode\\Data\\LLR_out.txt","w");
        if(!file_out_llr)
        begin
            $display("could not open file result_data0!");
            $finish;
        end
    end
    

                 
always @(posedge clk)
    begin   
            if(llr_sigle_bit_fin)
            $fdisplay(file_out_llr,"%d",data_to_llr_mid_bram);       
    end 
    
assign llr_cal_fin=llr_sigle_bit_fin&&((id_counter_value)==ID_COUNTER_MAX_VALUE)&&(state==LLR_CAL_AND_STORE_STATE);
//decision and store to output buffer
assign write_enable_to_output_buffer_bram=(current_layer_num==0&&state==LLR_CAL_AND_STORE_STATE);
assign data_to_out_buffer_bram=write_enable_to_output_buffer_bram?(data_from_frozen_bit_indication_bram==1?0:data_to_llr_mid_bram[DATA_WIDTH-1]):0;

//data_new_bit
always_ff@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        new_bit_data<=0;
    end
    else if((current_layer_num==0)&&state==LLR_CAL_AND_STORE_STATE)
    begin
        new_bit_data<=data_to_out_buffer_bram;
    end
    else
    begin
        new_bit_data<=new_bit_data;
    end
end
        
endmodule
