`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/25 15:52:21
// Design Name: 
// Module Name: StartLayerCal
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


module StartLayerCal#(
    parameter ID_COUNTER_WIDTH=10,
    parameter LAYER_OUT_WIDTH=4,
    parameter ADDR_WIDTH=11
)(
    input wire [ID_COUNTER_WIDTH-1:0]id_counter_value,
    output reg [ID_COUNTER_WIDTH:0]start_layer_num,
    output reg [ADDR_WIDTH-1:0]start_layer_init_addr
    );
    
always_comb
begin
    if((id_counter_value&10'b00_0000_0001)==10'b00_0000_0001)
    begin
        start_layer_num=4'd0;
        start_layer_init_addr=11'b111_1111_1110;
    end
    else if((id_counter_value&10'b00_0000_0011)==&10'b00_0000_0010)
    begin
        start_layer_num=4'd1;
        start_layer_init_addr=11'b111_1111_1100;    
    end
    else if((id_counter_value&10'b00_0000_0111)==&10'b00_0000_0100)
    begin
        start_layer_num=4'd2;
        start_layer_init_addr=11'b111_1111_1000;      
    end
    else if((id_counter_value&10'b00_0000_1111)==&10'b00_0000_1000)
    begin
        start_layer_num=4'd3;
        start_layer_init_addr=11'b111_1111_0000;       
    end
    else if((id_counter_value&10'b00_0001_1111)==&10'b00_0001_0000)
    begin
        start_layer_num=4'd4;
        start_layer_init_addr=11'b111_1110_0000;   
    end
    else if((id_counter_value&10'b00_0011_1111)==&10'b00_0010_0000)
    begin
        start_layer_num=4'd5;
        start_layer_init_addr=11'b111_1100_0000;      
    end
    else if((id_counter_value&10'b00_0111_1111)==&10'b00_0100_0000)
    begin
        start_layer_num=4'd6;
        start_layer_init_addr=11'b111_1000_0000;      
    end
    else if((id_counter_value&10'b00_1111_1111)==&10'b00_1000_0000)
    begin
        start_layer_num=4'd7;
        start_layer_init_addr=11'b111_0000_0000;       
    end
    else if((id_counter_value&10'b01_1111_1111)==&10'b01_0000_0000)
    begin
        start_layer_num=4'd8;
        start_layer_init_addr=11'b110_0000_0000;  
    end
    else if((id_counter_value)==&10'b10_0000_0000)
    begin
        start_layer_num=4'd9;
        start_layer_init_addr=11'b100_0000_0000;  
    end
    else
    begin
        start_layer_num=4'd10;
        start_layer_init_addr=11'b000_0000_0000;      
    end            
end
    
    
endmodule
