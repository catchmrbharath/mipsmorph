`define size 31
module branchMem #(parameter MEM=32)
(
    output out,
    input [5:0] address,
    input wd,we,clk);

    reg [MEM-1:0]  mem;
    initial begin
        mem[0]=0;
        mem[1]=0;
        mem[2]=0;
        mem[3]=0;
        mem[4]=0;
        mem[5]=0;
        mem[6]=0;
        mem[7]=0;
        mem[8]=0;
        mem[9]=0;
        mem[10]=0;
        mem[11]=0;
        mem[12]=0;
        mem[13]=0;
        mem[14]=0;
        mem[15]=0;
        mem[16]=0;
        end

    assign out= mem[address];
    always @(posedge clk)
        if(we)
            mem[address] = wd;
        else begin
        end
    
endmodule
