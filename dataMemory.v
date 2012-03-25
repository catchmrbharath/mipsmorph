`define datawidth 16
`define addrsize 8
module DataMemory #(parameter MEM=64)
(
    output[`datawidth-1:0] rd,
    input[`addrsize-1:0] address,
    input[`datawidth-1:0] wd,
    input we,
    input clk );

    reg[`datawidth-1:0] mem[MEM-1:0];

	initial begin
		mem[0]=32'h00000000;
	end

    assign rd = mem[address[31:0]]; // WORD ALIGNED

    always @(negedge clk)
        if(we)
            mem[address[31:0]]<=wd;
  
endmodule
