module branchmuxsel( 
    input branchD,
    input branchCorrect,
    input brbitD,
    output reg [1:0] brmuxsel;
)
always @(branchCorrectE or branchD or brbitD)
begin
   if (~branchD)
       brmuxsel = 2'd0;
   else begin
       if ( branchCorrect)
           brmuxsel = 2'd0;
           else begin
            if(brbitD)
                brmuxsel = 2'd2;
            else
                brmuxsel = 2'd1;
        end
    end
    end
    endmodule
