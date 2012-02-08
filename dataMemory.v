`define datawidth 32
module DataMemory #(parameter MEM=64)
(
    output[`datawidth-1:0] rd,
    input[`datawidth-1:0] address,
    input[`datawidth-1:0] wd,
    input we
    input clk );

    reg[`datawidth-1:0] mem[MEM-1:0];

    assign rd = mem[address[31:2]]; // WORD ALIGNED

    always @(posedge clk)
        if(we)
            mem[address[31:2]]<=wd;
  
endmodule
