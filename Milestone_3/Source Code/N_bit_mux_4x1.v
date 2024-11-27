`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2024 02:54:19 PM
// Design Name: 
// Module Name: N_bit_mux_4x1
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


module N_bit_mux_4x1 #(parameter n = 32)(input [n-1:0] A ,input [n-1:0] B , input [n-1:0] C,input [n-1:0] D,input [1:0] sel,output [n-1:0] out);
    wire [n-1:0] mux1_out, mux2_out;
    genvar i;

    generate
        for (i = 0; i < n; i = i + 1) begin : gen_mux_layer1
            mux2x1 mux1 (.a(A[i]), .b(B[i]), .sel(sel[0]), .c(mux1_out[i]));
            mux2x1 mux2 (.a(C[i]), .b(D[i]), .sel(sel[0]), .c(mux2_out[i]));
        end
    endgenerate

    generate
        for (i = 0; i < n; i = i + 1) begin : gen_mux_layer2
            mux2x1 mux3 (.a(mux1_out[i]), .b(mux2_out[i]), .sel(sel[1]), .c(out[i]));
        end
    endgenerate
endmodule

