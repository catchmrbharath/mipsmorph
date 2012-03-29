module branchMem #(parameter MEM=32)
(
    output out,
    input [5:0] addrD,
    input [5:0] addrE,
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
        mem[17]=0;
        mem[18]=0;
        mem[19]=0;
        mem[20]=0;
        mem[21]=0;
        end

    assign out= mem[addrD];
    always @(posedge clk)
        if(we)
            mem[addrE] = wd;
        else begin
        end
    
endmodule
