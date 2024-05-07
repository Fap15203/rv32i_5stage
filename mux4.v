`timescale 1ns / 1ps

module mux4 (
    input [31:0] a,b,c, d,
    input [1:0] sel,
    output reg [31:0] out
);
    always @(*) begin
       if (sel == 0) out = a;
       else if (sel == 1) out = b;
       else if (sel == 2) out = c;
       else if (sel == 3) out = d;
       else out = a;
    end
    
endmodule
