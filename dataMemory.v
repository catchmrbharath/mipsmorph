`define datawidth 32
module DataMemory #(parameter MEM=64)
(
    output[`datawidth-1:0] RD,
    input[`datawidth-1:0] address,
    input[`datawidth-1:0] writeData,
    input writeEn
    input clk,
    input reset);
    reg[`datawidth-1:0] mem[MEM-1:0];
    assign out = mem[address];
    always @(posedge clk)
    begin
        if(writeEn)
            mem[address]=writeData;
    end



  
endmodule: DataMemory
