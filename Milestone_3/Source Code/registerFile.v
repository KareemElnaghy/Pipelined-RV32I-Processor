`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 03:08:38 PM
// Design Name: 
// Module Name: registerFile
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


module registerFile #(parameter n = 32)(input clk, input rst,input [4:0] read_addr1, input [4:0] read_addr2, input [4:0] write_addr, input wr_en, input [n-1:0] w_data, output [n-1:0] read_data1, output [n-1:0]read_data2 );
reg [n-1:0] regFile [31:0];
assign read_data1 = regFile[read_addr1];
assign read_data2 = regFile[read_addr2];
integer i;


always @(negedge clk or posedge rst) begin
    if (rst) begin
        for (i=0;i<n;i=i+1)
            regFile[i] = 32'b0;
    end
    
    else if (wr_en & write_addr!=5'b0 ) begin
        regFile[write_addr] = w_data;
    end
end

endmodule
