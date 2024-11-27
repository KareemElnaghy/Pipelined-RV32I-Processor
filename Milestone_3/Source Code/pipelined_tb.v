`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 02:23:00 PM
// Design Name: 
// Module Name: singleCycleCPU_tb
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


module pipelined_tb();
reg clk;
reg rst;
reg [1:0] ledSel;
reg [3:0] ssdSel;
reg SSD_clock; 
wire [15:0] leds; 
wire [3:0] Anode;
wire [6:0] LED_out;

localparam period=10;
pipelinedCPU DUT(clk, rst);


initial begin
    SSD_clock = 1'b0;
    forever #(period/10) SSD_clock=~SSD_clock;
end 

initial begin
clk=0;
forever #(period/2) clk=~clk;
end

initial begin
rst=1;

#period
rst=0;
ledSel =2'b00;
ssdSel =4'b0000;
#(period*50)
$finish;


end

endmodule
