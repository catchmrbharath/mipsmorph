module datapath(
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
    output [5:0] op,funct);
    
    /* temporary stuff */
    wire[31:0] resultW;
    wire[31:0] pcplus1;
    wire[31:0] pcnew;
    wire[31:0] pcbranchD;
    wire[31:0] pcF;



    mux2x1 #(32) pcsel(.out(pcnew),.q0(pcplus1),.q1(pcbranchD),.sel(pcsrcD));
    flipflopE #(32) (.q(pcf),.d(pcnew),.clk(clk),.reset(reset),.enable(stallF));
    




