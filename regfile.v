`define adwidth 5
`define datawidth 32
module regfile #(parameter MEM=32)
(
    output[`datawidth-1:0] rd1,rd2,
    input [`adwidth-1:0] a1,a2,a3,
    input [`datawidth-1:0] wr,
    input clk,wrenable);

    reg[`datawidth-1:0] registers[MEM-1:0];
    initial
        registers[0]=0;
    assign rd1 = registers[a1];
    assign rd2 = registers[a2];
    always @ (posedge clk)
        if(wrenable) 
			registers[a3]<=wr;
endmodule

        
