`define instruct_mem 7
`define size 31
module instr(
    output[`size:0] instruction,
    input[`instruct_mem:0] address);
    reg [`size:0] mem[31:0];
    initial
    begin
        $readmemh("instruction.txt",mem);
    end
    assign instruction = mem[address];
endmodule
