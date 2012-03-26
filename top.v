module top (
	output [15:0] writedata, 
	output [15:0] dataadr,
	output memwrite,
	input clk,
	input reset,
    input [3:0] swin,
	output [7:0] ledout);
	
	wire [15:0]  instr, readdata;
    wire [7:0] pc;
	 wire [2:0] switchin;
    wire [15:0] switchout;
    wire [5:0] controlSig;
	 assign switchin = swin[2:0];
	 assign ledout = (swin[3]) ? switchout[7:0]:{2'd0,controlSig};
   
	
	mips mips(  .clk(clk),
				.reset(reset),
				.pc(pc),
				.instr(instr),
				.memwrite(memwrite),
				.aluout(dataadr),
				.writedata(writedata),
				.readdata(readdata),
                .switchin(switchin),
                .switchout(switchout),
                .controlSig(controlSig));
				
	instr #(256) imem( .address(pc[7:0]),
				.out(instr) );
	
	DataMemory #(128) dmem(	.rd(readdata),
	 					.wd(writedata),
	 					.address(dataadr),
						.we(memwrite),
						.clk(clk) );
	
endmodule
