`timescale 1ns / 1ps

module DFF #(
    parameter width = 1
)
(
    input clk,
    input [width-1:0] din,
    output reg [width-1:0] qout
);
    
always @(posedge clk) 

begin

            qout   <= 	din;

end

endmodule