#include <iostream>
#include <fstream>
#include <vector>
#include <cstdlib>
#include <iomanip>
#include <cstdint>
#include <map>

using namespace std;

map<string, uint32_t> opcodeMap = {
    {"LUI", 0b0110111},  {"AUIPC", 0b0010111}, {"JAL", 0b1101111},
    {"JALR", 0b1100111}, {"BEQ", 0b1100011},   {"BNE", 0b1100011},
    {"BLT", 0b1100011},  {"BGE", 0b1100011},   {"BLTU", 0b1100011},
    {"BGEU", 0b1100011}, {"LB", 0b0000011},    {"LH", 0b0000011},
    {"LW", 0b0000011},   {"LBU", 0b0000011},   {"LHU", 0b0000011},
    {"SB", 0b0100011},   {"SH", 0b0100011},    {"SW", 0b0100011},
    {"ADDI", 0b0010011}, {"SLTI", 0b0010011},  {"SLTIU", 0b0010011},
    {"XORI", 0b0010011}, {"ORI", 0b0010011},   {"ANDI", 0b0010011},
    {"SLLI", 0b0010011}, {"SRLI", 0b0010011},  {"SRAI", 0b0010011},
    {"ADD", 0b0110011},  {"SUB", 0b0110011},   {"SLL", 0b0110011},
    {"SLT", 0b0110011},  {"SLTU", 0b0110011},  {"XOR", 0b0110011},
    {"SRL", 0b0110011},  {"SRA", 0b0110011},   {"OR", 0b0110011},
    {"AND", 0b0110011},  {"ECALL", 0b1110011}, {"EBREAK", 0b1110011}};

map<string, uint32_t> funct3Map = {
    {"BEQ", 0b000},   {"BNE", 0b001},  {"BLT", 0b100},  {"BGE", 0b101},
    {"BLTU", 0b110},  {"BGEU", 0b111}, {"LB", 0b000},   {"LH", 0b001},
    {"LW", 0b010},    {"LBU", 0b100},  {"LHU", 0b101},  {"SB", 0b000},
    {"SH", 0b001},    {"SW", 0b010},   {"ADDI", 0b000}, {"SLTI", 0b010},
    {"SLTIU", 0b011}, {"XORI", 0b100}, {"ORI", 0b110},  {"ANDI", 0b111},
    {"SLLI", 0b001},  {"SRLI", 0b101}, {"SRAI", 0b101}, {"ADD", 0b000},
    {"SUB", 0b000},   {"SLL", 0b001},  {"SLT", 0b010},  {"SLTU", 0b011},
    {"XOR", 0b100},   {"SRL", 0b101},  {"SRA", 0b101},  {"OR", 0b110},
    {"AND", 0b111}, {"ECALL", 0b000},  {"EBREAK", 0b000}};

map<string, uint32_t> funct7Map = {{"SLL", 0b0000000},  {"SRL", 0b0000000},
    {"SRA", 0b0100000},  {"ADD", 0b0000000},
    {"SUB", 0b0100000},  {"SLLI", 0b0000000},
    {"SRLI", 0b0000000}, {"SRAI", 0b0100000}};

class Instruction{
    public:
    int address;
    string inst;
    uint8_t opcode;
    uint8_t funct3;
    uint8_t funct7;
    Instruction (string inst, int addr){
        opcode = opcodeMap[inst];
        funct3 = funct3Map[inst];
        funct7 = funct7Map[inst];
        address = addr;
    }
};

    // R-type instructions
    string R_type[10] = {"ADD", "SUB", "SLL", "SLT", "SLTU", "XOR", "SRL", "SRA", "OR", "AND"};
    // I-type instructions
    string I_type[19] ={"ADDI", "SLTI", "SLTIU", "XORI", "ORI", "ANDI", "SLLI", "SRLI", "SRAI", "LB", "LH", "LW", "LBU", "LHU", "JALR", "ECALL", "EBREAK", "FENCE", "FENCE.TSO"};
    // U-type instructions
    string U_type [2] = {"LUI", "AUIPC"};
    // J-type instructions
    string J_type[1] = {"JAL"};
    // S-type instructions
    string S_type [3] = {"SB", "SH", "SW"};
    // B-type instructions
    string B_type[6] = {"BEQ", "BNE", "BLT", "BGE", "BLTU", "BGEU"};


uint32_t generateRType(uint8_t rd, uint8_t rs1, uint8_t rs2, Instruction inst) {
    // Apply masks to ensure each field is the correct bit width
    rd &= 0b11111;       // Limit rd to 5 bits
    rs1 &= 0b11111;      // Limit rs1 to 5 bits
    rs2 &= 0b11111;      // Limit rs2 to 5 bits
    inst.opcode &= 0b1111111;   // Limit opcode to 7 bits
    inst.funct3 &= 0b111;   // Limit funct3 to 3 bits
    inst.funct7 &= 0b1111111;   // Limit funct7 to 7 bits

    // Construct the instruction with the masked values
    return (inst.funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (inst.funct3 << 12) | (rd << 7) | inst.opcode;
}

uint32_t generateIType(uint8_t rd, uint8_t rs1, uint16_t imm, Instruction inst) {
    // Apply masks to ensure each field is the correct bit width
    rd &= 0b11111;       // Limit rd to 5 bits
    rs1 &= 0b11111;      // Limit rs1 to 5 bits
    imm &= 0b111111111111; // Limit imm to 12 bits
    inst.opcode &= 0b1111111;   // Limit opcode to 7 bits
    inst.funct3 &= 0b111;   // Limit funct3 to 3 bits

    // Construct the instruction with the masked values
    return (imm << 20) | (rs1 << 15) | (inst.funct3 << 12) | (rd << 7) | inst.opcode;
}

uint32_t generateUType(uint8_t rd, int32_t imm, Instruction inst) {
    // Apply masks
    rd &= 0b11111;
    inst.opcode &= 0b1111111;
    imm &= 0b11111111111111111111; // Limit immediate to 20 bits

    return (imm << 12) | (rd << 7) | inst.opcode;
}

uint32_t generateJType(uint8_t rd, int32_t imm, Instruction inst) {
    // Apply masks to keep values within their expected bit widths
    rd &= 0b11111;           // rd is 5 bits
    inst.opcode &= 0b1111111;  // opcode is 7 bits
    imm &= 0b11111111111111111111;       // Immediate is 20 bits

    // Extract different parts of the immediate as per the J-type format
    uint8_t imm_20 = (imm >> 20) & 0x1;        // Bit 20
    uint16_t imm_10_1 = (imm >> 1) & 0x3FF;    // Bits 10-1
    uint8_t imm_11 = (imm >> 11) & 0x1;        // Bit 11
    uint8_t imm_19_12 = (imm >> 12) & 0xFF;    // Bits 19-12

    // Assemble the instruction by placing each part in the correct bit positions
    return (imm_20 << 31) | (imm_19_12 << 12) | (imm_11 << 20) | (imm_10_1 << 21) |
           (rd << 7) | inst.opcode;
}

uint32_t generateSType(uint8_t rs1, uint8_t rs2, int16_t imm, Instruction inst) {
    // Apply masks
    rs1 &= 0b11111;
    rs2 &= 0b11111;
    inst.funct3 &= 0b111;
    inst.opcode &= 0b1111111;
    
    // Split the immediate into two parts
    uint8_t imm_11_5 = (imm >> 5) & 0b1111111;  // Upper 7 bits
    uint8_t imm_4_0 = imm & 0b11111;          // Lower 5 bits

    return (imm_11_5 << 25) | (rs2 << 20) | (rs1 << 15) | (inst.funct3 << 12) | (imm_4_0 << 7) | inst.opcode;
}

uint32_t generateBType(uint8_t rs1, uint8_t rs2, int16_t imm, Instruction inst) {
    // Apply masks
    rs1 &= 0b11111;
    rs2 &= 0b11111;
    inst.funct3 &= 0b111;
    inst.opcode &= 0b1111111;

    // Split the immediate into parts for B-type format
    uint8_t imm_12 = (imm >> 12) & 0b1;       // Bit 12
    uint8_t imm_10_5 = (imm >> 5) & 0b111111;     // Bits 10–5
    uint8_t imm_4_1 = (imm >> 1) & 0b1111;       // Bits 4–1
    uint8_t imm_11 = (imm >> 11) & 0b1;       // Bit 11

    return (imm_12 << 31) | (imm_11 << 7) | (imm_10_5 << 25) | (rs2 << 20) | 
        (rs1 << 15) | (inst.funct3 << 12) | (imm_4_1 << 8) | inst.opcode;
}



void generateRandomProgram(int numInstructions, const string &filename) {
    vector<uint32_t> program;
    srand(time(0));  // Seed random number generator

    for (int i = 0; i < numInstructions; i++) {
        uint8_t rd = rand() % 32;
        uint8_t rs1 = rand() % 32;
        uint8_t rs2 = rand() % 32;

        int32_t u_imm = rand() % (1 << 20);  // 20-bit immediate for U type

        int16_t imm = (rand() % (1024 / 4) - 512 / 4) * 4;  // Immediate for I and S types, multiples of 4
        int16_t branch_offset = ((rand() % (1024 / 4)) - 512 / 4) * 4; // Branch offset in multiples of 4
        int32_t jump_offset = ((rand() % (1024 / 4)) - 512 / 4) * 4;   // Jump offset in multiples of 4
        branch_offset &= 0b111111111111;
        jump_offset &= 0b11111111111111111111;
        imm &= 0b111111111111;

        // Randomly choose an instruction type and select an instruction from the relevant range
        int instructionType = rand() % 6; // Choose among R, I, U, J, S, B types

        switch (instructionType) {
            case 0: { // R-Type
                string inst_str = R_type[rand() % 10];
                Instruction inst (inst_str, i*4);
                program.push_back(generateRType(rd, rs1, rs2, inst));
                break;
            }
            case 1: { // I-Type
                string inst_str = I_type[rand() % 19];
                if (inst_str == "EBREAK"){
                    rd = 0b00000000;
                    rs1 = 0b00000000;
                    imm = 0b000000000001;
                }
                Instruction inst (inst_str, i*4);
                program.push_back(generateIType(rd,rs1,imm,inst));
                break;
            }
            
            case 2: { // U-Type
                string inst_str = U_type[rand() % 2];
                Instruction inst (inst_str, i*4);
                program.push_back(generateUType(rd,u_imm,inst));
                break;
            }
            case 3: { // J-Type
                string inst_str = J_type[0];
                Instruction inst (inst_str, i*4);
                while (inst.address + (2 * jump_offset) > 2044 || inst.address + (2 * jump_offset) < 0){
                    jump_offset = ((rand() % (1024 / 4)) - 512 / 4) * 4;
                    jump_offset &= 0b111111111111;
                }
                program.push_back(generateJType(rd,jump_offset,inst));
                break;
            }
            case 4: { // S-Type
                string inst_str = S_type[rand() % 3];
                Instruction inst (inst_str, i*4);
                program.push_back(generateSType(rs1,rs2,imm,inst));
                break;
            }
            case 5: { // B-Type
                string inst_str = B_type[rand() % 6];
                Instruction inst (inst_str, i*4);
                while (inst.address + (2*branch_offset) > 2044 || inst.address + (2*branch_offset) < 0) {
                    branch_offset = ((rand() % (1024 / 4)) - 512 / 4) * 4;
                    branch_offset &= 0b111111111111;
                }
                program.push_back(generateBType(rs1,rs2,branch_offset,inst));
                break;
            }
        }
    }

    // Write the program to a binary file
    ofstream outFile(filename, ios::binary);
    if (!outFile) {
        cerr << "Error: Could not open file " << filename << " for writing." << endl;
        return;
    }

    for (uint32_t instr : program) {
        outFile << hex << setw(8) << setfill('0') << instr << endl;
    }

    outFile.close();
    cout << "program successfully written";
}


int main(){

    int numInstructions = 10;
    string filename = "random_program.hex";

    generateRandomProgram(numInstructions, filename);

    return 0;
}