module top_tb ();
	
	reg clk;
	reg reset;
	
	wire [31:0] writedata, dataadr;
	wire memwrite;
	
	top dut(	.clk(clk),
				.reset(reset),
				.memwrite(memwrite),
				.dataadr(dataadr),
				.writedata(writedata) );
	
	always #5 clk <= ~clk;
	
	initial begin
		reset <= 1;
		clk <= 0;
		#25 
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