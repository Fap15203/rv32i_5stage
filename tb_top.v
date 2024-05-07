
`timescale 1ns/1ps
module tb_top(
);
    reg clk,rst;
    wire [31:0] IF, ID, EX, MEM, WB;
    
    top top_instance(
        .clk(clk),
        .rst(rst),
        .pcIF(IF),
        .pcID(ID),
        .pcEX(EX),
        .pcMEM(MEM),
        .pcWB(WB)
    );
    always @ (WB) begin
        if (WB >= 40)
            $finish;
    end
    initial begin
        clk <= 1'b0;
        forever #1 clk = ~clk;
    end
    initial begin
        rst = 0;
        #4 rst = 1;
    end
    
    
endmodule

// test 1: no hazard
//addi t1 , t0,   10 
//addi t2 , t0,   18 
//addi t3 , t0,   10 
//addi t4 , t0,   20 
//addi t5 , t0,   30 
//add t1, t2, t1
//lw t4, 8(t2)
//sw t3, 10(t2)
//lw t5, 10(t2)   
//00a28313
//01228393
//00a28e13
//01428e93
//01e28f13
//00638333
//0083ae83
//01c3a523
//00a3af03 

//test 2: data hazard
//addi s0, t0, 4
//sub t2, s0, t0
//or t3, t3, s0
//add s0,t1,t2
//lw s1,8(s0)
//or t3,s1,t1
//and t4,s1,t2
//sll t0,t1,t2
//00428413
//405403b3
//008e6e33
//00730433
//00842483
//0064ee33
//0074feb3
//007312b3

//test 3: control hazard
//beq t0,t1,18
//sub t2,s0,t0
//or t6,s0,t3
//xor t5,t1,s0
//nop
//nop
//sw s0,8(t3)
//00628c63
//405403b3
//01c46fb3
//00834f33
//00000013
//00000013
//008e2423