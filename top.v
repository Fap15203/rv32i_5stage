`timescale 1ns / 1ps

module top(
    input clk,
    input rst,
    output [31:0] pcIF, pcID, pcEX, pcMEM, pcWB
    );
    //IF wires
    wire [31:0] pc_IF, pc_add4_IF, pc_next_IF, instr_IF;
    wire [31:0] wb;
    //ID wires
    wire brEq, brLt, immm_sel, brUn;
    wire [31:0] instr_ID, pc_ID, imm_ID, rs1_ID, rs2_ID;
    wire [4:0] src1_ID, src2_ID, dest_ID;
    wire [1:0] WBsel_ID;
    wire [3:0] alu_control_ID;
    //EX wires
    wire MemRW_EX, regwen_EX, PCsel_EX;                
    wire [4:0] src1_EX, src2_EX, dest_EX;               
    wire [31:0] pc_EX, rs1_EX, rs2_EX, imm_EX, instr_EX, alu_EX;
    wire [1:0] WBsel_EX;                         
    wire [3:0] alu_control_EX;       
    //MEM wires
    wire [1:0] WBsel_MEM;                
    wire regwen_MEM, MemRW_MEM;          
    wire [31:0] pc_MEM, alu_MEM, rs2_MEM;                   
    wire [4:0] dest_MEM;
    //WB wires
    wire regwen_WB;                  
    wire [1:0] WBsel_WB;             
    wire [31:0] alu_WB, mem_WB, pc_WB;
    wire [4:0] dest_WB;
    
    
    // IF
    mux pc_sel (
        .s(PCsel_EX),
        .a(pc_add4_IF),
        .b(alu_EX),
        .c(pc_next_IF)
    );
    pc pc_instance (
        .pc_next(pc_next_IF),
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .pc(pc_IF)
    );
    pc_adder pc_add_4 (
        .pc_in(pc_IF),
        .pc_out(pc_add4_IF)
    );
    imem instr_mem (
        .address(pc_IF),
        .RD(instr_IF)
    );
    
    IF_ID fd (clk, rst, flushD, stall, instr_IF, pc_IF, instr_ID, pc_ID);
    //ID
    controller controller (
        .instr(instr_ID),
        .imm_sel(imm_sel),
        .BrUn(brUn),
        .BrLt(brLt),
        .BrEq(brEq),
        // to next stage
        .PCsel(PCsel_ID),
        .RegWEn(regwen_ID),
        .alu_control(alu_control_ID),
        .WBsel(WBsel_ID),
        .MemRW(MemRW_ID)
    );
    
    
    assign src1_ID = instr_ID[19:15];
    assign src2_ID = instr_ID[24:20];
    assign dest_ID = instr_ID[11:7];
    REG register_file (
        .clk(clk),
        .rst(rst),
        .A1(src1_ID),
        .A2(src2_ID),
        .A3(dest_ID),
        .WD3(wb),
        .WE3(regwen_ID),
        .RD1(rs1_ID),
        .RD2(rs2_ID)
    );
    imm_gen bit_exten (
        .instr(instr_ID),
        .imm_out(imm_ID),
        .imm_sel(imm_sel)
    );
    
    branch_comp bc (
        .A(rs1_ID),
        .B(rs2_ID),
        .eq(brEq),
        .lt(brLt),
        .brUn(brUn)
    );
    
    
    //EX   
    wire [1:0] Asel, Bsel;
    wire [31:0] A_alu, B_alu;
    ID_EX de (clk, rst, flushE, pc_ID, rs1_ID, rs2_ID, imm_ID, instr_ID,src1_ID, src2_ID, dest_ID,WBsel_ID, alu_control_ID,MemRW_ID, regwen_ID, PCsel_ID,MemRW_EX, regwen_EX, PCsel_EX,src1_EX, src2_EX, dest_EX,pc_EX, rs1_EX, rs2_EX, imm_EX, instr_EX,WBsel_EX,alu_control_EX);
    mux4 muxA (
        .sel(Asel),
        .a(rs1_EX),
        .b(pc_EX),
        .c(alu_MEM),
        .d(alu_WB),
        .out(A_alu)
    );
    mux4 muxB (
        .sel(Bsel),
        .a(rs2_EX),
        .b(imm_EX),
        .c(alu_MEM),
        .d(alu_WB),
        .out(B_alu)
    );
    alu ALU (
        .A(A_alu),
        .B(B_alu),
        .alu_control(alu_control_EX),
        .alu_result(alu_EX)
    );
    
    EX_MEM em (clk, rst,pc_EX, alu_EX, rs2_EX,regwen_EX, MemRW_EX,WBsel_EX,WBsel_MEM,regwen_MEM, MemRW_MEM,pc_MEM, alu_MEM, rs2_MEM, dest_EX, dest_MEM);
    //MEM
    
    data_mem dmem (
        .clk(clk),
        .rst(rst),
        .address(alu_MEM),
        .MemRW(MemRW_MEM),
        .DataR(mem_MEM),
        .DataW(rs2_MEM)
    );
    
    //WB
    MEM_WB mw (clk, rst,alu_MEM, mem_MEM,pc_MEM,regwen_MEM,WBsel_MEM,regwen_WB,WBsel_WB,alu_WB, mem_WB, pc_WB, dest_MEM, dest_WB);

    wire [31:0] pc_add4_WB;
    
    pc_adder pc_add_4_WB (
        .pc_in(pc_WB),
        .pc_out(pc_add4_WB)
    );
    
    mux4 muxWB (
        .a(mem_WB),
        .b(alu_WB),
        .c(pc_add4_WB),
        .sel(WBsel_WB),
        .out(wb)
    );
    
    assign pcIF = pc_IF;
    assign pcID = pc_ID;
    assign pcEX = pc_EX;
    assign pcMEM = pc_MEM;
    assign pcWB = pc_WB;
    
    hazard hz (instr_EX,src1_EX, src2_EX, dest_MEM, dest_WB, src1_ID, src2_ID, dest_EX,WBsel_EX,regwen_WB, regwen_MEM, PCsel_EX,Asel, Bsel, stall, flushE, flushD);
endmodule
