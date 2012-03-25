module equalCheck(
    input [31:0] a,b,
    output equalcheck);
    assign equalcheck = a==b ? 1'b1:1'b0;
    endmodule
