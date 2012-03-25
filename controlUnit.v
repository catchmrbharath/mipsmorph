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
    reg ALUScrA;
    reg [1:0] ALUScrB;
    reg ALUOp;
    reg RegDst;
    reg MemToReg;
    reg[1:0] PCSrc;
    reg IRWrite;
    reg PCWrite;
    reg Branch;
    reg MemWrite;
    reg RegWrite;
    reg[1:0] ALUOp;
    aludec ALUDecoder(.alucontrol(alucontrol),.funct(funct),.aluop(ALUOp));
    always @(posedge clk)
        case(state)
            FETCH:
        begin
            IorD=0;
            ALUScrA=0;
            ALUScrB=2'b01;
            ALUOp=0;
            PCSrc=0;
            IRWrite=1;
            PCWrite=1;
            Branch=0;
            MemWrite=0;
            RegWrite=0;

        end
        DECODE:
		begin
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=0;
            RegWrite=0;
            ALUScrA=0;
            ALUScrB=2'b11;
            ALUOp=0;
        end
        MEMADR:
        begin
            ALUScrA=1;
            ALUScrB=2'b10;
            ALUOp=0;
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=0;
            RegWrite=0;
        end
        MEMREAD:
		begin
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=0;
            RegWrite=0;
			IorD = 1;
        end
        MEMWRITEBACK:
        begin
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=0;
            RegWrite=1;
			RegDst=0;
			MemToReg=1;
        end
        MEMWRITE:
        begin
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=1;
            RegWrite=0;
			IorD=1;
        end
        EXECUTE:
        begin
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=0;
            RegWrite=0;
			ALUScrA=1;
			ALUScrB=0;
			ALUOp=2'b10;
        end
        ALUWRITEBACK:
        begin
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=0;
            RegWrite=1;
			RegDst=1;
			MemToReg=0;
        end
		BRANCH:
		begin
            IRWrite=0;
            PCWrite=0;
            Branch=1;
            MemWrite=0;
            RegWrite=0;
			ALUScrA=1;
			ALUScrB=0;
			ALUOp=2'b01;
			PCSrc=2'b01;
        end
		ADDIEXECUTE:
		begin
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=0;
            RegWrite=0;
			ALUScrA=1;
			ALUScrB=2'b10;
			ALUOp=0;
        end
		ADDIWRITEBACK:
		begin
            IRWrite=0;
            PCWrite=0;
            Branch=0;
            MemWrite=0;
            RegWrite=1;
			RegDst=0;
			MemToReg=0;
        end
		JUMP:
		begin
            IRWrite=0;
            PCWrite=1;
            Branch=0;
            MemWrite=0;
            RegWrite=0;
			PCSrc=2'b10;
        end

    endcase
    endmodule




    
