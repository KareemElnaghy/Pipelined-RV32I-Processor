`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2024 01:17:33 AM
// Design Name: 
// Module Name: branch
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

module branchOutcome(input z_flag, c_flag, v_flag, s_flag, Branch, [6:2] opcode, [2:0] funct3, output reg branchResult);
always @ (*)
    begin
        case(opcode)
            `OPCODE_Branch:
                if(Branch) 
                    begin 
                        case(funct3)
                           `BR_BEQ: branchResult = z_flag;
                           `BR_BNE: branchResult = ~z_flag;
                           `BR_BLT: branchResult = (s_flag != v_flag);
                           `BR_BGE: branchResult = (s_flag == v_flag);
                           `BR_BLTU: branchResult = ~c_flag;
                           `BR_BGEU: branchResult = c_flag;
                            default: branchResult = 0;
                        endcase
                    end
             `OPCODE_JAL:
                branchResult = 1'b1;
                
             `OPCODE_JALR:
                branchResult = 1'b1;
              default:
                branchResult = 1'b0; 
               
        endcase
                
        
    end
endmodule
