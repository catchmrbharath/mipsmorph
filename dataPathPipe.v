module DatapathPipe(
    input clk,reset,
    /* control unit inputs */
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
    input brbitF,
    input branchCorrect,
    input [1:0] brmuxsel,

	/* outputs */
	
    output equalD,
    output [5:0] op,funct,
    output [4:0] rsD,rtD,rsE,rtE, writeregE, writeregM, writeregW,
    output [31:0] pcD,pcE);
    
    /* temporary stuff */
    wire [4:0] rdD;
    wire[31:0] resultW;
    wire[31:0] pcplus1;
    wire[31:0] pcnew;
    wire[31:0] pcbranchD;
    wire[31:0] RD;
    wire [95:0] idin; // input tot he id stage
    wire [31:0] instrD;
    wire[31:0] pcplus1D;
    wire[31:0] rd1;
    wire[31:0] rd2;
    //wire[4:0] writeRegW; // should be an output along with writeRegM
    wire[31:0] aluoutM;
    wire[31:0] equaldA;
    wire[31:0] equaldB;
    wire[31:0] rd1E;
    wire[31:0] rd2E;
    wire[31:0] signimmE;
    wire[31:0] signimmD;
    wire[31:0] srcAE;
    wire[31:0] srcBE;
	wire[31:0] writedataE;
    wire[31:0] writedataM;
    wire[68:0] readin;
    wire[110:0] inex;
    wire [4:0] rdE;
    wire [31:0] aluoutE;
    wire [68:0] writein;
    wire [31:0] readdataM;
    wire [31:0] readdataW;
    wire [31:0] aluoutW;
    wire [31:0] pcD;
    wire [31:0] pcbr;
    wire [31:0] pcF;



    mux4x1 #(32) pcsel(.out(pcnew),.q0(pcplus1),.q1(pcbranchD),.q2(pcplus1D),.q3(32'd0),.sel(brmuxsel));
    flipflopE #(32) pcflip(.q(pcplus1D),.d(pcplus1),.clk(clk),.reset(reset),.enable(~stallF));
    flipflopE #(32) pcflip(.q(pcF),.d(pcnew),.clk(clk),.reset(reset),.enable(~stallF));
    mux2x1 #(32) pcbrselect(.out(pcbr),.q0(pcF),.q1(pcbranchD),.sel(brbitF));
    flipflop #(32) pcEFF(.q(pcE),.d(pcD),.clk(clk),.reset(reset));
    adder pcadd(.sum(pcplus1),.a(pcbr),.b(32'b1));
    instr #(32) instrmem(.out(RD),.address(pcbr[5:0]));
    flipflopE #(96) fetchreg(.q(idin),.d({pcbr,RD,pcplus1}),.enable(~stallD),.reset(reset),.clk(clk));
    assign instrD = idin[63:32];
    assign pcD = idin[95:64];
    assign pcplus1D = idin[31:0];
    assign op = instrD[31:26];
    assign funct = instrD[5:0];
    regfile regmem(.rd1(rd1),.rd2(rd2),.a1(instrD[25:21]),.a2(instrD[20:16]),.a3(writeregW),.wrenable(regwriteW),.clk(clk),.wr(resultW));
    signExtend signextend(.out(signimmD),.in(instrD[15:0]));
    adder jumpadd(.sum(pcbranchD),.a(signimmD),.b(pcplus1D));
    assign rsD = instrD[25:21];
    assign rtD = instrD[20:16];
    assign rdD = instrD[15:11];
    mux2x1 read1(.out(equaldA),.q0(rd1),.q1(aluoutM),.sel(forwardAD));
    mux2x1 read2(.out(equaldB),.q0(rd2),.q1(aluoutM),.sel(forwardBD));
    equalCheck equald(.a(equaldA),.b(equaldB),.equalcheck(equalD));
    flipflop #(111) decodereg(.q(inex),.d({equaldA,equaldB,signimmD,rsD,rtD,rdD}),.clk(clk),.reset(flushE | reset));
    assign rd1E = inex[111:79];
    assign rd2E = inex[78:47];
    assign rsE = inex[14:10];
    assign rtE = inex[9:5];
    assign rdE = inex[4:0];
    assign signimmE = inex[46:15];
    mux2x1 #(5) writemux(.out(writeregE),.q0(rtE),.q1(rdE),.sel(regdstE));
    mux4x1 #(32) srcamux(.out(srcAE),.q0(rd1E),.q1(resultW),.q2(aluoutM),.q3(32'b0),.sel(forwardAE));
    mux4x1 #(32) writedataEmux(.out(writedataE),.q0(rd2E),.q1(resultW),.q2(aluoutM),.q3(32'b0),.sel(forwardBE));
    mux2x1 #(32) srcbmux(.out(srcBE),.q0(writedataE),.q1(signimmE),.sel(alusrcE));
    alu ALU(.ALUout(aluoutE),.zeroFlag(zero),.srcA(srcAE),.srcB(srcBE),.aluControl(alucontrolE));
    flipflop #(69) readflop(.q(readin),.d({aluoutE,writedataE,writeregE}),.clk(clk),.reset(reset));
    assign aluoutM = readin[68:37];
    assign writedataM = readin[36:5];
    assign writeregM= readin[4:0];

    //data memory
    DataMemory #(100) datamem(.rd(readdataM),.wd(writedataM),.clk(clk),.we(memwriteM),.address(aluoutM));
    flipflop #(69) execflop(.q(writein),.d({readdataM,aluoutM,writeregM}),.clk(clk),.reset(reset));

    assign writeregW = writein[4:0];
    assign readdataW = writein[68:37];
    assign aluoutW = writein[36:5];

    mux2x1 #(32) resultmux(.out(resultW),.q0(aluoutW),.q1(readdataW),.sel(memtoregW));






    endmodule




    



    

    




