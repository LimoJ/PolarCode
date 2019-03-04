`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/25 20:08:24
// Design Name: 
// Module Name: PartialSumCalculator
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


module PartialSumCalculator#(
parameter PARTIAL_SUM_NEW_BIT_STORE_STATE=10'd16,
parameter PARTIAL_SUM_READ_STATE=10'd32,
parameter PARTIAL_SUM_CAL_AND_STORE_STATE=10'd64,
parameter STATE_WIDTH=10,
parameter ADDR_WIDTH=10,
parameter ID_COUNTER_WIDTH=10,
parameter INNER_COUNTER_WIDTH=10,
parameter INNER_COUNTER_MAX_VALUE=10'd1022
)
(
    input wire clk,
    input wire reset,
    input wire [STATE_WIDTH-1:0] state,
    input wire new_bit_data,
    input wire [ID_COUNTER_WIDTH-1:0]id_counter_value,
    input wire data_a_from_partial_bram,
    input wire data_b_from_partial_bram,
    output reg [ADDR_WIDTH-1:0]addr_a_to_partial_sum_bram,
    output reg [ADDR_WIDTH-1:0]addr_b_to_partial_sum_bram,
    output reg data_a_to_partial_sum_bram,
    output reg data_b_to_partial_sum_bram,
    output reg enable_to_partial_sum_bram,
    output reg write_enable_a_to_partial_sum_bram,
    output reg write_enable_b_to_partial_sum_bram,
    output reg partial_sum_sigle_bit_cal_fin
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
        if(state==PARTIAL_SUM_CAL_AND_STORE_STATE)
        begin
            inner_counter<=inner_counter-1'b1;
        end
        else if(state==PARTIAL_SUM_READ_STATE)
        begin
            inner_counter<=inner_counter; 
        end
        else
        begin
            inner_counter<=INNER_COUNTER_MAX_VALUE;
        end
    end
end

//addrs 
always_comb
begin
    if(state==PARTIAL_SUM_NEW_BIT_STORE_STATE)
    begin
        addr_a_to_partial_sum_bram=INNER_COUNTER_MAX_VALUE;
    end
    else if(state==PARTIAL_SUM_READ_STATE)
    begin
        addr_a_to_partial_sum_bram={inner_counter[ADDR_WIDTH-2:0],1'b0};
    end
    else if(state==PARTIAL_SUM_READ_STATE)
    begin
        addr_a_to_partial_sum_bram={inner_counter[ADDR_WIDTH-2:0],1'b0};
    end
    else
    begin
        addr_a_to_partial_sum_bram=INNER_COUNTER_MAX_VALUE;
    end
end

always_comb
begin
    if(state==PARTIAL_SUM_NEW_BIT_STORE_STATE)
    begin
        addr_b_to_partial_sum_bram=INNER_COUNTER_MAX_VALUE;
    end
    else if(state==PARTIAL_SUM_READ_STATE)
    begin
        addr_b_to_partial_sum_bram=inner_counter;
    end
    else if(state==PARTIAL_SUM_READ_STATE)
    begin
        addr_b_to_partial_sum_bram={inner_counter[ADDR_WIDTH-2:0],1'b1};
    end
    else
    begin
        addr_b_to_partial_sum_bram=INNER_COUNTER_MAX_VALUE;
    end
end



//CurrentLayerCal Inst 
localparam LAYER_OUT_WIDTH = $clog2(ID_COUNTER_WIDTH)+1;	
wire [LAYER_OUT_WIDTH-1:0] current_layer_num;     
 CurrentLayerCal#(
       .COUNTER_WIDTH(INNER_COUNTER_WIDTH),
       .LAYER_OUT_WIDTH(LAYER_OUT_WIDTH)
)CurrentLayerCalInst(
       .counter_value(inner_counter),
       .current_layer_num(current_layer_num)
       );
       
//partial sum
reg g_valid;
reg f_g_select;
reg f;
reg g; 
assign f_g_select=id_counter_value[current_layer_num];
PartialSum PartialSumInst(
    .pre_f(data_a_from_partial_bram),
    .a(data_b_from_partial_bram),
    .f(f),
    .g(g),
    .g_valid(g_valid),
    .f_g_select(f_g_select) //0 is f ,1s g
);
//data to ram
assign data_a_to_partial_sum_bram=(state==PARTIAL_SUM_NEW_BIT_STORE_STATE)?new_bit_data:f;
assign data_b_to_partial_sum_bram=g;
//enable and data enable
assign enable_to_partial_sum_bram=(state==PARTIAL_SUM_NEW_BIT_STORE_STATE||(state==PARTIAL_SUM_READ_STATE))||(state==PARTIAL_SUM_NEW_BIT_STORE_STATE);
assign write_enable_a_to_partial_sum_bram=(state==PARTIAL_SUM_NEW_BIT_STORE_STATE||(state==PARTIAL_SUM_NEW_BIT_STORE_STATE));
assign write_enable_b_to_partial_sum_bram=((state==PARTIAL_SUM_NEW_BIT_STORE_STATE))&&(f_g_select==1'b1);
//partial sum sigle bit cal fin
always_comb
begin
    if(current_layer_num==1)
    begin
        partial_sum_sigle_bit_cal_fin=0;
    end
    else
    begin
        partial_sum_sigle_bit_cal_fin=id_counter_value[current_layer_num-1]==1'b0;
    end
end
             
endmodule
