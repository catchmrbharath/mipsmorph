module flipflop #(parameter WIDTH=32)
    (output reg [ WIDTH-1:0] q,
        input [WIDTH-1:0] d,
        input clk,reset);
    always @(posedge clk or reset)
        if(reset)
            q<=0;
        else
            q<=d;
        endmodule
