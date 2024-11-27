`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 04:27:58 PM
// Design Name: 
// Module Name: ALU_control
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

module ALU_control(input [31:0] instruction, input [1:0] ALU_op, output reg [3:0] ALU_sel);
wire [2:0] funct3;
wire funct1;
assign funct1 = instruction[30];
assign funct3 = instruction[14:12];

always @ (*) begin
case (ALU_op)
    2'b00: begin
        ALU_sel = `ALU_ADD;  // Load and Store
    end
    
    2'b01: begin        // Branch
        ALU_sel = `ALU_SUB;
    end
    
    2'b10: begin        // R - Type
    if({funct3,funct1} == 4'b0000) 
        ALU_sel = `ALU_ADD;  // ADD
    
    else if ({funct3,funct1} == 4'b0001)
        ALU_sel = `ALU_SUB;  // SUB
    
    else if({funct3,funct1} == 4'b1110) // AND
        ALU_sel = `ALU_AND;
    
    else if({funct3,funct1} == 4'b1100) // OR
        ALU_sel = `ALU_OR;
        
        
    else if({funct3,funct1} == 4'b1000) // XOR
        ALU_sel = `ALU_XOR;
        
   else if({funct3,funct1} == 4'b0010) // SLL
        ALU_sel = `ALU_SLL;
        
   else if({funct3,funct1} == 4'b1010) // SRL
        ALU_sel = `ALU_SRL; 
        
   else if({funct3,funct1} == 4'b1011) // SRA
        ALU_sel = `ALU_SRA;   
    
    else if({funct3,funct1} == 4'b0100) // SLT
        ALU_sel = `ALU_SLT;
        
    else if({funct3,funct1} == 4'b0110) // SLTU
        ALU_sel = `ALU_SLTU;
  
    end
    
    2'b11: begin        // I - Type
    if({funct3} == 4'b0) 
        ALU_sel = `ALU_ADD;  // ADD
    
    else if({funct3} == 4'b111) // AND
        ALU_sel = `ALU_AND;
    
    else if({funct3} == 4'b110) // OR
        ALU_sel = `ALU_OR;
        
        
    else if({funct3} == 4'b100) // XOR
        ALU_sel = `ALU_XOR;
        
   else if({funct3} == 4'b001) // SLL
        ALU_sel = `ALU_SLL;
        
   else if({funct3} == 4'b101) // SRL
        ALU_sel = `ALU_SRL; 
        
   else if({funct3} == 4'b101) // SRA
        ALU_sel = `ALU_SRA;   
    
    else if({funct3} == 4'b010) // SLT
        ALU_sel = `ALU_SLT;
        
    else if({funct3} == 4'b011) // SLTU
        ALU_sel = `ALU_SLTU;
  
    end
  default: ALU_sel = 4'bXXXX;
endcase
end

endmodule
