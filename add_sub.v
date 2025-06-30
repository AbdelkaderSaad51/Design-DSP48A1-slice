module add_sub (in1,in2,out,OPMODE,cin,cout);
parameter FULLADDER="ON";
parameter WIDTH_2=18;
input OPMODE,cin;
input [WIDTH_2-1:0] in1,in2;
output reg [WIDTH_2-1:0] out;
output reg cout ;
generate
if (FULLADDER=="ON") begin
		always@(*) begin
	
	if(OPMODE)
	{cout,out}=in1-(in2+cin);
	else 
	{cout,out}=in1+in2+cin;
	
    end
end
	
	else if (FULLADDER=="OFF") begin
always@(*) begin
	
	if(OPMODE)
	out=in1-in2;
	else 
	out=in1+in2;
	
   end
end
endgenerate
endmodule 
