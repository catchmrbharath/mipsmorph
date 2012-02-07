`define size 31
module instr #(parameter MEM=64)
(
    output[`size:0] out,
    input[`size:0] address,
    input clk);
    reg [`size:0] mem[MEM-1:0];
    initial
    begin
        $readmemh("instruction.txt",mem);
    end
    assign instruction = mem[address];
endmodule
