`timescale 1ns / 1ps

module systolic_arr # (
    parameter data_w = 8,
    parameter matrix_w  = 8
)
(
    input           clk,
    input           reset,
    input           [data_w - 1:0] input1 [0:matrix_w - 1][0:matrix_w - 1],
    input           [data_w - 1:0] input2 [0:matrix_w - 1][0:matrix_w - 1],
    input           start,
    input           ack,
    output          [data_w - 1:0] output3 [0:matrix_w - 1][0:matrix_w - 1],
    output          rdy,
    output          valid
);

function integer log_2;
   
   input integer value;
   
   begin

     value = value-1;
     for (log_2 = 0; value > 0; log_2 = log_2 + 1)
       value = value >> 1;

   end
   
endfunction

parameter count_w = log_2(matrix_w);
parameter INIT = 2'b00, MULT = 2'b01, DONE = 2'b10; 

reg [1:0] state;
reg [count_w-1:0] idx;
wire [matrix_w-1:0] opDone [0:matrix_w-1];
wire [matrix_w-1:0] restart [0:matrix_w-1];
wire [count_w-1:0] count [0:matrix_w-1];

assign restart[0][0] = start && rdy; 
assign opDone[0][0] = ((state == DONE) || (count[0] == matrix_w));

assign count[0] = idx;

genvar i, j;
generate
    for (i=1; i<matrix_w; i=i+1) 
	begin
        D_FF rd_inst (.clk(clk), .din(opDone[0][i-1]), .qout(opDone[0][i])); 
        D_FF rr_inst (.clk(clk), .din(restart[0][i-1]), .qout(restart[0][i]));
        D_FF #(count_w) count_d (.clk(clk), .din(count[i-1]), .qout(count[i]));
    end
    for (i=1; i<matrix_w; i=i+1) 
	begin
        for (j=0; j<matrix_w; j=j+1) 
		begin
            D_FF cr_inst (.clk(clk), .din(restart[i-1][j]), .qout(restart[i][j]));
            D_FF cd_inst (.clk(clk), .din(opDone[i-1][j]), .qout(opDone[i][j]));
        end
    end
endgenerate

assign valid = (opDone[matrix_w-1][matrix_w-1]) || (state==DONE); 
assign rdy = (state != MULT);

always @(posedge clk) 
begin
		case(state)
            INIT:
            begin
                if (start) begin
                    state   <= MULT;
                    idx     <= idx + 1;
                end        
                else
                    idx     <= 0;
            end
            MULT:
            begin
                if (opDone[matrix_w-1][matrix_w-1])
                    state   <= DONE; 
                if (start)
                    idx     <= 1;
                else if (idx < matrix_w)
                    idx     <= idx + 1;
            end
            DONE:
            begin
                idx <= 0;
                if (start && ack)
                    state   <= MULT;
                else if (ack)
                    state   <= INIT;
            end
        endcase
end

wire [matrix_w:0] ipValid [0:matrix_w-1];
wire [data_w-1:0] inputarray_1 [0:matrix_w-1][0:matrix_w-1];
wire [data_w-1:0] inputarray_2 [0:matrix_w-1][0:matrix_w-1];
wire [data_w-1:0] outputarray_1 [0:matrix_w-1][0:matrix_w-1];
wire [data_w-1:0] outputarray_2 [0:matrix_w-1][0:matrix_w-1];

assign ipValid[0][0] = ((state==MULT) && (count[0] < matrix_w)) || (start);
assign inputarray_1[0][0] = input1[0][count[0]];
assign inputarray_2[0][0] = input2[count[0]][0];

generate
    for (i=1; i<matrix_w; i=i+1) 
	begin
        D_FF vldFFInst (.clk(clk), .din(ipValid[i-1][0]), .qout(ipValid[i][0]));
        assign inputarray_1[i][0] = input1[i][count[i]];
        assign inputarray_2[0][i] = input2[count[i]][i];
    end
    for (i=0; i<matrix_w; i=i+1) 
	begin
        for (j=1; j<matrix_w; j=j+1) 
		begin
            assign inputarray_1[i][j] = outputarray_1[i][j-1];
        end
    end
    for (i=1; i<matrix_w; i=i+1) 
	begin
        for (j=0; j<matrix_w; j=j+1) 
		begin
            assign inputarray_2[i][j] = outputarray_2[i-1][j];
        end
    end
    
    for (i=0; i<matrix_w; i=i+1) 
	begin
        for (j=0; j<matrix_w; j=j+1) 
		begin
            arrayblock # (data_w) 
            (
                .clk(clk),
                .reset(reset),
                .restart(restart[i][j]),
                .input1(inputarray_1[i][j]),
                .input2(inputarray_2[i][j]),
                .output1(outputarray_1[i][j]),
                .output2(outputarray_2[i][j]),
                .output3(output3[i][j])
            );
        end
    end
endgenerate
endmodule