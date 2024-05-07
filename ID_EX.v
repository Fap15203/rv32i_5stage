`timescale 1ns / 1ps

module ID_EX(
    input clk, rst, clear,
    input [31:0] pc_ID, rs1_ID, rs2_ID, imm_ID, instr_ID,
    input [4:0] src1_ID, src2_ID, dest_ID,
    input [1:0] WBsel_ID,     
    input [3:0] alu_control_ID,
    input MemRW_ID, regwen_ID, PCsel_ID,
    output reg MemRW_EX, regwen_EX, PCsel_EX,
    output reg [4:0] src1_EX, src2_EX, dest_EX,
    output reg [31:0] pc_EX, rs1_EX, rs2_EX, imm_EX, instr_EX,
    output reg [1:0] WBsel_EX,     
    output reg [3:0] alu_control_EX
    );
    always @ (posedge clk or negedge rst) begin
        if (!rst | clear) begin
            pc_EX <= 0;
            rs1_EX <= 0; 
            rs2_EX <= 0; 
            imm_EX <= 0; 
            instr_EX <= 0;
            src1_EX <= 0;
            src2_EX <= 0;
            dest_EX <= 0;
            WBsel_EX <= 0;     
            alu_control_EX <= 0;
            MemRW_EX <= 0;
            regwen_EX <= 0;
            PCsel_EX <= 0;
        end
        else begin
            pc_EX <= pc_ID;
            rs1_EX <= rs1_ID; 
            rs2_EX <= rs2_ID; 
            imm_EX <= imm_ID; 
            instr_EX <= instr_ID;
            src1_EX <= src1_ID;
            src2_EX <= src2_ID;
            dest_EX <= dest_ID;
            WBsel_EX <= WBsel_ID;     
            alu_control_EX <= alu_control_ID;
            MemRW_EX <= MemRW_ID;
            regwen_EX <= regwen_ID;
            PCsel_EX <= PCsel_ID;
        end
    end
endmodule
