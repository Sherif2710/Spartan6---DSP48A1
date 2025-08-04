//rst type (sync or async) (defsult sunc)

module ff_forinst (clk,rst,ce,d,q);
parameter width =18 ;
parameter REG=1;   //lw reg y3dy 3la ff lw msh kda a2lb combinational
parameter RSTTYPE = "sync";
input clk,rst,ce;
//ce enable of clk
input [width-1:0] d;
output reg [width-1:0] q;

generate
    if(REG)begin
    if(RSTTYPE == "sync") begin
      always @(posedge clk ) begin
   
        if(rst) //Reset Input Ports: All the resets are active high reset.
        q<=0;
        else if(ce)
        q<=d;
      end
    end
    else if(RSTTYPE == "async")begin
         always @(posedge clk or posedge rst ) begin

      if(rst) 
        q<=0;
        else if(ce)
        q<=d;
         end
    end
    end
    else if (!REG) begin
         always @(* ) begin
            q=d;
         end 
    end

endgenerate
endmodule
