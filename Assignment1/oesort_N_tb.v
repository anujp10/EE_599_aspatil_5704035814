`timescale 1 ns / 1 ps
module oesort_N_test;

localparam W= 8;
localparam N= 32;


reg  [W-1:0] inp [0:N-1];
wire [W-1:0] out [0:N-1];

integer i;

   initial
   begin
      for (i=0; i<N; i=i+1)
        inp[i]  = N-i;
      #100;
      
      for (i=0; i<N; i=i+1)
        inp[i]  = i%(N/2);
      #100;
     
      for (i=0; i<N; i=i+1)
        inp[i]  = i;
      #100;
 
       for (i=0; i<N; i=i+1)
        inp[i]  = $random();
      #100;
     
      $stop;
   end


oesort_N
   #(
      .W (W),
      .N (N)
   )
oesort_N_0 (
      .inp(inp),
      .out(out) 
   );
   
endmodule
