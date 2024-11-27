`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2024 02:05:08 PM
// Design Name: 
// Module Name: shift
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


module shift(input [31:0] A, [4:0] shamt, [1:0] shiftSel, output reg [31:0] shiftResult);
integer i;
always @(*) begin
shiftResult = A;
    for(i=0; i<shamt; i=i+1)begin
        case(shiftSel)
        2'b00: shiftResult = {shiftResult[30:0],1'b0}; // SLL
        2'b01: shiftResult = {1'b0,shiftResult[31:1]}; // SRL
        2'b10: shiftResult = {A[31],shiftResult[31:1]}; // SRA
        endcase
    end
end
endmodule 
