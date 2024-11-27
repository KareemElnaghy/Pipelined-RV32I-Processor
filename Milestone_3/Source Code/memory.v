`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 02:27:16 PM
// Design Name: 
// Module Name: data_mem
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
// 5:20 memory adjusted



module memory
(input clk, input MemRead, input MemWrite, input [2:0] funct3,
input [6:0] instAddr,input [6:0] dataAddr, input [31:0] data_in, output reg [31:0] data_out);   // addr = {pc 7 bits, write addr 7 bits}
reg [7:0] mem [0:(4*1024-1)];  // byte addressable commented for demo of FPGA
//reg [7:0] mem [0:150];  // byte addressable 
reg [31:0] temp [0:50];
reg [31:0] temp2 [0:31];
integer i;

initial begin
// Simulation 
    $readmemh("C:/Users/kareemelnaghy/Desktop/TestCases/testCaseDemo.hex", temp);


        for(i=0     ; i<42; i=i+1)
        begin
            {mem[(i*4)+3], mem[(i*4)+2], mem[(i*4)+1], mem[i*4]} = temp[i];       
        end

$readmemh("C:/Users/kareemelnaghy/Desktop/TestCases/datamem.hex", temp2);
        
        for(i=0; i<3; i=i+1)
        begin
            {mem[(i*4)+3+2048], mem[(i*4)+2+2048], mem[(i*4)+1+2048], mem[i*4+2048]} = temp2[i];       
        end


// Test Case 1 FPGA (Normal)
    {mem[3], mem[2], mem[1], mem[0]} = 32'h00a00293;  
    
    {mem[7], mem[6], mem[5], mem[4]} = 32'h01400313;
    
    {mem[11], mem[10], mem[9], mem[8]} = 32'h006283b3;
    
    {mem[15], mem[14], mem[13], mem[12]} =32'h0013f413;
    
    {mem[19], mem[18], mem[17], mem[16]} = 32'h00041463;
    
    {mem[23], mem[22], mem[21], mem[20]} = 32'h0074a023;
    
    {mem[27], mem[26], mem[25], mem[24]} = 32'h00000073;
    

end

// Always Block for FPGA

//always@(*) begin
//    if(~clk)begin
//        case(funct3)
//            0: data_out = MemRead?{{24{mem[dataAddr+128][7]}}, mem[dataAddr+128]}:data_out; //lb
//            1: data_out = MemRead?{{16{mem[dataAddr+1+128][7]}},mem[dataAddr+1+128],mem[dataAddr+128]} : data_out;  //lh
//            2: data_out = MemRead?{mem[dataAddr+3+128],mem[dataAddr+2+128],mem[dataAddr+1+128],mem[dataAddr+128]} : data_out;  //lw
//            4: data_out = MemRead?{24'b0, mem[dataAddr+128]} : data_out; //lbu
//            5: data_out = MemRead?{16'b0, mem[dataAddr+1+128], mem[dataAddr+128]} : data_out; //lhu
//            default: data_out = 0;
//        endcase
//    end
//    else begin
//        data_out = {mem[instAddr+3],mem[instAddr+2],mem[instAddr+1],mem[instAddr]};
//    end
    
//end

//always @(posedge clk)
//begin
//    if(MemWrite)
//        begin
//            case(funct3)
//                0: mem[dataAddr+128] = data_in[7:0]; //sb
//                1: begin //sh
//                    mem[dataAddr+128] = data_in[7:0];
//                    mem[dataAddr+1+128] = data_in[15:8];
//                end
//                2:begin //sw
//                    mem[dataAddr+128] = data_in[7:0];
//                    mem[dataAddr+1+128] = data_in[15:8];
//                    mem[dataAddr+2+128] = data_in[23:16];
//                    mem[dataAddr+3+128] = data_in[31:24];
//                end
//            endcase
//        end 
//    end
//endmodule 

// Always Block for Simulation
always@(*) begin
    if(~clk)begin
        case(funct3)
            0: data_out = MemRead?{{24{mem[dataAddr+2048][7]}}, mem[dataAddr+2048]}:data_out; //lb
            1: data_out = MemRead?{{16{mem[dataAddr+1+2048][7]}},mem[dataAddr+1+2048],mem[dataAddr+2048]} : data_out;  //lh
            2: data_out = MemRead?{mem[dataAddr+3+2048],mem[dataAddr+2+2048],mem[dataAddr+1+2048],mem[dataAddr+2048]} : data_out;  //lw
            4: data_out = MemRead?{24'b0, mem[dataAddr+2048]} : data_out; //lbu
            5: data_out = MemRead?{16'b0, mem[dataAddr+1+2048], mem[dataAddr+2048]} : data_out; //lhu
            default: data_out = 0;
        endcase
    end
    else begin
        data_out = {mem[instAddr+3],mem[instAddr+2],mem[instAddr+1],mem[instAddr]};
    end
    
end

always @(posedge clk)
begin
    if(MemWrite)
        begin
            case(funct3)
                0: mem[dataAddr+2048] = data_in[7:0]; //sb
                1: begin //sh
                    mem[dataAddr+2048] = data_in[7:0];
                    mem[dataAddr+1+2048] = data_in[15:8];
                end
                2:begin //sw
                    mem[dataAddr+2048] = data_in[7:0];
                    mem[dataAddr+1+2048] = data_in[15:8];
                    mem[dataAddr+2+2048] = data_in[23:16];
                    mem[dataAddr+3+2048] = data_in[31:24];
                end
            endcase
        end 
    end
endmodule 