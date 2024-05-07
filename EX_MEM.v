`timescale 1ns / 1ps

module EX_MEM(
    input clk, rst,
    input [31:0] pc_EX, alu_EX, rs2_EX,
    input regwen_EX, MemRW_EX,
    input [1:0] WBsel_EX,
    output reg [1:0] WBsel_MEM,
    output reg regwen_MEM, MemRW_MEM,
    output reg [31:0] pc_MEM, alu_MEM, rs2_MEM,
    input [4:0] dest_EX,
    output reg [4:0] dest_MEM
    );
    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            pc_MEM <= 0;
            alu_MEM <= 0; 
            rs2_MEM <= 0; 
            WBsel_MEM <= 0;
            regwen_MEM <= 0;
            MemRW_MEM <= 0;
            dest_MEM <= 0;
        end
        else begin
            pc_MEM <= pc_EX;
            alu_MEM <= alu_EX; 
            rs2_MEM <= rs2_EX; 
            WBsel_MEM <= WBsel_EX;
            regwen_MEM <= regwen_EX;
            MemRW_MEM <= MemRW_EX;
            dest_MEM <= dest_EX;
        end
    end
endmodule
