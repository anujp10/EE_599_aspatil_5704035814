`timescale 1ns / 1ps

`timescale 1ns / 1ps
module multiplier
#(
    parameter   BIT_WIDTH   =   8
)
(
    input       [BIT_WIDTH -1 : 0]a,
    input       [BIT_WIDTH -1 : 0]b,
    output  reg [BIT_WIDTH -1 : 0]s
    );
    
    always @ (a, b)    begin
        {s} = a * b;
    end
endmodule