module DatapathPipe(
    input clk,reset,
    /* control unit inputs */
    input pcsrcD,
    input regdstE,
    input alusrcE,
    input [2:0] alucontrolE,
    input memwriteM,
    input memtoregW,
    input regwriteW,
    /* hazard unit inputs */
    input stallF,
    input stallD,
    input forwardAD,
    input forwardBD,
    input flushE,
    input [1:0] forwardAE,
    input [1:0] forwardBE,

	/* outputs */
	
    output equalID,
    output [5:0] op,funct,
    output [4:0] rsD,rtD,rsE,rtE, writeregE, writeRegM, writeRegW);
    
    /* temporary stuff */
    wire[31:0] resultW;
    wire[31:0] pcplus1;
    wire[31:0] pcnew;
    wire[31:0] pcbranchD;
    wire[31:0] pcF;
    wire[31:0] RD;
    wire clearF;
    assign clearF = reset | stallD;
    wire [63:0] idin; // input tot he id stage
    wire[31:0] instrD;
    wire[31:0] pcplus1D;
    wire[31:0] rd1;
    wire[31:0] rd2;
    //wire[4:0] writeRegW; // should be an output along with writeRegM
    wire[31:0] aluoutM;
    wire[31:0] equalidA;
    wire[31:0] equalidB;
    wire[31:0] rd1E;
    wire[31:0] rd2E;
    wire[31:0] signimmE;
    wire[31:0] srcAE;
    wire[31:0] srcBE;
	wire[31:0] writedataE;
    wire[31:0] writedataM;
    wire[95:0] readin;
    



    mux2x1 #(32) pcsel(.out(pcnew),.q0(pcplus1),.q1(pcbranchD),.sel(pcsrcD));
    flipflopE #(32) pcflip(.q(pcF),.d(pcnew),.clk(clk),.reset(reset),.enable(stallF));
    adder pcadd(.sum(pcplus1),.a(pcnew),.b(1'b1));
    instr #(32) instrmem(.out(RD),.in(pcF));
    flipflopE #(63) fetchreg(.q(idin),.d({RD,pcplus1}),.enable(pcsrcD),.reset(clearF));
    assign instrD = idin[63:32];
    assign pcplus1D = idin[31:0];
    assign op = instrD[31:26];
    assign funct = instrD[5:0];
    regfile regmem(.rd1(rd1),.rd2(rd2),.a1(instrD[25:21]),.a2(instrD[20:16]),.a3(writeRegW),.wrenable(regwriteW),.clk(clk),.wr(resultW));
    signExtend signextend(.out(signimmD),.in(instrD[15:0]));
    adder jumpadd(.sum(pcbranchD),.a(signimmD),.b(pcplus1D));
    assign rsD = instrD[25:21];
    assign rtD = instrD[20:16];
    assign rdD = instrD[15:11];
    mux2x1 read1(.out(equalidA),.q0(rd1),.q1(aluoutM),.sel(forwardAD));
    mux2x1 read2(.out(equalidB),.q0(rd2),.q1(aluoutM),.sel(forwardBD));
    equalCheck equalid(.a(equalidA),.b(equalidB),.equalcheck(equalID));
    flipflop #(111) decodereg(.q(inex),.d({equalidA,equalidB,signimmD,rsD,rtD,rdD}),.clk(clk),.reset(flushE | reset));
    assign rd1E = inex[111:79];
    assign rd2E = inex[78:47];
    assign rsE = inex[14:10];
    assign rtE = inex[9:5];
    assign rdE = inex[4:0];
    assign signimmE = inex[46:15];
    mux2x1 #(32) writemux(.out(writeregE),.q0(rtE),.q1(rdE),.sel(regdstE));
    mux4x1 #(32) srcamux(.out(srcAE),.q0(rd1E),.q1(resultW),.q2(aluoutM),.q3(32'b0),.sel(forwardAE));
    mux4x1 #(32) writedataEmux(.out(writedataE),.q0(rd2E),.q1(resultW),.q2(aluoutM),.q3(32'b0),.sel(forwardBE));
    alu ALU(.ALUout(aluoutE),.zeroFlag(zero),.srcA(srcAE),.srcB(srcBE),.aluControl(alucontrolE));
    flipflop #(69) readflop(.q(readin),.d({aluoutE,writedataE,writeregE}),.clk(clk),.reset(reset));
    assign aluoutM = readin[68:37];
    assign writedataM = readin[36:5];
    assign writeRegM= readin[4:0];

    //data memory
    DataMemory datamem(.rd(readdataM),.wd(writedataM),.clk(clk),.we(memwriteM));
    flipflop #(69) execflop(.q(writein),.d({readdataM,aluoutM,writeRegM}),.clk(clk),.reset(reset));

    assign writeRegW = writein[4:0];
    assign readdataW = writein[68:37];
    assign aluoutW = writein[36:5];

    mux2x1 #(32) resultmux(.out(resultW),.q0(aluoutW),.q1(readdataW),.clk(clk),.reset(reset));






    endmodule




    



    

    




