module mux4x1 #(parameter WIDTH=32)
(
    output reg[WIDTH-1:0] out,
    input [WIDTH-1:0] q0,q1,q2,q3 ,
    input[1:0] sel);
    
    always @(sel or q0 or q1 or q2 or q3)
    case(sel)
        2'b00: assign out =q0; 
        2'b01: assign out =q1; 
        2'b10: assign out =q2; 
        2'b11: assign out =q3; 
    endcase

    endmodule
