
module flipflopclr #(parameter WIDTH=32)
    (output reg [ WIDTH-1:0] q,
        input [WIDTH-1:0] d,
        input clk,reset,clear);
    always @(posedge clk)
        if(reset)
             #1 q<=0;
        else if(clear)
            #1 q<=0;
        else
            q<=d;
        endmodule
