module mipsPipe (
	input clk, 
	input reset );
	
	wire [31:0] instr;
	wire equalD, flushE, pcsrcD, regdstE, alusrcE, memwriteM, regwriteW, memtoregW, branchD, regwriteE, memtoregE, regwriteM;
	wire [2:0] alucontrolE;
	
	wire stallF, stallD, forwardAD, forwardBD;
	wire [1:0] forwardAE, forwardBE;
	wire [5:0] op,funct;
	wire [4:0] rsD,rtD,rsE,rtE, writeregE, writeregM, writeregW;
	
	controllerPipe c ( 	.clk(clk),
						.reset(reset),
						.op(instr[31:26]),
		 				.funct(instr[5:0]),
						.equalD(equalD),
						.flushE(flushE),
						.pcsrcD(pcsrcD),
						.alusrcE(alusrcE),
						.regdstE(regdstE),
						.alucontrolE(alucontrolE),
						.memwriteM(memwriteM),
						.regwriteW(regwriteW),
						.memtoregW(memtoregW),
						.branchD(branchD),
						.regwriteE(regwriteE),
						.memtoregE(memtoregE),
						.regwriteM(regwriteM) );
	
	DatapathPipe dp (	.clk(clk),
						.reset(reset),
						.pcsrcD(pcsrcD),
						.regdstE(regdstE),
						.alusrcE(alusrcE),
						.alucontrolE(alucontrolE),
						.memwriteM(memwriteM),
						.memtoregW(memtoregW),
						.regwriteW(regwriteW),
						.stallF(stallF), 
						.stallD(stallD), 
						.forwardAD(forwardAD),
						.forwardBD(forwardBD),
						.flushE(flushE),
						.forwardAE(forwardAE),
						.forwardBE(forwardBE),
						.equalD(equalD),
						.op(op),
						.funct(funct),
						.rsD(rsD),
						.rtD(rtD),
						.rsE(rsE),
						.rtE(rtE),
						.writeregE(writeregE),
						.writeregM(writeregM),
						.writeregW(writeregW) ); 
	
	hazard h (	.stallF(stallF),
				.stallD(stallD),
				.forwardAD(forwardAD),
				.forwardBD(forwardBD),
				.flushE(flushE),
				.forwardAE(forwardAE),
				.forwardBE(forwardBE),
				.branchD(branchD),
				.memtoregE(memtoregE),
				.regwriteE(regwriteE),
				.regwriteM(regwriteM),
				.regwriteW(regwriteW),
				.rsD(rsD),
				.rtD(rtD),
				.rsE(rsE),
				.rtE(rtE),
				.writeregE(writeregE),
				.writeregM(writeregM),
				.writeregW(writeregW) );
	
endmodule