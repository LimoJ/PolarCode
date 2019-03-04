`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/25 15:52:21
// Design Name: 
// Module Name: CurrentLayerCal
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


module CurrentLayerCal#(
    parameter COUNTER_WIDTH=10,
    parameter LAYER_OUT_WIDTH=4
)(
    input wire [COUNTER_WIDTH-1:0]counter_value,
    output reg [LAYER_OUT_WIDTH-1:0]current_layer_num
    );
    
always_comb
begin
    if((counter_value&10'b10_0000_0000)==10'b00_0000_0000)
    begin
        current_layer_num=4'd10;
    end
    else if((counter_value&10'b11_0000_0000)==&10'b10_0000_0000)
    begin
        current_layer_num=4'd9; 
    end
    else if((counter_value&10'b11_1000_0000)==&10'b11_0000_0000)
    begin
        current_layer_num=4'd8;  
    end
    else if((counter_value&10'b11_1100_0000)==&10'b11_1000_0000)
    begin
        current_layer_num=4'd7;     
    end
    else if((counter_value&10'b11_1110_0000)==&10'b11_1100_0000)
    begin
        current_layer_num=4'd6;
    end
    else if((counter_value&10'b11_1111_0000)==&10'b11_1110_0000)
    begin
        current_layer_num=4'd5;     
    end
    else if((counter_value&10'b11_1111_1000)==&10'b11_1111_0000)
    begin
        current_layer_num=4'd4;    
    end
    else if((counter_value&10'b11_1111_1100)==&10'b11_1111_1000)
    begin
        current_layer_num=4'd3;     
    end
    else if((counter_value&10'b11_1111_1110)==&10'b11_1111_1100)
    begin
        current_layer_num=4'd2;
    end
    else if((counter_value)==&10'b11_1111_1110)
    begin
        current_layer_num=4'd1; 
    end
    else
    begin
        current_layer_num=4'd0;     
    end            
end
    
    
endmodule
