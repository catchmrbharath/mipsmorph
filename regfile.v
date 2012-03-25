`define adwidth 5
`define datawidth 32
module regfile #(parameter MEM=32)
(
    output reg [`datawidth-1:0] rd1,rd2,
    input [`adwidth-1:0] a1,a2,a3,
    input [`datawidth-1:0] wr,
    input clk,wrenable);

    reg[`datawidth-1:0] registers[MEM-1:0];
    initial
    begin
        registers[0]=0;
        registers[1]=0;
        registers[2]=0;
        registers[3]=0;
    end
    always @ (negedge clk)
    begin
        rd1 = registers[a1];
        rd2 = registers[a2];
        $display($time,,,,"wrenable = %d registers[2] = %d a1 = %d",wrenable,rd1,a1);
    end
    always @ (posedge clk)
    begin
        #1;
        if(wrenable) 
			registers[a3]<=wr;
        else
            registers[a3]<=registers[a3];
    end
endmodule

        
