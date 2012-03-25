`define datawidth 32
module DataMemory #(parameter MEM=64)
(
    output[`datawidth-1:0] rd,
    input[`datawidth-1:0] address,
    input[`datawidth-1:0] wd,
    input we,
    input clk );

    reg[`datawidth-1:0] mem[MEM-1:0];

	initial begin
		mem[0]=32'h00000001;
		mem[1]=32'h00000001;
		mem[2]=32'h00000001;
		mem[3]=32'h00000001;
		mem[4]=32'h00000001;
		mem[5]=32'h00000001;
		mem[6]=32'h00000001;
		mem[7]=32'h00000001;
		mem[8]=32'h00000001;
		mem[9]=32'h00000001;
		mem[10]=32'h00000001;
		mem[11]=32'h00000001;
		mem[12]=32'h00000001;

	end

    assign rd = mem[address[31:0]]; // WORD ALIGNED

    always @(posedge clk)
        if(we)
            mem[address[31:0]]<=wd;
  
endmodule
