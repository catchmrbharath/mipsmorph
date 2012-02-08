`define datawidth 32
module Datapath(
    input clk,reset,
    input memtoreg,pcsrc,
    input alusrc,regdst,
    input regwrite,jump,
    input [2:0] alucontrol,
    output zero,
    input [`datawidth-1:0] instr,
    input [`datawidth-1:0] readdata,
    output [`datawidth-1:0] pc,aluout,writedata);
    wire[4:0] writereg;
    wire[`datawidth-1:0] pcnext,pcnextbr,pcplus1,pcbranch;
    wire[`datawidth-1:0] signimm,signimmsh; //are the same
    wire[`datawidth-1:0] srcA,srcB; 
    wire[`datawidth-1:0] result;
    flipflop #(32) pcreg(.q(pcnext),.d(pc),.clk(clk),.reset(reset));
    adder pcadd(pcplus1,32'b1,pc);
    adder pcadd2(pcbranch,signimm,pcplus1);
    mux2x1 #(32) pcbrmux(.out(pcnextbr),.sel(pcsrc),.q0(pcplus1),.q1(pcbranch));
    mux2x1 #(32) pcmux(.out(pcnext),.sel(jump),.q0(pcnextbr),.q1({pcplus1[31:28],instr[27:0]}));


    //register file stuff
    regfile rg(.rd1(srcA),.rd2(writedata),.wr(writedata),.a1(instr[25:21]),.a2(instr[20:16]),.a3(writereg),.wrenable(regwrite),.clk(clk));
    mux2x1 #(5) wrmux(.out(writereg),.q0(instr[20:16]),.q1(instr[15:11]),.sel(regdst));
    mux2x1 #32 resmux(.q0(aluout),.q1(readdata),.sel(memtoreg),.out(result));
   signExtend se(.out(signimm),.in(instr[15:0]));
   
   //alu
   mux2x1 #(32) srcbmux(.out(srcB),.q0(writedata),.q1(signimm),.sel(alusrc));
   alu alu(.ALUout(aluout),.zeroFlag(zero),.srcA(srcA),.srcB(srcB),.aluControl(alucontrol));



    

  
endmodule 
