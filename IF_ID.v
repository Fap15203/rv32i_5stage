`timescale 1ns / 1ps

module IF_ID(
    input clk, rst, clear, stall,
    input [31:0] instr_IF, pc_IF, 
    output reg [31:0] instr_ID, pc_ID
    );
    always @ (posedge clk or negedge rst) begin
        if (!rst | clear | stall) begin
            instr_ID <= 0;
            pc_ID <= 0;
        end
        else begin
            instr_ID <= instr_IF;
            pc_ID <= pc_IF;
        end
    end
endmodule
