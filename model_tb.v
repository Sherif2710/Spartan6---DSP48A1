module DSP48A1_tb();

reg clk,CARRYIN,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP;
reg [17:0] A,B,D,BCIN;
reg [47:0] C,PCIN;
reg [7:0] OPMODE;
wire  CARRYOUT,CARRYOUTF;
wire   [47:0] P,PCOUT;
wire   [17:0] BCOUT;
wire   [35:0] M; 
reg   CARRYOUT_EX,CARRYOUTF_EX;
reg    [47:0] P_EX,PCOUT_EX;
reg    [17:0] BCOUT_EX;
reg    [35:0] M_EX;
integer i;  
//
parameter A0REG=0;
DSP48A1 m1 ( A,B,D,BCIN, C,clk,CARRYIN, PCIN,OPMODE,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE, CEA ,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,BCOUT,P,PCOUT,M,CARRYOUT, CARRYOUTF) ;

initial begin  
    clk=0;  
    forever   
        #1 clk=~clk;  
    end 
        initial begin
    {RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP}=8'b11111111; 
CEA=$random;
CEB=$random;
CEC=$random;
CECARRYIN=$random;
CED=$random;
CEM=$random;
CEOPMODE=$random;
CEP=$random;
CARRYIN=$random;
A=$random;
B=$random;
D=$random;
BCIN=$random;
C=$random;
PCIN=$random;
 OPMODE=$random;
  {CARRYOUT_EX,CARRYOUTF_EX,P_EX,PCOUT_EX,BCOUT_EX,M_EX}=0;
 @(negedge clk);  
 if((CARRYOUT!=CARRYOUT_EX)||(CARRYOUTF!=CARRYOUTF_EX)||(P!=P_EX)||(PCOUT!=PCOUT_EX)||(BCOUT!=BCOUT_EX)||(M!=M_EX))begin
    $display("Error - reset  is incorrect");  
        $stop;  
   end 
 //path1
 {RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP}=0;
{CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP}=8'b11111111;
A = 20 ;
B = 10;
 C = 350;
 D = 25;
  OPMODE = 8'b11011101;
  BCIN=$random;
CARRYIN=$random;
PCIN=$random;
CARRYOUT_EX =0;
CARRYOUTF_EX=0;
P_EX=48'h32;
PCOUT_EX=48'h32;
BCOUT_EX= 18'hf;
M_EX= 36'h12c;
repeat(4)@(negedge clk);
if((CARRYOUT!=CARRYOUT_EX)||(CARRYOUTF!=CARRYOUTF_EX)||(P!=P_EX)||(PCOUT!=PCOUT_EX)||(BCOUT!=BCOUT_EX)||(M!=M_EX))begin
    $display("Error - path1  is incorrect");  
        $stop;  
   end 
   //path2
A = 20 ;
B = 10;
 C = 350;
 D = 25;
 OPMODE = 8'b00010000;
BCIN=$random;
CARRYIN=$random;
PCIN=$random;
CARRYOUT_EX =0;
CARRYOUTF_EX=0;
P_EX=48'h0;
PCOUT_EX=48'h0;
BCOUT_EX= 18'h23;
M_EX= 36'h2bc;
repeat(3)@(negedge clk);
if((CARRYOUT!=CARRYOUT_EX)||(CARRYOUTF!=CARRYOUTF_EX)||(P!=P_EX)||(PCOUT!=PCOUT_EX)||(BCOUT!=BCOUT_EX)||(M!=M_EX))begin
    $display("Error - path2  is incorrect");  
        $stop;  
   end
   //path3 
A = 20 ;
B = 10;
 C = 350;
 D = 25;
 OPMODE = 8'b00001010;
BCIN=$random;
CARRYIN=$random;
PCIN=$random;
CARRYOUT_EX =0;
CARRYOUTF_EX=0;
P_EX=48'h0;
PCOUT_EX=48'h0;
BCOUT_EX= 18'ha;
M_EX= 36'hc8;
repeat(3)@(negedge clk);
if((CARRYOUT!=CARRYOUT_EX)||(CARRYOUTF!=CARRYOUTF_EX)||(P!=P_EX)||(PCOUT!=PCOUT_EX)||(BCOUT!=BCOUT_EX)||(M!=M_EX))begin
    $display("Error - path3  is incorrect");  
        $stop;  
   end 
//path4
A = 5 ;
B = 6;
 C = 350;
 D = 25;
 OPMODE = 8'b10100111;
PCIN=3000;
BCIN=$random;
CARRYIN=$random;
CARRYOUT_EX =1;
CARRYOUTF_EX=1;
P_EX=48'hfe6fffec0bb1;
PCOUT_EX=48'hfe6fffec0bb1;
BCOUT_EX= 18'h6;
M_EX= 36'h1e;
repeat(3)@(negedge clk);
if((CARRYOUT!=CARRYOUT_EX)||(CARRYOUTF!=CARRYOUTF_EX)||(P!=P_EX)||(PCOUT!=PCOUT_EX)||(BCOUT!=BCOUT_EX)||(M!=M_EX))begin
    $display("Error - path4  is incorrect");  
        $stop;  
   end 
  $stop;  
   end 

initial begin 
$monitor(" A: %b,B: %b,C: %b,D: %b,CARRYIN: %b, PCIN: %b,BCIN:%b ,OPMODE: %b,{CARRYOUT,CARRYOUTF,P,PCOUT,BCOUT,M}=%b,{CARRYOUT_EX,CARRYOUTF_EX,P_EX,PCOUT_EX,BCOUT_EX,M_EX}=%b",A,B,C,D,CARRYIN,PCIN,BCIN,OPMODE,{CARRYOUT,CARRYOUTF,P,PCOUT,BCOUT,M},{CARRYOUT_EX,CARRYOUTF_EX,P_EX,PCOUT_EX,BCOUT_EX,M_EX}); 
end
endmodule 
