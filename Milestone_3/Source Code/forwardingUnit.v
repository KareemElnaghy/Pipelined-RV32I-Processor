`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2024 03:06:43 PM
// Design Name: 
// Module Name: forwardingUnit
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
// 6:25 changed FU

module forwardingUnit(input [4:0] ID_EX_RegisterRs1, [4:0] ID_EX_RegisterRs2, [4:0] EX_MEM_RegisterRd, [4:0] MEM_WB_RegisterRd, input EX_MEM_regWrite, MEM_WB_regWrite, output reg [1:0] forwardA, output reg [1:0] forwardB);

always @ (*) begin

//    if ((EX_MEM_regWrite && (EX_MEM_RegisterRd != 5'b0)) && (EX_MEM_RegisterRd == ID_EX_RegisterRs1))  
//        forwardA = 2'b10;
    
    if (((MEM_WB_regWrite && (MEM_WB_RegisterRd != 5'b0)) && (MEM_WB_RegisterRd == ID_EX_RegisterRs1)))   
        forwardA = 2'b01;
    else
        forwardA = 2'b00;
    
    
//    if ((EX_MEM_regWrite && (EX_MEM_RegisterRd != 5'b0)) && (EX_MEM_RegisterRd == ID_EX_RegisterRs2))  
//        forwardB = 2'b10;
    
    if (((MEM_WB_regWrite && (MEM_WB_RegisterRd != 5'b0)) && (MEM_WB_RegisterRd == ID_EX_RegisterRs2)))   
        forwardB = 2'b01;
    else
        forwardB = 2'b00;    
    end

endmodule
