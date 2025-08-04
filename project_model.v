module DSP48A1( A,B,D,BCIN, C,clk,CARRYIN, PCIN,OPMODE,rstA ,rstB,rstM,rstP,rstC,rstD,rstCARRYIN,rstSTOPMODE, CEA ,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,BCOUT,P,PCOUT,M,CARRYOUT, CARRYOUTF);
parameter A0REG=0;
parameter A1REG=1; 
parameter B0REG=0;
parameter B1REG=1;
parameter CREG=1;
parameter DREG=1;
parameter MREG=1;
parameter PREG=1; 
parameter CARRYINREG=1;
parameter CARRYOUTREG=1;
parameter OPMODEREG=1;
parameter CARRYINSEL="OPMODE5";
parameter B_INPUT = "direct";
parameter RSTTYPE= "sync" ;


input [17:0] A,B,D,BCIN;
input [47:0] C, PCIN;
input [7:0]OPMODE;
input rstA ,rstB,rstM,rstP,rstC,rstD,rstCARRYIN,rstSTOPMODE;
input CEA ,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
input clk ,CARRYIN;
output [17:0]BCOUT;
output [47:0]P,PCOUT;
output [35:0]M;
output CARRYOUT;
output CARRYOUTF;

wire [17:0] D_OUT,A0_OUT,A1_OUT,B0_OUT,B1_OUT;
reg  [17:0] B_IN;
wire [47:0] C_OUT,D_A_B_CONC;
reg [47:0] post_add_sub,X_OUT,Z_OUT;
reg [17:0] pre_add_sub;
reg [17:0] B1_IN;
reg [35:0] M_IN;
wire [35:0] M_OUT;
wire [7:0]OPMODE_OUT;
reg CYI_IN;
reg CYO_IN;
wire CIN;

always @(*) begin
    if(B_INPUT == "direct")
    B_IN=B;
    else  if(B_INPUT == "CASCADE")
      B_IN=BCIN;
      else 
         B_IN=0;
end
 ff_forinst #(.width(18),.REG(A0REG),.RSTTYPE(RSTTYPE)) a0_reg(clk,rstA,CEA,A,A0_OUT); //a
  ff_forinst #(.width(18),.REG(B0REG),.RSTTYPE(RSTTYPE)) b0_reg (clk,rstB,CEB, B_IN,B0_OUT); //b
 ff_forinst #(.width(48),.REG(CREG),.RSTTYPE(RSTTYPE)) c0_reg(clk,rstC,CEC,C,C_OUT);//c
 ff_forinst #(.width(18),.REG(DREG),.RSTTYPE(RSTTYPE)) d0_reg(clk,rstD,CED,D,D_OUT);//d
  ff_forinst #(.width(8),.REG(OPMODEREG),.RSTTYPE(RSTTYPE)) op_mode(clk,rstSTOPMODE,CEOPMODE,OPMODE,OPMODE_OUT);//opmode



always @(*) begin
    case(OPMODE_OUT[6])

0:pre_add_sub=D_OUT+B0_OUT;
1:pre_add_sub=D_OUT-B0_OUT;
    endcase
end

always @(*) begin
    case(OPMODE_OUT[4])

0:B1_IN= B0_OUT;
1:B1_IN=pre_add_sub;
    endcase
end
ff_forinst #(.width(18),.REG(A1REG),.RSTTYPE(RSTTYPE)) a1_reg(clk,rstA,CEA,A0_OUT,A1_OUT); 
  ff_forinst #(.width(18),.REG(B1REG),.RSTTYPE(RSTTYPE)) b1_reg (clk,rstB,CEB, B1_IN,B1_OUT); 
  assign BCOUT=B1_OUT;
always @(*) begin
    M_IN=A1_OUT *B1_OUT;
end
 ff_forinst #(.width(36),.REG(MREG),.RSTTYPE(RSTTYPE)) m_reg(clk,rstM,CEM, M_IN,M_OUT);
 assign M=M_OUT;

always@(*)begin
if(CARRYINSEL=="OPMODE5")
CYI_IN=OPMODE_OUT[5];
else if(CARRYINSEL=="CARRYIN")
CYI_IN=CARRYIN;
else
CYI_IN=0;
end
ff_forinst #(.width(1),.REG(CARRYINREG),.RSTTYPE(RSTTYPE)) cyi_in(clk,rstCARRYIN,CECARRYIN, CYI_IN,CIN);
assign D_A_B_CONC={D_OUT[11:0],A1_OUT[17:0],B1_OUT[17:0]};
//X
always @(*) begin
case(OPMODE_OUT[1:0])
2'b00:X_OUT=0;
2'b01:X_OUT=M_OUT;
2'b10:X_OUT=P;
2'b11:X_OUT=D_A_B_CONC;
endcase
end
//Z
always @(*) begin
case(OPMODE_OUT[3:2])
2'b00:Z_OUT=0;
2'b01:Z_OUT=PCIN ;
2'b10:Z_OUT=P;
2'b11:Z_OUT=C_OUT;

endcase
end

always @(*) begin
    case(OPMODE_OUT[7])
//mtnsash cout_post_add_sub
0:{ CYO_IN,post_add_sub}=X_OUT+Z_OUT+CIN;
1:{ CYO_IN,post_add_sub}=Z_OUT-(X_OUT+CIN);
    endcase
end

//CYO_IN = HWA AL CARRY OUT BTA3Y MN AL post_add_sub

ff_forinst #(.width(1),.REG(CARRYOUTREG),.RSTTYPE(RSTTYPE)) CYOO(clk,rstCARRYIN,CECARRYIN, CYO_IN, CARRYOUT);
assign  CARRYOUTF= CARRYOUT;

ff_forinst #(.width(48),.REG(PREG),.RSTTYPE(RSTTYPE)) FINAL(clk,rstP,CEP, post_add_sub, P);
assign  PCOUT= P;


endmodule