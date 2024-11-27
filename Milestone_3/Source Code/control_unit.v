`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 04:05:49 PM
// Design Name: 
// Module Name: control_unit
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
// 6:30 added default

module control_unit(input [31:0] instruction, output reg branch, reg memRead, reg memToReg, 
output reg [1:0] ALUop, output reg memWrite, reg ALUsrc, reg regWrite, reg [1:0] PC_Sel, reg endProgram, reg [1:0] writeData_Sel);
wire [4:0] opCode;
wire funct7;
assign opCode = instruction [6:2];
assign funct7 = instruction[30];

always @ (*) begin
case (opCode)
        `OPCODE_Arith_R: begin // R - Type
        branch = 1'b0;
        memRead = 1'b0;
        memToReg = 1'b0;
        ALUop = 2'b10;
        memWrite = 1'b0;
        ALUsrc = 1'b0;
        regWrite = 1'b1;
        PC_Sel = 2'b00;
        writeData_Sel = 2'b10;
        endProgram = 1'b0;
    end
    
        `OPCODE_Arith_I: begin // I - Type
        branch = 1'b0;
        memRead = 1'b0;
        memToReg = 1'b0;
        ALUop = 2'b11;
        memWrite = 1'b0;
        ALUsrc = 1'b1;
        regWrite = 1'b1;
        PC_Sel = 2'b00;
        writeData_Sel = 2'b10;
        endProgram = 1'b0;
    end
    
       `OPCODE_Load: begin // Load
        branch = 1'b0;
        memRead = 1'b1;
        memToReg = 1'b1;
        ALUop = 2'b00;
        memWrite = 1'b0;
        ALUsrc = 1'b1;
        regWrite = 1'b1;
        PC_Sel = 2'b00;
        writeData_Sel = 2'b10;
        endProgram = 1'b0;
    end
    
        `OPCODE_Store: begin // Store
        branch = 1'b0;
        memRead = 1'b0;
        memToReg = 1'b0;
        ALUop = 2'b00;
        memWrite = 1'b1;
        ALUsrc = 1'b1;
        regWrite = 1'b0;
        PC_Sel = 2'b00;
        writeData_Sel = 2'b00;
        endProgram = 1'b0;
    end
    
        `OPCODE_Branch: begin // Branch
        branch = 1'b1;
        memRead = 1'b0;
        memToReg = 1'b0;
        ALUop = 2'b01;
        memWrite = 1'b0;
        ALUsrc = 1'b0;
        regWrite = 1'b0;
        PC_Sel = 2'b01;
        writeData_Sel = 2'b00;
        endProgram = 1'b0;
    end
    
        `OPCODE_JALR: begin // JALR
        branch = 1'b1;
        memRead = 1'b0;
        memToReg = 1'b0;
        ALUop = 2'b00;
        memWrite = 1'b0;
        ALUsrc = 1'b1;
        regWrite = 1'b1;
        PC_Sel = 2'b10;
        writeData_Sel = 2'b00;
        endProgram = 1'b0;
    end
    
    `OPCODE_JAL: begin // JAL
        branch = 1'b1;
        memRead = 1'b0;
        memToReg = 1'b0;
        ALUop = 2'b01;
        memWrite = 1'b0;
        ALUsrc = 1'b0;
        regWrite = 1'b1;
        PC_Sel = 2'b01;
        writeData_Sel = 2'b00;
        endProgram = 1'b0;
    end
    
    `OPCODE_AUIPC: begin // AUIPC
        branch = 1'b0;
        memRead = 1'b0;
        memToReg = 1'b0;
        ALUop = 2'b00;
        memWrite = 1'b0;
        ALUsrc = 1'b0;
        regWrite = 1'b1;
        PC_Sel = 2'b00;
        writeData_Sel = 2'b01;
        endProgram = 1'b0;
     end
     
     `OPCODE_LUI: begin // LUI
        branch = 1'b0;
        memRead = 1'b0;
        memToReg = 1'b0;
        ALUop = 2'b00;
        memWrite = 1'b0;
        ALUsrc = 1'b0;
        regWrite = 1'b1;
        PC_Sel = 2'b00;
        writeData_Sel = 2'b11;
        endProgram = 1'b0;
     end
     
     `OPCODE_SYSTEM: begin
        if(funct7) begin    // EBREAK
            branch = 1'b0;
            memRead = 1'b0;
            memToReg = 1'b0;
            ALUop = 2'b00;
            memWrite = 1'b0;
            ALUsrc = 1'b0;
            regWrite = 1'b0;
            PC_Sel = 2'b00;
            writeData_Sel = 2'b00;
            endProgram = 1'b0;
        end
        else begin
            branch = 1'b0;
            memRead = 1'b0;
            memToReg = 1'b0;
            ALUop = 2'b00;
            memWrite = 1'b0;
            ALUsrc = 1'b0;
            regWrite = 1'b0;
            PC_Sel = 2'b00;
            writeData_Sel = 2'b00;
            endProgram = 1'b1;
        end
     end
     default: begin
        branch = 1'b0;
        memRead = 1'b0;
        memToReg = 1'b0;
        ALUop = 2'b00;
        memWrite = 1'b0;
        ALUsrc = 1'b0;
        regWrite = 1'b0;
        PC_Sel = 2'b00;
        writeData_Sel = 2'b00;
        endProgram = 1'b0;
            end
    endcase
end
endmodule
