module hazard (
	output stallF,
	output stallD,
	output forwardAD,
	output forwardBD,
	output flushE,
	output [1:0] forwardAE,
	output [1:0] forwardBE,
	input branchD,
	input memtoregE,
	input regwriteE,
	input regwriteM,
	input regwriteW,
	input [4:0] rsD,
	input [4:0] rtD,
	input [4:0] rsE,
	input [4:0] rtE,
	input [4:0] writeregE,
	input [4:0] writeregM,
	input [4:0] writeregW );

	wire lwstall, branchstall;
	reg [1:0] forwardAE, forwardBE; 

	always @ (rsE or writeregM or regwriteM or writeregW or regwriteW) begin
		if((rsE!=0) & (rsE == writeregM) & regwriteM)
			forwardAE = 2'b10;
		else if((rsE!=0) & (rsE == writeregW) & regwriteW)
			forwardAE = 2'b01;
		else 
			forwardAE = 2'b00;
	end

	always @ (rtE or writeregM or regwriteM or writeregW or regwriteW) begin
		if((rtE!=0) & (rtE == writeregM) & regwriteM)
			forwardBE = 2'b10;
		else if((rtE!=0) & (rtE == writeregW) & regwriteW)
			forwardBE = 2'b01;
		else 
			forwardBE = 2'b00;
	end
	
	assign forwardAD = (rsD != 0) & (rsD == writeregM) & regwriteM;
	assign forwardBD = (rtD != 0) & (rtD == writeregM) & regwriteM;

	assign lwstall = ((rsD == rtE) | (rtD == rtE) & memtoregE);
	assign branchstall = (branchD & regwriteE & (writeregE == rsD | writeregE == rtD)) | (branchD & memtoregM & (writeregM == rsD | writeregM == rtD));		
	assign stallF = lwstall | branchstall;
	assign stallD = lwstall | branchstall;
	assign flushE = lwstall | branchstall;

endmodule
