module flipflopE #(parameter WIDTH=32)
    (output reg [ WIDTH-1:0] q,
        input [WIDTH-1:0] d,
        input clk,reset,enable);
    always @(posedge clk)
        if(reset)
            q<=0;
        else if(enable)
            q<=d;
        else
            q<=q;
        endmodule
