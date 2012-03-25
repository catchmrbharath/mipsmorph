module maindec (
	output memtoreg,
	output memwrite,
	output branch,
	output alusrc,
	output regdst,
	output regwrite,
	output jump,
	output [1:0] aluop,
	input [3:0] op);
	
	reg [7:0] controls;
	
	assign { regwrite, alusrc, branch, memwrite, memtoreg, jump, aluop } = controls;
	
	always @ (*)
		case(op)
			4'b0000: controls <= 9'b10000010; // R-Type
			4'b0100: controls <= 9'b11000000; // ADDI
			4'b1011: controls <= 9'b11001000; // LW
			4'b1111: controls <= 9'b01010000; // SW
			4'b1000: controls <= 9'b00100001; // BEQ
			4'b0010: controls <= 9'b00000100; // J
			default: controls <= 9'bxxxxxxxxx; // default case
		endcase
endmodule