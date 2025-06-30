module ff_and_mux (inp , clk, clk_enable , rst , out );

parameter ENable_ff = 1;
parameter SYN_OR_ASN = "SYNC" ;
parameter WIDTH = 18 ;


input [WIDTH -1 : 0] inp ;
input clk ,clk_enable, rst ;
output [WIDTH -1 : 0] out ;
reg [WIDTH-1 : 0] out_ff;

generate
	if (SYN_OR_ASN == "SYNC")begin
	always @(posedge clk ) begin
		if (rst) begin
			out_ff <= 0; 
		end
		else if (clk_enable) begin
			out_ff <= inp;
		end
	end
end
 else if (SYN_OR_ASN == "ASYNC")begin
 	always @(posedge clk or posedge rst) begin
 		if (rst) begin
 			out_ff <= 0;
 			
 		end
 		else if (clk_enable) begin
 			out_ff <= inp ;
 		end
 	end
 end
	
endgenerate

assign out = (ENable_ff == 1)? out_ff : inp ;
endmodule

