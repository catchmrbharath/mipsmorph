`define size 31
module instr #(parameter MEM=18)
(
    output [`size:0] out,
    input [5:0] address );

    reg [`size:0] mem[MEM-1:0];
    initial
    begin
        $readmemh("instruction.txt",mem);
    end
    assign instruction = mem[address];
endmodule
