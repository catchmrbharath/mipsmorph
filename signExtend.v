module signExtend(
    input [5:0] in,
    output[7:0] out);
    assign out = {in[5],in,1'b0};
endmodule
