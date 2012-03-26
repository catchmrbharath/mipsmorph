`define datawidth 16
`define addrsize 16
module DataMemory #(parameter MEM=64)
(
    output[`datawidth-1:0] rd,
    input[`addrsize-1:0] address,
    input[`datawidth-1:0] wd,
    input we,
    input clk );

    reg[`datawidth-1:0] mem[MEM-1:0];

	initial begin
		mem[0]=16'd0;
	end

    assign rd = mem[address[15:0]]; // WORD ALIGNED

    always @(negedge clk)
        if(we)
            mem[address[15:0]]<=wd;
  
endmodule
