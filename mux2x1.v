
module mux2x1 #(parameter WIDTH=32)
(
    output[WIDTH-1:0] out,
    input [WIDTH-1:0] q1,q0,
    input sel);
    assign out = s ? q1:q0; 
    endmodule
