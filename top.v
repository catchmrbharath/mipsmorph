module top (
	output [16:0] writedata, 
	output [16:0] dataadr,
	output memwrite,
	input clk,
	input reset );
	
	wire [16:0]  instr, readdata;
    wire [7:0] pc;
	
	mips mips(  .clk(clk),
				.reset(reset),
				.pc(pc),
				.instr(instr),
				.memwrite(memwrite),
				.aluout(dataadr),
				.writedata(writedata),
				.readdata(readdata) );
				
	instr imem( .address(pc[5:0]),
				.out(instr) );
	
	DataMemory #(128) dmem(	.rd(readdata),
	 					.wd(writedata),
	 					.address(dataadr),
						.we(memwrite),
						.clk(clk) );
	
endmodule
