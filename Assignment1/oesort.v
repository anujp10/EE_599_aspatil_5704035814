`timescale 1 ns / 1 ps
module oesort 
#(parameter W = 8)
(
   input  [W-1:0] a,
   input  [W-1:0] b,
   output [W-1:0] x,
   output [W-1:0] y
   );

wire a_is_bigger;

   assign a_cmp_b = a>b;
   assign x = a_cmp_b ? a : b;
   assign y = a_cmp_b ? b : a;

endmodule   
   
   