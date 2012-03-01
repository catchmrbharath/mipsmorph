module mipsPipe (
	input clk, 
	input reset );
	
	wire [31:0] instr;
	wire equalD, flushE, pcsrcD, regdstE, alusrcE, memwriteM, regwriteW, memtoregW, branchD, regwriteE, memtoregE, regwriteM,memtoregM;
	wire [2:0] alucontrolE;
	
	wire stallF, stallD, forwardAD, forwardBD;
	wire [1:0] forwardAE, forwardBE;
	wire [5:0] op,funct;
	wire [4:0] rsD,rtD,rsE,rtE, writeregE, writeregM, writeregW;
    wire brenable, branchCorrect;
    wire [5:0] bradd;
    wire [31:0] pcD;
    wire [31:0] pcE;
    wire pcsrcE;
    wire pcbranchpred;
    wire branchCorrectE;
    wire brbitD;
    wire branchE;
	
	controllerPipe c ( 	.clk(clk),
						.reset(reset),
						.op(op),
		 				.funct(funct),
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
						.regwriteM(regwriteM), 
                        .memtoregM(memtoregM),
                        .branchCorrect(branchCorrect),
                        .brbitD(pcbranchpred),
                        .pcsrcE(pcsrcE),
                        .branchE(branchE),
                        .branchCorrectE(branchCorrectE));
	
	DatapathPipe dp (	.clk(clk),
						.reset(reset),
                        .branchCorrect(branchCorrect),
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
						.writeregW(writeregW),
                        .pcD(pcD),
                        .pcE(pcE),
                        .brbitF(pcbranchpred & branchD));
	
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
				.writeregW(writeregW), 
                .memtoregM(memtoregM),
                .branchCorrectE(branchCorrectE));
    branchMem #(32) bm( .out(pcbranchpred),.address(bradd),.we(branchE),.wd(pcsrcE),.clk(clk));
    mux2x1 #(6) baddsel(.out(bradd),.q0(pcD),.q1(pcE),.sel(branchE));
    
	
endmodule
