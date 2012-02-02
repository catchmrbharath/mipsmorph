module controlUnit(

    output [14:0] controls,
    input[5:0] funct,
    input[5:0] opcode,
    input Zeroflag,clk)
    ;
    parameter [3:0] FETCH = 0,
        DECODE=1,
        MEMADR=2,
        MEMREAD=3,
        MEMWRITEBACK=4,
        MEMWRITE=5,
        EXECUTE=6,
        ALUWRITEBACK=7,
        BRANCH=8,
        ADDIEXECUTE=9,
        ADDIWRITEBACK=10,
        JUMP=11;
    wire[2:0] alucontrol;
    reg [3:0] state;
    reg IorD;
    reg AluSrcA;
    reg [1:0] AlUSrcB;
    reg Aluop;
    reg RegDst;
    reg MemToReg;
    reg[1:0] PCSrc;
    reg IRWrite;
    reg PCWrite;
    reg Branch;
    reg MemWrite;
    reg RegWrite;
    reg[1:0] aluop;
    aludec ALUDecoder(.alucontrol(alucontrol),.funct(funct),.aluop(aluop));
    always @(posedge clk)
        case(state)
            FETCH:
        begin
            IorD=0;
            AluSrcA=0;
            AlUSrcB=2'b01;
            Aluop=0;
            PCSrc=0;
            IRWrite=1;
            PCWrite=1;
            Branch=0;
            MemWrite=0;
            RegWrite=0;

        end
        DECODE:begin
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=0;
            RegWrite=0;
            AluSrcA=0;
            AlUSrcB=2'b11;
            Aluop=0;
        end
        MEMADR:
        begin
            AluSrcA=1;
            AlUSrcB=2'b10;
            Aluop=0;
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=0;
            RegWrite=0;
        end
        MEMREAD:
        MEMWRITEBACK:
        begin
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=0;
            RegWrite=0;
        end
        MEMWRITE:
        begin
        end
        EXECUTE:
        begin
            AluSrcA=1;
            AlUSrcB=2'b00;
            Aluop=2'b10;
        end
        ALUWRITEBACK:
        begin
            RegDst=1;
            MemToReg=0;
            RegWrite=1;
        end


    endcase
    endmodule




    
