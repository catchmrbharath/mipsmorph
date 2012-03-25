`define datawidth 8
module adder(
    output[`datawidth-1:0] sum,
    input[`datawidth-1:0] a,
    input[`datawidth-1:0] b);
    assign sum = a+b;
    endmodule
