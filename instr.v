`define size 31
module instr #(parameter MEM=18)
(
    output [`size:0] out,
    input [5:0] address );

    reg [`size:0] mem[MEM-1:0];
    initial
    begin
        $readmemh("instruction.txt",mem);
		#5
		$display("INSTRUCTION MEMORY");
		$display("%h", mem[0]);
    end
    assign out= mem[address];
endmodule
