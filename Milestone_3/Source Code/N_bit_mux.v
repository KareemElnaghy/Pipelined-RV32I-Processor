`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2024 03:08:29 PM
// Design Name: 
// Module Name: N_bit_mux
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


module N_bit_mux #(parameter n = 1)(input [n-1:0] a, input [n-1:0] b, input sel, output [n-1:0] c);
genvar i;
    generate
        for (i=0;i<n;i=i+1) begin
            mux2x1 mux(.a(a[i]),.b(b[i]),.sel(sel),.c(c[i]));
        end
    endgenerate
endmodule
