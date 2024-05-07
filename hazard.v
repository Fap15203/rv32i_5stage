`timescale 1ns / 1ps

module hazard(
    input [31:0] instr_EX,
    input [4:0] src1_EX, src2_EX, dest_MEM, dest_WB, src1_ID, src2_ID, dest_EX,
    input [1:0] WBsel_EX,
    input regwen_WB, regwen_MEM, PCsel_EX,
    output reg [1:0] Asel, Bsel, 
    output stall, flushE, flushD
    );
    //opcode
    parameter R_type        = 7'b0110011;
    parameter I_R_type      = 7'b0010011;
    parameter Load_type     = 7'b0000011;
    parameter Store_type    = 7'b0100011;
    parameter B_type        = 7'b1100011;
    parameter JAL_type      = 7'b1101111;
    parameter JALR_type     = 7'b1100111;
    parameter LUI           = 7'b0110111;
    parameter AUIPC         = 7'b0010111;
    
    wire [6:0] opcode;
    reg [1:0] Aop, Bop;
    assign opcode = instr_EX[6:0];
    
    always @ (instr_EX) begin
        case(opcode)
            R_type:     begin    
                Aop <= 2'b00;
                Bop <= 2'b00;
                end
            I_R_type:   begin
                Aop = 2'b00;
                Bop = 2'b01;
                end
            Load_type:  begin
                Aop = 2'b00;
                Bop = 2'b01;
                end
            Store_type: begin
                Bop = 2'b01;
                end
            B_type:     begin
                Aop = 2'b01;
                Bop = 2'b01;
                end    
            JAL_type:   begin
                Aop = 2'b01;
                Bop = 2'b01;
                end 
            JALR_type : begin
                Aop = 2'b00;
                Bop = 2'b01;
                end
            LUI:        begin
                Bop = 2'b01;
                end      
            AUIPC:      begin
                Aop = 2'b01;
                Bop = 2'b01;
                end     
            default:    begin
                Aop = 2'b00;
                Bop = 2'b00;
                end
        endcase
           
        if ((src1_EX == dest_MEM) & (regwen_MEM))
            Asel = 2'b10;
        else if ((src1_EX == dest_WB) & (regwen_WB))
            Asel = 2'b11;
        else 
            Asel = Aop;
                   
        if ((src2_EX == dest_MEM) & (regwen_MEM))
            Bsel = 2'b10;
        else if ((src2_EX == dest_WB) & (regwen_WB))
            Bsel = 2'b11;
        else
            Bsel = Bop;
    end
    assign stall = (WBsel_EX === 2'b00) & ((src1_ID == dest_EX) | (src2_ID == dest_EX)) & (dest_EX !== 0);
    assign flushE = PCsel_EX;
    assign flushD = PCsel_EX;
endmodule
