module project_dsp (A , B , C , D , BCIN , CARRYIN , M , P , CARRYOUT , CARRYOUTF , CLK , OPMODE , CEA , CEB , CEC , CECARRYIN , CED , CEM , CEOPMODE , CEP , RSTA , RSTB , RSTC , RSTCARRYIN , RSTD , RSTM , RSTOPMODE , RSTP , BCOUT , PCIN , PCOUT);

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

input [17:0] A , B , D , BCIN ;
input [47:0] C , PCIN ;
input CARRYIN , CLK , CEA , CEB , CEC ,CECARRYIN , CED , CEM , CEOPMODE , CEP , RSTA , RSTB , RSTC , RSTCARRYIN , RSTD , RSTM , RSTOPMODE , RSTP  ;
output [35:0] M ;
output CARRYOUTF , CARRYOUT ; 
input [7:0] OPMODE ;
output [17:0] BCOUT  ;
output [47:0] PCOUT,P ;


wire [17:0] D_from_mux  , B0_from_mux , A0_from_mux , Pre_Add_Sub , Pre_Add_Sub_from_mux , A1_from_mux, B1_from_mux ;
wire [47:0] C_from_mux , concatenated , post_Add_Sub , P_from_mux ; 
wire[35:0] mult_out , mult_out_from_mux ;
reg [17:0] data_b;
wire CYI_from_mux , cout , CYO_from_mux;
reg carryin;
wire [7:0] OPMODE_from_mux;
reg [47:0] X_out ,  Z_out; 

//op regs
ff_and_mux #(.ENable_ff(OPMODEREG) ,.SYN_OR_ASN(RSTTYPE) ,.WIDTH(8)) op (OPMODE ,CLK, CEOPMODE , RSTOPMODE , OPMODE_from_mux );


always @(*) begin
case (B_INPUT)
"DIRECT" : data_b = B ;
"CASCADE" : data_b = BCIN ;
default : data_b = 0;
endcase
end
//stg 1
ff_and_mux #(.ENable_ff(DREG) ,.SYN_OR_ASN(RSTTYPE) ,.WIDTH(18)) m1 (D ,CLK, CED , RSTD , D_from_mux );
ff_and_mux # (.ENable_ff(B0REG) ,.SYN_OR_ASN(RSTTYPE) ,.WIDTH(18)) m2 (data_b ,CLK, CEB , RSTB , B0_from_mux);
ff_and_mux # (.ENable_ff(A0REG) ,.SYN_OR_ASN(RSTTYPE) ,.WIDTH(18)) m3 (A ,CLK, CEA , RSTA , A0_from_mux);
ff_and_mux # (.ENable_ff(CREG) ,.SYN_OR_ASN(RSTTYPE) ,.WIDTH(48)) m4 (C ,CLK, CEC , RSTC ,C_from_mux);

//stg 2
 add_sub #(.WIDTH_2(18),.FULLADDER("OFF")) pre (D_from_mux , B0_from_mux , Pre_Add_Sub , OPMODE_from_mux[6]);
 assign Pre_Add_Sub_from_mux = (OPMODE_from_mux[4]) ? Pre_Add_Sub : B0_from_mux ;

//stg 3
ff_and_mux #(.ENable_ff(B1REG),.SYN_OR_ASN(RSTTYPE),.WIDTH(18)) m5 (Pre_Add_Sub_from_mux , CLK , CEB , RSTB ,B1_from_mux );
ff_and_mux # (.ENable_ff(A1REG) ,.SYN_OR_ASN(RSTTYPE) ,.WIDTH(18)) m6 (A0_from_mux ,CLK, CEA , RSTA , A1_from_mux);

 //stg 4
 assign mult_out = A1_from_mux * B1_from_mux;
 //wires
 assign concatenated = {D_from_mux[11:0] , A1_from_mux[17:0] , B1_from_mux[17:0]} ;
 assign BCOUT = B1_from_mux ;

//stg 5
ff_and_mux #(.ENable_ff(MREG),.SYN_OR_ASN(RSTTYPE),.WIDTH(36)) m7 (mult_out , CLK , CEM , RSTM , mult_out_from_mux);
assign  M = mult_out_from_mux ;
always @(*) begin
	case (CARRYINSEL)
     "CARRYIN" : carryin=CARRYIN;
     "OPMODE5" : carryin=OPMODE_from_mux[5];
     default : carryin=0;

	endcase
end
ff_and_mux # (.ENable_ff(CARRYINREG),.SYN_OR_ASN(RSTTYPE),.WIDTH(1)) m8 (carryin , CLK , CECARRYIN , RSTCARRYIN , CYI_from_mux);

//stg 6

always @(*) begin
    case (OPMODE_from_mux[1:0])
    2'b00 : X_out = 0;
    2'b01 : X_out = mult_out_from_mux ;
    2'b10 : X_out = PCOUT ;
    2'b11 : X_out = concatenated ;

    endcase
end
always @(*) begin
    case (OPMODE_from_mux[3:2])
    2'b00 : Z_out = 0;
    2'b01 : Z_out = PCIN ;
    2'b10 : Z_out = PCOUT ;
    2'b11 : Z_out = C_from_mux ;

    endcase
end


//stg 7
 add_sub #(.WIDTH_2(48),.FULLADDER("ON")) post (Z_out,X_out,post_Add_Sub,OPMODE_from_mux[7], CYI_from_mux , cout );
 ff_and_mux #(.ENable_ff(CARRYOUTREG),.SYN_OR_ASN(RSTTYPE),.WIDTH(1)) m9 (cout , CLK, CECARRYIN , RSTCARRYIN , CYO_from_mux  );
assign CARRYOUT = CYO_from_mux ;
assign CARRYOUTF = CYO_from_mux ;
//stg 8
 ff_and_mux #(.ENable_ff(PREG),.SYN_OR_ASN(RSTTYPE),.WIDTH(48)) m10 (post_Add_Sub , CLK, CEP , RSTP , P_from_mux );
assign PCOUT = P_from_mux;
assign P = P_from_mux;

endmodule


