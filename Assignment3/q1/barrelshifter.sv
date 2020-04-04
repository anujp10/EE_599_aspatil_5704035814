`timescale 	1ns/1ps

module barrel_shifter # (
    parameter N = 64,
	parameter Width = 8,
    parameter Rotation_wid = $clog2(N)
)
(	
	input           [Rotation_wid-1:0]      rotate,
	input			[Width-1:0]    input_to_barrel_shifter     [0:N-1],
    input           [Rotation_wid-1:0]      barrel_rotate,
	output 		    [Width-1:0]    output_from_barrel_shifter  [0:N-1],
	input 			clk,
	input 			reset
);

function integer clog2;
   
   input integer val;
   
   begin
     val = val-1;
     for (clog2=0; val>0; clog2=clog2+1)
       val = val>>1;
   end
   
endfunction

parameter levels = clog2(N);

wire	[Width-1:0]		barrel_out	  [0:levels-1][0:N-1];
wire	[Width-1:0]		barrel_inp1	  [0:levels-1][0:N-1];
wire	[Width-1:0]		barrel_inp2	  [0:levels-1][0:N-1];

assign output_from_barrel_shifter	=	barrel_out[levels-1];
assign barrel_inp1[0]   =   input_to_barrel_shifter;

genvar i, j;
generate
    
	for (i=1; i<levels; i=i+1) 
	begin
		assign barrel_inp1[i] = barrel_out[i-1];
    end
	
	for (i=0; i<levels; i=i+1) 
	begin
        for (j=0; j<levels; j=j+1) 
		begin
            assign barrel_inp2[i][j] = barrel_inp1[i][(N + j-(2**i))%N];
        end
    end
	
	for (i=0; i<levels; i=i+1)
	begin
		mux # (
            .Num  	(N),
			.Wid 	(Width)
		)
		(
			.clk	(clk),
			.first_input		(barrel_inp1[i]),
			.second_input    	(barrel_inp2[i]),
            .select        (select_barrel_input[i][i]),
			.outputmux		    (barrel_out[i])
		);
	end
endgenerate
	
	
reg     [Rotation_wid-1:0]        select_barrel_input 	[0:levels-1];

always @(*) 
begin
    select_barrel_input[0] = rotate;
end

generate
    for (i=1; i<levels; i=i+1) 
	begin
        always@(posedge clk or negedge reset) 
		begin
            if (!reset) 
                select_barrel_input[i] <= 0;
            else
                select_barrel_input[i] <= select_barrel_input[i-1];
        end
    end
endgenerate

endmodule	