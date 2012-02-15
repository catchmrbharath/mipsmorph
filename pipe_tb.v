// `timescale 1ns/1ns

module pipe_tb ();
	
	reg clk;
	reg reset;
	
	mipsPipe dut(	.clk(clk),
					.reset(reset) );
	
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
