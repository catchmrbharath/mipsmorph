`define size 16
module instr #(parameter MEM=18)
(
    output [`size-1:0] out,
    input [7:0] address );

    reg [8-1:0] mem[MEM-1:0];
    initial
    begin
        $readmemb("fib.txt",mem);
		#5
		$display("INSTRUCTION MEMORY");
        #5
		$display("%b", mem[0]);
        #5
        $display("%b", mem[1]);
    end
    assign out= {mem[address],mem[address+1]};
endmodule
