module datapath(
    output [5:0] opcode,
    output [5:0] funct,
    input [14:0] controls,
    /*
    * 0 PCEn
    * 2:1 PCSrc
    * 5:3 ALUControl
    * 7:6 AlUSrcB
    * 8 RegWrite
    * 9 IorD
    * 10 MemWrite
    * 11 IRWrite
    * 12 RegDst
    * 13 MemToReg
    * 14 AluSrcA
    */
    input [2:0] aluControl,
    input clk,reset);
    
    wire[31:0] pcold;
    wire[31:0] pcnew;
    wire[31:0] ALUOut;
    wire[31:0] Adr;
    wire[31:0] InstrOut;
    wire[31:0] WriteData;
    wire[31:0] Instr;
    wire[31:0] Data;
    wire[31:0] RD1;
    wire[31:0] RD2;
    wire[4:0] A3;
    wire[31:0] WD3;
    wire[31:0] SignImm;
    wire[31:0] A;
    wire[31:0] B;
    wire[31:0] SrcA;
    wire[31:0] SrcB;
    wire[31:0] ALUResult;
    wire Zero;
    wire [31:0] PCJump;


    flipflopE pcreg(.clk(clk),.reset(reset),.enable(controls[0]),.d(pcold),.q(pcnew));  //flip flop at pc

    mux2x1 #(32) pcsel(.out(Adr),.sel(controls[9]),.q0(pcnew),.q1(ALUOut));

    instr #(64) InstrMem(.out(InstrOut),.address(Adr),.clk(clk),.writeEn(controls[10]),.writeData(B));

    flipflop #(32) InstrFlipFLop(.q(Instr),.d(InstrOut),.clk(clk),.reset(reset));

    flipflop #(32) DataFlipFLop(.q(Data),.d(InstrOut),.clk(clk),.reset(reset));

    assign opcode = Instr[31:26];

    assign funct = Instr[5:0];

    mux2x1 #(5) RegInMux(.out(A3),.sel(controls[12]),.q0(Instr[20:16]),.q1(Instr[15:11]));

    mux2x1 #(32) MemInMux(.out(WD3),.sel(controls[13]),.q0(ALUOut),.q1(Data));
    
    regfile RegFile(.rd1(RD1),.rd2(RD2),.a1(Instr[25:21]),.a2(Instr[20:16]),.a3(A3),.wr(WD3),.wrenable(controls[8]),.clk(clk));

    signExtend signext(.in(Instr[15:0]),.out(SignImm));

    flipflop Rd1FlipFlop(.q(A),.d(RD1),.clk(clk),.reset(reset));
    flipflop Rd2FlipFlop(.q(B),.d(RD2),.clk(clk),.reset(reset));

    mux2x1 #(32) ASel(.out(SrcA),.q0(pcnew),.q1(A),.sel(controls[14]));

    mux4x1 #32 BSel(.out(SrcB),.q0(B),.q1(32'd1),.q2(SignImm),.q3(SignImm));

    alu ALU(.ALUout(ALUResult),.zeroFlag(Zero),.srcA(SrcA),.srcB(SrcB),.aluControl(controls[5:3]));
    flipflop ALURes(.q(ALUOut),.d(ALUResult),.clk(clk),.reset(reset));

    assign PCJump = {pcnew[31:26],Instr[25:0]};
    mux4x1 #(32) PCout(.out(pcold),.q0(ALUResult),.q1(ALUOut),.q2(PCJump),.q3(0),.sel(control[2:1]));
endmodule
