module aludec(
    output reg[2:0] alucontrol,
    input [2:0] funct,
    input [1:0] aluop);
    
always @(*)
    case(aluop)
        2'b00: alucontrol<= 3'b010; //add
        2'b01: alucontrol<= 3'b110; // sub
        default: case(funct)
            3'b000: alucontrol<=3'b010; //add
            3'b010: alucontrol<=3'b110; //sub
            3'b100: alucontrol<=3'b000; // AND
            3'b101: alucontrol<=3'b001; //OR
            default: alucontrol<=3'bxxx;
        endcase
    endcase
    endmodule
