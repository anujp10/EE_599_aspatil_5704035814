`timescale 	1ns/1ps

module mux #(
    parameter N = 16,
    parameter Width = 8
)
(
    input       [Width-1:0]     inp1_mux     [0:N-1],
    input       [Width-1:0]     inp2_mux     [0:N-1],
    output      reg [Width-1:0] out          [0:N-1],
    input       select,
    input       clk
);

genvar i;

generate 
	
	for(i=0;i<N;i=i+1)
	begin
	
		always@(posedge clk)
		begin
		
			if(select==1)
			begin
		
				out[i] <= inp2_mux[i];
			
			end
			else
			begin
		
				out[i] <= inp1_mux[i];
		
			end	
		
		end
	end	
	
endgenerate

endmodule