module aludec(
    output reg[2:0] alucontrol,
    input [5:0] funct,
    input [1:0] aluop);
    
always @(*)
    case(aluop)
        2'b00: alucontrol<= 3'b010; //add
        2'b01: alucontrol<= 3'b110; // sub
        default: case(funct)
            6'b100000: alucontrol<=3'b010; //add
            6'b100010: alucontrol<=3'b110; //sub
            6'b100100: alucontrol<=3'b000; // AND
            6'b100101: alucontrol<=3'b001; //OR
            6'b101010: alucontrol<=3'b111; //SLT
            default: alucontrol<=3'bxxx;
        endcase
    endcase
    endmodule
