`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2024 03:43:18 PM
// Design Name: 
// Module Name: ImmGen
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

module ImmGen(input [31:0] inst, output reg[31:0] gen_out);
wire [4:0] opcode;
assign opcode = inst[6:2];
always@(*) begin
case(opcode)
    `OPCODE_Branch: gen_out = {{21{inst[31]}},inst[7],inst[30:25], inst[11:8]}; // Branch
    `OPCODE_Load: gen_out = {{20{inst[31]}},inst[31:20]}; // Load
    `OPCODE_Store: gen_out = {{20{inst[31]}},inst[31:25],inst[11:7]};   // Store
    `OPCODE_Arith_I: gen_out = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] }; // I - Type
    `OPCODE_Arith_R: gen_out = { {21{inst[31]}}, inst[30:25], inst[11:8], inst[7] };    // R - Type
    `OPCODE_LUI: gen_out = {inst[31], inst[30:20], inst[19:12], 12'b0 };   // LUI
    `OPCODE_AUIPC: gen_out = { inst[31], inst[30:20], inst[19:12], 12'b0 };  // AUIPC
    `OPCODE_JAL: gen_out = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0 }; // JAL
    `OPCODE_JALR: gen_out = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] };    // JALR
    `OPCODE_Branch: gen_out = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}; // Branch
    default:   gen_out = {{21{inst[31]}}, inst[30:25], inst[24:21], inst[20] }; // IMM_I
endcase
//if(gen_out[11])
//begin
//    gen_out[31:12] = 20'b11111111111111111111;
//end
//else
//    gen_out[31:12] = 20'b0;
end

endmodule


