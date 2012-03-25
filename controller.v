module controller (
	output memtoreg, 
	output memwrite,
	output pcsrc,
	output alusrc,
	output regwrite,
	output jump,
	output [2:0] alucontrol,
	input [3:0] op,
	input [2:0] funct,
	input zero);
	
	wire [1:0] aluop;
	wire branch;
	
	maindec md ( 	.op(op), 
					.memtoreg(memtoreg), 
					.memwrite(memwrite), 
					.branch(branch), 
					.alusrc(alusrc), 
					.regwrite(regwrite), 
					.jump(jump), 
					.aluop(aluop) );
	
	aludec ad (	.funct(funct),
				.aluop(aluop),
				.alucontrol(alucontrol) );
				
	assign pcsrc = branch & zero;
	
endmodule