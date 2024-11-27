`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 02:08:19 PM
// Design Name: 
// Module Name: N_bit_ALU
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
`include "defines.v"

module N_bit_ALU #(parameter n = 32)(input [n-1:0] A,input [n-1:0] B,input [3:0] sel, output reg [n-1:0] C, output reg zero_flag, output reg carry_flag, output reg overflow_flag, output reg sign_flag);
wire [n-1:0] outputRCA;
wire [n-1:0] B_temp;
wire [n-1:0] shift_out;
reg [1:0] shiftSel;
wire cout;
wire [4:0] shamt;
assign shamt = B[4:0];

always@(*) begin
    case(sel)
        `ALU_SRL: shiftSel = 2'b01;
    
        `ALU_SRA: shiftSel = 2'b10;
    
        `ALU_SLL: shiftSel = 2'b00;
    endcase
end

assign B_temp = (sel == `ALU_ADD)? B: (~B + 1);

RCA #n rca(.A(A),.B(B_temp),.sum(outputRCA), .cout(cout));

shift shifter(A, shamt, shiftSel, shift_out);

always @(*) begin
    case(sel) 
        `ALU_ADD: C = outputRCA;  
        
        `ALU_SUB: C = outputRCA;   
        
        `ALU_AND: C=A&B;
        
        `ALU_OR: C=A|B;
        
        `ALU_XOR: C=A^B;
        
        `ALU_SRL: C= shift_out;
        
        `ALU_SRA: C= shift_out;
        
        `ALU_SLL: C= shift_out;
        
        `ALU_SLT: C = (A<B)?1:0;
        
        `ALU_SLTU: C = ({1'b0,A}<{1'b0,B})?1:0;
       
         default: C=0;
    endcase
end

always @(*) begin
   zero_flag = (C==0);
   carry_flag = cout;
   overflow_flag = (A[31] & B_temp[31] & ~C[31]) | (~A[31] & ~B_temp[31] & C[31]);
   sign_flag = C[31]; 
    
end
endmodule
