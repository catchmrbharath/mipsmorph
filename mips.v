module mips (
	output [31:0] pc,
	output memwrite,
	output [31:0] aluout,
	output [31:0] writedata,
	input [31:0] instr,
	input [31:0] readdata,
	input clk, 
	input reset );
	
	wire memtoreg, branch, alusrc, regdst, regwrite, jump;
	wire [2:0] alucontrol;
	
	controller c ( 	.op(instr[31:26]),
	 				.funct(instr[5:0]),
	 				.zero(zero),
					.memtoreg(memtoreg),
					.memwrite(memwrite),
					.pcsrc(pcsrc),
					.alusrc(alusrc),
					.regdst(regdst),
					.regwrite(regwrite),
					.jump(jump),
					.alucontrol(alucontrol) );
	
	Datapath dp (	.clk(clk),
					.reset(reset),
					.memtoreg(memtoreg),
					.pcsrc(pcsrc),
					.alusrc(alusrc),
					.regdst(regdst),
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