`define adwidth 3
`define datawidth 16
module regfile #(parameter MEM=8)
(
    output[`datawidth-1:0] rd1,rd2,rd3,
    input [`adwidth-1:0] a1,a2,a3,a4,
    input [`datawidth-1:0] wr,
    input clk,wrenable);

    reg[15:0] registers[MEM-1:0];
    initial
        registers[0]=0;
    assign rd1 = registers[a1];
    assign rd2 = registers[a2];
    assign rd3 = registers[a4];
    always @ (negedge clk)
        if(wrenable) 
			registers[a3]<=wr;
endmodule

        
