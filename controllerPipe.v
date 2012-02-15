module controllerPipe (
	/* decode stage */
	output pcsrcD,
	/* execute stage */
	output alusrcE, 
	output regdstE,
	output [2:0] alucontrolE,
	/* memory stage */
	output memwriteM,
	/* write stage */
	output regwriteW, 
	output memtoregW,
	/* hazard unit input */
	output branchD,
	output regwriteE,
	output memtoregE,
	output regwriteM,
	/* inputs */
	input [5:0] op,
	input [5:0] funct,
	input equalD,
	input flushE,
	input clk,
	input reset );
	
	wire [1:0] aluop;
	
	// Decode stage temps
	wire regwriteD, memtoregD, memwriteD, alusrcD, regdstD, branchD;
	wire [2:0] alucontrolD;
	
	// Execute stage temps
	wire memwriteE;
	
	// Memory stage temps
	wire memtoregM;
	
	wire jump; // ????
	
	maindec md ( 	.op(op), 
					.memtoreg(memtoregD), 
					.memwrite(memwriteD), 
					.branch(branchD), 
					.alusrc(alusrcD), 
					.regdst(regdstD), 
					.regwrite(regwriteD), 
					.jump(jump), 
					.aluop(aluop) );
	
	aludec ad (	.funct(funct),
				.aluop(aluop),
				.alucontrol(alucontrolD) );
	
	flipflop #(8) decodeFF (.q( {regwriteD, memtoregD, memwriteD, alucontrolD, alusrcD, regdstD} ),
							.d( {regwriteE, memtoregE, memwriteE, alucontrolE, alusrcE, regdstE} ),
							.clk(clk),
							.reset(flushE | reset) );
							
	flipflop #(3) executeFF (	.q( {regwriteE, memtoregE, memwriteE} ),
								.d( {regwriteM, memtoregM, memwriteM} ),
								.clk(clk),
								.reset(reset) );
								
	flipflop #(2) writeFF (	.q( {regwriteM, memtoregM} ),
							.d( {regwriteW, memtoregW} ),
							.clk(clk),
							.reset(reset) );
	
	assign pcsrcD = branchD & equalD;
	
endmodule