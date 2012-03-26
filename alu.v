module alu(
    output reg [15:0] ALUout,
    output reg zeroFlag,
    input[15:0] srcA,srcB,
    input[2:0] aluControl);

always @(*)
begin
    case(aluControl)
        3'b010: ALUout=srcB+srcA;
        3'b110: ALUout=srcA-srcB;
        3'b000: ALUout=srcB & srcA;
        3'b001: ALUout=srcA | srcB;
        3'b111: ALUout= (srcA<srcB) ? 1:0;
        default: ALUout = 0; //TODO:think of something else here
    endcase
    if(ALUout==0)
        zeroFlag=1;
    else
        zeroFlag=0;
end
endmodule



