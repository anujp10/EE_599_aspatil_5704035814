module multi_bit_adder
#(
    parameter   BIT_WIDTH   =   8,
    parameter   N   = 4
)
(
    input       [BIT_WIDTH-1:0]     a [N-1: 0],
    input       [BIT_WIDTH-1:0]     b [N-1: 0],
    output      [BIT_WIDTH-1:0]     s [N-1: 0],
    output                          cout
    );

	wire		[BIT_WIDTH:0]        c [N-1:0];


    genvar  i, j;

    generate
        for (i = 0; i < N; i++) begin : mult_gen
           multiplier (.width (BIT_WIDTH)) mult_inst
           (
                .a(a[i]),
                .b(b[i]),
            ); 
        end
    endgenerate

    generate
    for (j = 0; j < N; j=j+2)
        for(i=0; i<BIT_WIDTH; i=i+1)    begin   :   ADD	
        	full_adder u(a[i], b[i], c[i], s[i], c[i+1]);
        end
       end
    endgenerate
endmodule