`timescale 1 ns / 1 ps
module oesort_N
#(parameter W = 8,
            N = 32)
(
   input  [W-1:0] inp [0:N-1],
   output [W-1:0] out [0:N-1]
);   

wire [W-1:0] connect [0:N*(N+1)-1];

genvar i,j;

generate
   for (i=0; i<N; i=i+1)
   begin
      if (i[0]==1'b0)
      begin 
         for (j=0; j<N; j=j+2)
            oesort oesort_i (.a(connect[i*N+j]),.b(connect[i*N+j+1]),.x(connect[i*N+j+N]),.y(connect[i*N+j+N+1]));            
      end
      else
      begin
         assign connect[i*N+N]=connect[i*N];
         for (j=1; j<N-2; j=j+2)
           oesort oesort_i (.a(connect[i*N+j]),.b(connect[i*N+j+1]),.x(connect[i*N+j+N]),.y(connect[i*N+j+N+1]));            
         assign connect[i*N+N+N-1] = connect[i*N+N-1];
      end
   end
   
   for (j=0; j<N; j=j+1)
   begin
      assign connect[j] = inp[j];
      assign out[j] = connect[N*N+j];
   end
   
endgenerate   
   
endmodule
