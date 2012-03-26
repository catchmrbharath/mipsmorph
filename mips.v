module mips (
	output [7:0] pc,
	output memwrite,
	output [15:0] aluout,
	output [15:0] writedata,
    output [15:0] switchout,
    output [5:0] controlSig,
    input [2:0] switchin,
	input [15:0] instr,
	input [15:0] readdata,
	input clk, 
	input reset );
	
	wire memtoreg, alusrc, regwrite, jump;
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
assign controlSig  = {memtoreg,memwrite,alusrc,regwrite,jump,pcsrc};	
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
					.readdata(readdata),
                    .switchin(switchin),
                    .switchout(switchout)); 
	
endmodule
