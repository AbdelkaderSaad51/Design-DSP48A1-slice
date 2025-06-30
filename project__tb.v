module project_dsp_tb ();
parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;
parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1;
parameter PREG = 1;
parameter CARRYINREG =1;
parameter CARRYOUTREG =1;
parameter OPMODEREG =1;
parameter CARRYINSEL = "OPMODE5" ;
parameter B_INPUT = "DIRECT" ;
parameter RSTTYPE = "SYNC" ;

reg [17:0] A , B , D , BCIN ;
reg [47:0] C , PCIN ;
reg CARRYIN , CLK , CEA , CEB , CEC ,CECARRYIN , CED , CEM , CEOPMODE , CEP , RSTA , RSTB , RSTC , RSTCARRYIN , RSTD , RSTM , RSTOPMODE , RSTP  ;
reg [7:0] OPMODE ;

wire [35:0] M ;
wire CARRYOUTF , CARRYOUT ; 
wire [17:0] BCOUT  ;
wire [47:0] PCOUT,P ;

project_dsp dut (A , B , C , D , BCIN , CARRYIN , M , P , CARRYOUT , CARRYOUTF , CLK , OPMODE , CEA , CEB , CEC , CECARRYIN , CED , CEM , CEOPMODE , CEP , RSTA , RSTB , RSTC , RSTCARRYIN , RSTD , RSTM , RSTOPMODE , RSTP , BCOUT , PCIN , PCOUT);


initial begin
	
	CLK=0;
	forever
	#1 CLK=~CLK;

end



initial begin
	
RSTA =1;
RSTB =1;
RSTC =1;
RSTCARRYIN =1;
RSTD =1;
RSTM =1;
RSTOPMODE =1; 
RSTP =1;
A=0; 
B=0 ;
C=0 ;
D =0;
BCIN =0;
CARRYIN =0;
OPMODE =8'b1011_1101;
CEA =1;
CEB =1;
CEC =1;
CECARRYIN =1;
CED =1;
CEM =1;
CEOPMODE=1;
CEP=1;
PCIN =0;
#50;
RSTA =0;
RSTB =0;
RSTC =0;
RSTCARRYIN =0;
RSTD =0;
RSTM =0;
RSTOPMODE =0; 
RSTP =0;
A=18'd4; 
B=18'd10 ;
C=48'd150 ;
D =18'd15;
BCIN =0;
CARRYIN =0;
OPMODE =8'b1001_1101;
CEA =1;
CEB =1;
CEC =1;
CECARRYIN =1;
CED =1;
CEM =1;
CEOPMODE=1;
CEP=1;
PCIN =0;
#50;
OPMODE=8'b0101_1010;
#50;
A=0;
D=0;
OPMODE=8'b0010_0011;

#20 $stop;









end
endmodule