`timescale 1ns / 1ps
            
module MEM_WB(
    input clk, rst,
    input [31:0] alu_MEM, mem_MEM, pc_MEM,
    input regwen_MEM,
    input [1:0] WBsel_MEM,
    output reg regwen_WB,
    output reg [1:0] WBsel_WB,
    output reg [31:0] alu_WB, mem_WB, pc_WB,
    input [4:0] dest_MEM,
    output reg [4:0] dest_WB
    );
    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            alu_WB <= 0; 
            mem_WB <= 0;
            WBsel_WB <= 0;
            regwen_WB <= 0;
            dest_WB <= 0;
            pc_WB <= 0;
        end
        else begin
            alu_WB <= alu_MEM; 
            mem_WB <= mem_MEM;
            WBsel_WB <= WBsel_MEM;
            regwen_WB <= regwen_MEM;
            dest_WB <= dest_MEM;
            pc_WB <= pc_MEM;
        end
    end
endmodule
