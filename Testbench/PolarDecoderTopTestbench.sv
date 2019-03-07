`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 19:45:52
// Design Name: 
// Module Name: PolarDecoderTopTestbench
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

`define  CLK_PERIOD 10//100M
module PolarDecoderTopTestbench;


    
    reg clk;
    reg reset;
          
    always
    begin
    #(`CLK_PERIOD/2) clk=1;
    #(`CLK_PERIOD/2) clk=0;
    end
    
    

    initial 
    begin
    #0 reset=1;
    #(`CLK_PERIOD/2)  reset=1;
    #(`CLK_PERIOD/2)  reset=1;
    #(`CLK_PERIOD/2)  reset=1;
    #(`CLK_PERIOD/2)  reset=1;
    #(`CLK_PERIOD/2)  reset=0;
    #(`CLK_PERIOD/2)  reset=0;
    end
    
wire s_axi_tready;
reg  s_axi_tvalid;
reg  signed [7:0]s_axi_tdata;
reg  s_axi_tlast;

reg   m_axi_tready;
wire  m_axi_tvalid;
wire  m_axi_tdata;
wire  m_axi_tlast;
assign m_axi_tready=1'b1;
reg  [31:0]top_count;


always_ff@(posedge clk or posedge reset)
begin
    if(reset)
    begin
    top_count<=0;
    end
    else
    begin
    top_count=top_count+1'b1;
    end
end  


integer  file_out0;
    initial 
    begin                                              
        file_out0 = $fopen("M:\\CodesAndHardware\\Github\\PolarCode\\Data\\Data_out.txt","w");
        if(!file_out0)
        begin
            $display("could not open file result_data0!");
            $finish;
        end
    end
    

                 
always @(posedge clk)
    begin   
            if(m_axi_tvalid&m_axi_tready)
            $fdisplay(file_out0,"%d",m_axi_tdata);       
    end 


integer fp_r1;
integer scanf_count;  
always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            s_axi_tvalid<=1'b0;
            s_axi_tdata<=0;
            s_axi_tlast<=1'b1;
            scanf_count<=0;
            if(fp_r1) 
            $fclose(fp_r1);
            fp_r1= $fopen("M:\\CodesAndHardware\\Github\\PolarCode\\Data\\PolarDecoderTBDataIn.txt","r");
            if (!fp_r1)
            begin 
            $display("source_data open error");
            $finish;
            end
        end
        else if(scanf_count<1023&&s_axi_tready==1'b1)
        begin
            $fscanf(fp_r1, "%d",s_axi_tdata);
            s_axi_tvalid<=1'b1;
            scanf_count<=scanf_count+1'b1;
            s_axi_tlast=1'b0;
        end
        else if(scanf_count==1023&&s_axi_tready==1'b1)
        begin
            $fscanf(fp_r1, "%d",s_axi_tdata);
            s_axi_tvalid<=1'b1;
            scanf_count<=scanf_count+1'b1;
            s_axi_tlast=1'b1;
        end
        else 
        begin
            s_axi_tdata<=0;
            s_axi_tvalid<=1'b0;
            scanf_count<=scanf_count;
            s_axi_tlast=1'b0;
        end
    end
            

wire  error;
PolarDecoder PolarDecoderInst(
          .reset(reset),
          .clk(clk),
          .s_axi_tdata(s_axi_tdata),
          .s_axi_tvalid(s_axi_tvalid),
          .s_axi_tlast(s_axi_tlast),
          .s_axi_tready(s_axi_tready),
          .error(error),
          .m_axi_tdata(m_axi_tdata),
          .m_axi_tvalid(m_axi_tvalid),
          .m_axi_tready(m_axi_tready),
          .m_axi_tlast(m_axi_tlast)
    );

endmodule
