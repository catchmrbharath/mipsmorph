`define instruct_mem 7
`define size 31
module instr_tb;
    instr dut(instruction,address);
    wire [`size:0] instruction;
    reg [`instruct_mem:0] address;
    initial
    begin
        $monitor($time,,,"instruction = %d",instruction);
        #1
        address=1;
        #2;
        address=2;
        #3;
        address = 13;
        #4;
        address= 15;
    end
    endmodule

