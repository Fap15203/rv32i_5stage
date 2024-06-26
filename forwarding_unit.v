`timescale 1ns / 1ps

//module forward_unit(
//    input [31:0] instr_EX, instr_MEM,
//    output [1:0] Asel, Bsel
//    );
    
//    parameter RegFile   =   2'b00;
//    parameter preALU    =   2'b01;
//    parameter imm       =   2'b10;
//    parameter pc        =   2'b10;
    
//    always @ (*) begin
//        if (instr_MEM[11:7] == instr_EX[19:15];
            
//endmodule

//module forward_unit(
//    input            ExMem_RegWrite  ,
//    input      [4:0] ExMem_RegRd,
//    input            MemWb_RegWrite  ,
//    input      [4:0] MemWb_RegRd,
//    input      [4:0] IdEx_RegRs1,
//    input      [4:0] IdEx_RegRs2,
//    output reg [1:0] ForwardA        ,
//    output reg [1:0] ForwardB    
//);
//    //ALU source A
//    assign ForwardA_ExMemForward = ExMem_RegWrite
//                              && (ExMem_RegRd !=0)
//                              && (ExMem_RegRd == IdEx_RegRs1);
//    assign ForwardA_MemWBForward = MemWb_RegWrite
//                              && (MemWb_RegRd !=0)
//                              && (MemWb_RegRd == IdEx_RegRs1);
//    always @(*) begin
//        if (ForwardA_ExMemForward) //forward from ExMem register
//            ForwardA = 2'b10;
//        else if (ForwardA_MemWBForward) //forward from MemWb register
//            ForwardA = 2'b01;
//        else
//            ForwardA = 2'b00;
//    end
//    //ALU source B
//    assign ForwardB_ExMemForward =  MemWb_RegWrite
//                              && (MemWb_RegRd !=0)
//                              && (MemWb_RegRd == IdEx_RegRs2);
//    assign ForwardB_MemWBForward = MemWb_RegWrite
//                              && (MemWb_RegRd !=0)
//                              && (MemWb_RegRd == IdEx_RegRs2);

//    always @(*) begin
//        if (ForwardB_ExMemForward) //forward from ExMem register
//            ForwardB = 2'b10;
//        else if (ForwardB_MemWBForward) //forward from MemWb register
//            ForwardB = 2'b01;
//        else
//            ForwardB = 2'b00;
//    end
//endmodule