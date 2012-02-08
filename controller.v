module controller (
	output memtoreg, 
	output memwrite,
	output pcsrc,
	output alusrc,
	output regdst,
	output regwrite,
	output jump,
	output [2:0] alucontrol,
	input [5:0] op,
	input [5:0] funct,
	input zero);
	
	wire [1:0] aluop;
	wire branch;
	
	maindec md ( 	.op(op), 
					.memtoreg(memtoreg), 
					.memwrite(memwrite), 
					.branch(branch), 
					.alusrc(alusrc), 
					.regdst(regdst), 
					.regwrite(regwrite), 
					.jump(jump), 
					.aluop(aluop) );
	
	aludec ad (	.funct(funct),
				.aluop(aluop),
				.alucontrols(alucontrols) );
				
	assign pcsrc = branch & zero;
	
endmodule