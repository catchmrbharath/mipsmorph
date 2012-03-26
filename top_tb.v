// `timescale 1ns/1ns

module top_tb ();
	
	reg clk;
	reg reset;
	
	wire [15:0] writedata, dataadr;
	wire memwrite;
	
	top dut(	.clk(clk),
				.reset(reset),
				.memwrite(memwrite),
				.dataadr(dataadr),
				.writedata(writedata) );
	
	always #5 clk <= ~clk;
	
	initial begin
        #0
		reset <= 1;
		clk <= 0;
		#20 
		reset <= 0;
	end
	
	initial begin
		$dumpfile("sim.vcd");
		$dumpon;
		$dumpvars;
		
		#1000
		$dumpoff;
		$finish;
	end
	
endmodule
