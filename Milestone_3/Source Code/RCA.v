`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2024 02:20:46 PM
// Design Name: 
// Module Name: RCA
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


module RCA#(parameter n = 32)(input [n-1:0] A,input [n-1:0] B, output [n-1:0] sum, output cout);
genvar i;
wire [n-1:0] cout_W;
FA adder1(.A(A[0]), .B(B[0]), .cin(1'b0), .cout(cout_W[0]), .sum(sum[0]));
generate 
for(i=1; i<n; i=i+1)
begin
    FA adder(.A(A[i]), .B(B[i]), .cin(cout_W[i-1]), .cout(cout_W[i]), .sum(sum[i]));
end
endgenerate 

//    FA adder2(.A(A[n-1]), .B(B[n-1]), .cin(cout_W), .cout(cout), .sum(sum[n]));
assign cout=cout_W[n-1];
    
    

endmodule
