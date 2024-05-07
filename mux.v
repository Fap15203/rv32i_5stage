`timescale 1ns / 1ps

module mux (
    input [31:0] a,b,
    input s,
    output [31:0] c
);
    assign c = (s === 1'b1) ? b:a;
endmodule

