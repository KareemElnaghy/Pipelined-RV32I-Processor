`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2024 02:14:59 PM
// Design Name: 
// Module Name: pipelinedCPU
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
//adjusted clks 7:07


module pipelinedCPU(input clk, input rst,input [1:0] ledSel, input [3:0] ssdSel,input SSD_clock, output reg [15:0] leds, output reg [12:0] ssd);

wire branch; // Control signals
wire memRead;
wire memToReg;
wire [1:0] ALUop;
wire memWrite; 
wire ALUsrc; 
wire regWrite;
wire [31:0] write_data; // input to RF write
wire [31:0] read_data1; // inputs to RF read
wire [31:0] read_data2;
reg [31:0] PC_in; // input to PC
wire [31:0] PC_out;// output of PC
wire [31:0] pcAdder_out; // output of PC + 4
wire[31:0] imm_out; // output of immGen
wire[31:0] aluMux_out; // output of ALU mux 
wire[3:0] aluSel; // output of ALU CU
wire[31:0] aluResult; // output of ALU
wire [31:0] dataMem_out; // output of data memory
wire[31:0] shift_out; // output of shifter
wire[31:0] branchAdder_out; // output of branch adder
wire endProgram; // eBreak Signal
wire branchResult; // determines whether branch is taken or not 
wire [1:0] PC_Sel; // PC MUX selection line
wire  [1:0] writeData_Sel; // Selection line to write data mux
wire z_flag, v_flag, c_flag, s_flag;
wire [4:0] flush_EX_MEM;
wire [31:0] aluDataMux_out;

//IF_ID
wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_PCadd4; 

//ID_EX
wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
wire [7:0] ID_EX_Ctrl;
wire [3:0] ID_EX_Func; 
wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd; 
wire [1:0] ID_EX_PC_Sel;
wire [1:0] ID_EX_writeData_Sel; 
wire [31:0] ID_EX_PCadd4; 
wire [4:0] ID_EX_Opcode;

//EX_MEM
wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2;
wire [4:0] EX_MEM_Ctrl;
wire [4:0] EX_MEM_Rd;
wire EX_MEM_Zero, EX_MEM_V, EX_MEM_C, EX_MEM_S; 
wire [31:0] EX_MEM_Imm, EX_MEM_PCadd4;
wire [2:0] EX_MEM_funct3;
wire [4:0] EX_MEM_Opcode;
wire [1:0] EX_MEM_PC_Sel;
wire [1:0] EX_MEM_writeData_Sel;

//MEM_WB
wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_PCadd4, MEM_WB_BranchAddOut;
wire [1:0] MEM_WB_Ctrl;
wire [4:0] MEM_WB_Rd;
wire [1:0] MEM_WB_writeData_Sel;
wire [31:0] MEM_WB_Imm;

 //forwarding
wire [1:0] forwardA;
wire [1:0] forwardB; 
wire [31:0] fowardMuxB_out;
wire [31:0] fowardMuxA_out;

wire [7:0] cuMUX_out;//control hazard detection



//IF Stage

register #(32)PC (clk, branchResult | ~endProgram, rst, PC_in, PC_out);     // PC register

RCA #(32)rca(.A(PC_out),.B(32'd4), .sum(pcAdder_out));  // PC + 4

wire [31:0] flush_IF_ID;
assign flush_IF_ID = (branchResult | rst)? 32'd0 : dataMem_out;

register #(96) IF_ID (~clk,1'b1,rst,{pcAdder_out, PC_out,dataMem_out},{IF_ID_PCadd4, IF_ID_PC,IF_ID_Inst}); // IF_ID Register 
//WB = memtoreg + regwrite 
//Mem = memread + memwrite + branch 
//Ex = aluop+alusrc


//ID Stage

control_unit CU(IF_ID_Inst, branch, memRead, memToReg, ALUop, memWrite, ALUsrc, regWrite, PC_Sel, endProgram,writeData_Sel); // control unit 

registerFile #(32) RF(clk, rst, IF_ID_Inst[19:15], IF_ID_Inst[24:20], MEM_WB_Rd, MEM_WB_Ctrl[0], write_data, read_data1, read_data2);   // Register File

ImmGen immgen(IF_ID_Inst,imm_out); //Immediate Generator

N_bit_mux #(8) controlMUX ({memToReg,regWrite,memRead,memWrite,branch,ALUop,ALUsrc}, 8'b0, (branchResult), cuMUX_out); //control MUX, flushes control signals if Stall or pc_src is high

register #(196) ID_EX (clk,1'b1,rst, 
{IF_ID_Inst[6:2],PC_Sel,writeData_Sel,IF_ID_PCadd4,cuMUX_out,IF_ID_PC,read_data1,read_data2,imm_out,IF_ID_Inst[30],IF_ID_Inst[14:12],IF_ID_Inst[19:15],IF_ID_Inst[24:20],IF_ID_Inst[11:7]},
{ID_EX_Opcode,ID_EX_PC_Sel,ID_EX_writeData_Sel,ID_EX_PCadd4,ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2, ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd});// ID_EX Register
//ID_EX_Ctrl = {memToReg,regWrite,memRead,memWrite,branch,ALUop,ALUsrc}

//EX Stage
N_bit_mux_4x1 #(32) aluMUXA(ID_EX_RegR1, write_data,  32'b0, 32'b0, forwardA, fowardMuxA_out); //forwardB MUX

N_bit_mux_4x1 #(32) aluMUXB(ID_EX_RegR2, write_data,  32'b0, 32'b0, forwardB, fowardMuxB_out); //forwardB MUX

N_bit_mux #(32) aluMUX (fowardMuxB_out, (ID_EX_Imm), ID_EX_Ctrl[0], aluMux_out); //alu MUX

RCA #(32)rca1(.A(ID_EX_PC),.B(ID_EX_Imm), .sum(branchAdder_out));   // branch adder

ALU_control aluCU({1'b0,ID_EX_Func[3],15'b0,ID_EX_Func[2:0],12'b0}, ID_EX_Ctrl[2:1], aluSel);

N_bit_ALU #(32) alu(fowardMuxA_out, aluMux_out, aluSel, aluResult, z_flag, v_flag, c_flag, s_flag); // ALU


register #(186) EX_MEM (~clk,1'b1,rst, // EX_MEM Register
{ID_EX_writeData_Sel, ID_EX_PC_Sel, ID_EX_Opcode,ID_EX_Func[2:0], v_flag, c_flag, s_flag,ID_EX_Imm,ID_EX_PCadd4,flush_EX_MEM,branchAdder_out,z_flag,aluResult,fowardMuxB_out,ID_EX_Rd},
{EX_MEM_writeData_Sel, EX_MEM_PC_Sel, EX_MEM_Opcode, EX_MEM_funct3,EX_MEM_V, EX_MEM_C, EX_MEM_S, EX_MEM_Imm, EX_MEM_PCadd4, EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_Zero, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd}); //EX_MEM_Ctrl = memToReg,regWrite,memRead,memWrite,branch
//EX_MEM_Ctrl = {memToReg,regWrite,memRead,memWrite,branch}
assign flush_EX_MEM = branchResult? 5'b0 : ID_EX_Ctrl[7:3];


//MEM Stage
memory Mem(clk, EX_MEM_Ctrl[2], EX_MEM_Ctrl[1],EX_MEM_funct3, PC_out[6:0],EX_MEM_ALU_out[6:0], EX_MEM_RegR2, dataMem_out); //MEM_WB

branchOutcome branchoutcome(EX_MEM_Zero, EX_MEM_C, EX_MEM_V, EX_MEM_S, EX_MEM_Ctrl[0], EX_MEM_Opcode, EX_MEM_funct3, branchResult);   // Checks branch outcome using flags

always@(*) begin
    if((EX_MEM_PC_Sel == 2'b01) & branchResult)begin
        PC_in = EX_MEM_BranchAddOut;end
    else if(EX_MEM_PC_Sel == 2'b10)
        PC_in = EX_MEM_ALU_out;
    else
        PC_in = pcAdder_out;
end
    

register #(169) MEM_WB (clk,1'b1,rst, // MEM_WB Register
{EX_MEM_writeData_Sel, EX_MEM_Imm, EX_MEM_BranchAddOut, EX_MEM_PCadd4, EX_MEM_Ctrl[4:3],dataMem_out,EX_MEM_ALU_out,EX_MEM_Rd},
{MEM_WB_writeData_Sel, MEM_WB_Imm, MEM_WB_BranchAddOut, MEM_WB_PCadd4, MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd}); //MEM_WB_Ctrl = memToReg,regWrite

// WB Stage
N_bit_mux #(32) aluDataMUX(MEM_WB_ALU_out, MEM_WB_Mem_out,MEM_WB_Ctrl[1],aluDataMux_out);   //WB MUX
N_bit_mux_4x1 writeDataMUX(MEM_WB_PCadd4,MEM_WB_BranchAddOut,aluDataMux_out, MEM_WB_Imm, MEM_WB_writeData_Sel,write_data); // Write Data Mux


//Other Units

forwardingUnit FU (ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_Ctrl[3], MEM_WB_Ctrl[0], forwardA, forwardB); //Forwarding unit


// FPGA Implementation
always @(*) begin
    if (ledSel==2'b00)
        leds = dataMem_out[15:0];
    else if (ledSel==2'b01)
        leds = dataMem_out[31:16];
    else if (ledSel==2'b10)
        leds = {endProgram , 1'b0, branch, memRead, memToReg, ALUop, memWrite, ALUsrc, regWrite, aluSel, z_flag , (branchResult)};
        
    if (ssdSel == 4'b0000)
        ssd = PC_out[12:0];
    else if (ssdSel == 4'b0001)
        ssd = pcAdder_out[12:0];
    else if (ssdSel == 4'b0010)
        ssd = branchAdder_out[12:0];
    else if (ssdSel == 4'b0011)
        ssd = PC_in[12:0];
    else if (ssdSel == 4'b0100)
        ssd = read_data1[12:0];   
     else if (ssdSel == 4'b0101)
        ssd = read_data2[12:0];
    else if (ssdSel == 4'b0110)
        ssd = write_data[12:0];  
    else if (ssdSel == 4'b0111)
        ssd = imm_out[12:0];    
    else if (ssdSel == 4'b1000)
        ssd = shift_out[12:0];   
    else if (ssdSel == 4'b1001)
        ssd = aluMux_out[12:0]; 
    else if (ssdSel == 4'b1010)
        ssd = aluResult[12:0];   
    else if (ssdSel == 4'b1011)
        ssd = dataMem_out[12:0];                                
end

endmodule
