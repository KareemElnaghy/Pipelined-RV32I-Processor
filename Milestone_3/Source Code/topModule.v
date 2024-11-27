`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 11:24:42 PM
// Design Name: 
// Module Name: topModule
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

//not working
module topModule(input clk, input rst, input [1:0] ledSel, input [3:0] ssdSel,input SSD_clk, output [3:0] Anode,output [6:0] LED_out, output [15:0] leds);
    wire [12:0] ssd;
    pipelinedCPU CPU(clk, rst, ledSel, ssdSel, SSD_clk, leds, ssd);
    Four_Digit_Seven_Segment_Driver_Opimized driver(SSD_clk, ssd, Anode, LED_out);
endmodule
