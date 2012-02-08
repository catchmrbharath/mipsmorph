module top (
	output [31:0] writedata, 
	output [31:0] dataadr,
	output memwrite,
	input clk,
	input reset );
	
	wire [31:0] pc, instr, readdata;
	
	mips mips(  .clk(clk),
				.reset(reset),
				.pc(pc),
				.instr(instr),
				.memwrite(memwrite),
				.dataadr(dataadr),
				.writedata(writedata),
				.readdata(readdata) );
				
	instr imem( .address(pc[7:2]),
				.out(instr) );
	
	DataMemory dmem(	.rd(readdata),
	 					.wd(writedata),
	 					.address(dataadr),
						.we(memwrite),
						.clk(clk) );
	
endmodule