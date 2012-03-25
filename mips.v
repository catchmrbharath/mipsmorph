module mips (
	output [16:0] pc,
	output memwrite,
	output [16:0] aluout,
	output [16:0] writedata,
	input [16:0] instr,
	input [16:0] readdata,
	input clk, 
	input reset );
	
	wire memtoreg, branch, alusrc, regwrite, jump;
	wire [2:0] alucontrol;
	
	controller c ( 	.op(instr[15:12]),
	 				.funct(instr[2:0]),
	 				.zero(zero),
					.memtoreg(memtoreg),
					.memwrite(memwrite),
					.pcsrc(pcsrc),
					.alusrc(alusrc),
					.regwrite(regwrite),
					.jump(jump),
					.alucontrol(alucontrol) );
	
	Datapath dp (	.clk(clk),
					.reset(reset),
					.memtoreg(memtoreg),
					.pcsrc(pcsrc),
					.alusrc(alusrc),
					.regwrite(regwrite),
					.jump(jump),
					.alucontrol(alucontrol),
					.zero(zero),
					.pc(pc),
					.instr(instr),
					.aluout(aluout),
					.writedata(writedata),
					.readdata(readdata) ); 
	
endmodule