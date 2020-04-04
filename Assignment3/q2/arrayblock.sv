`timescale  1ns / 1ps

module arrayblock #(
    parameter width = 8
)
(
    input      clk,
    input      reset,
    input      switch, 
    input      [width-1:0]     in1,
    input      [width-1:0]     in2,
    output      reg      [width-1:0]     out1,
    output      reg      [width-1:0]     out2,
    output      reg      [width-1:0]     out3
);


always @(posedge clk or negedge reset) 

begin

            out1        <= 		in1;
            out2        <= 		in2;
            out3        <= 		(switch ? 0 : ((in1 * in2) + out3));

end

endmodule