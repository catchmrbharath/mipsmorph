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
    output memtoregM,
    output isBranch,
    output branchCorrect,
    output pcsrcE,
    output branchE,
    output branchCorrectE,
	/* inputs */
	input [5:0] op,
	input [5:0] funct,
	input equalD,
	input flushE,
	input clk,
	input reset,
    input brbitD,
    /* branch select mux*/
    output reg [1:0] brmuxsel);
	
	wire [1:0] aluop;
	
	// Decode stage temps
	wire regwriteD, memtoregD, memwriteD, alusrcD, regdstD, branchD;
	wire [2:0] alucontrolD;
    assign isBranch = (op==6'b000100);
	
	// Execute stage temps
	wire memwriteE;
	
	// Memory stage temps
	
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
	
	flipflopclr #(8) decodeFF (.d( {regwriteD, memtoregD, memwriteD, alucontrolD, alusrcD, regdstD} ),
							.q( {regwriteE, memtoregE, memwriteE, alucontrolE, alusrcE, regdstE} ),
							.clk(clk),
							.reset(reset),.clear(flushE) );
							
	flipflop #(3) executeFF (	.d( {regwriteE, memtoregE, memwriteE} ),
								.q( {regwriteM, memtoregM, memwriteM} ),
								.clk(clk),
								.reset(reset) );
								
	flipflop #(2) writeFF (	.d( {regwriteM, memtoregM} ),
							.q( {regwriteW, memtoregW} ),
							.clk(clk),
							.reset(reset) );
    flipflop #(2) exbrFF( .q({pcsrcE,branchE}),.d({pcsrcD,branchD}),.clk(clk),.reset(reset));
    flipflop #(1) brcorrectFF(.q(branchCorrectE),.d(branchCorrect),.clk(clk),.reset(reset));
	
	assign pcsrcD = branchD & equalD;
    assign tempbranchpred =  !(equalD^brbitD);
    assign branchCorrect = branchD & tempbranchpred;

    /* branch prediction bits */
    always @(branchD or equalD or tempbranchpred) begin
        if(!branchD)
            brmuxsel = 2'b00;
        else if(branchCorrect)
            brmuxsel = 2'b00;
        else if(branchD & equalD & (!tempbranchpred))
            brmuxsel = 2'b01;
        else if(branchD & !equalD &(!tempbranchpred))
            brmuxsel = 2'b10;
    end
    
	
endmodule
