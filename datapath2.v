`define datawidth 16
module Datapath(
    input clk,reset,
    input memtoreg,pcsrc,
    input alusrc,
    input regwrite,jump,
    input [2:0] alucontrol,
    output zero,
    input [`datawidth-1:0] instr,
    input [`datawidth-1:0] readdata,
    output [`datawidth-1:0] aluout,writedata,
    output [7:0] pc,
    output [15:0] switchout,
    input [2:0] switchin);
    
    wire[7:0] pcnext,pcnextbr,pcplus1,pcbranch;
    wire[7:0] signimm; //are the same
    wire[`datawidth-1:0] srcA,srcB; 
    wire[`datawidth-1:0] result;
    flipflop #(8) pcreg(.q(pc),.d(pcnext),.clk(clk),.reset(reset));
    adder pcadd(pcplus1,8'd2,pc);
    adder pcadd2(pcbranch,signimm,pc);
    mux2x1 #(8) pcbrmux(.out(pcnextbr),.sel(pcsrc),.q0(pcplus1),.q1(pcbranch));
    mux2x1 #(8) pcmux(.out(pcnext),.sel(jump),.q0(pcnextbr),.q1({instr[6:0],1'b0}));


    //register file stuff
    regfile rg(.rd1(srcA),.rd2(writedata),.rd3(switchout),.wr(result),.a1(instr[8:6]),.a2(instr[5:3]),.a3(instr[11:9]),.a4(switchin),.wrenable(regwrite),.clk(clk));
    mux2x1 #(16) resmux(.q0(aluout),.q1(readdata),.sel(memtoreg),.out(result));
   signExtend se(.out(signimm),.in(instr[5:0]));
   
   //alu
   mux2x1 #(16) srcbmux(.out(srcB),.q0(writedata),.q1({{8{signimm[7]}},signimm}),.sel(alusrc));
   alu alu(.ALUout(aluout),.zeroFlag(zero),.srcA(srcA),.srcB(srcB),.aluControl(alucontrol));



    

  
endmodule 
