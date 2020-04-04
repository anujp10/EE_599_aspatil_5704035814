module barrel_tb;

parameter WIDTH = 8;
parameter N = 32;

function integer log_2;
    input [31:0] val;
    begin
        val = val - 1;
        for (log_2 = 0; val > 0; log_2 = log_2 + 1) begin
            val = val >> 1;
        end
    end
endfunction

parameter SEL = log_2(N);

reg clk, reset;

reg [WIDTH-1:0] inp [N-1:0];
reg [WIDTH-1:0] out [N-1:0];
reg [SEL-1:0]  select;

reg dataValid;
reg tbRdy;

reg [WIDTH-1:0] outreg [N-1:0];

wire dpRdy;
wire opValid;

integer i,j;

initial begin
    clk = 0;
    forever begin
        #5;
        clk = ~clk;
    end
end

event reset_done_trig;
initial begin
    reset = 1;
    @(negedge clk);
    reset = 0;
    #50;
    reset = 1;
    -> reset_done_trig;
end


event comp_start;
event sim_terminate;
initial begin
    for (i=0; i<N; i=i+1) 
    begin
        inp[i]  = i;
    end
    @(reset_done_trig);
    @(negedge clk);
    dataValid = 1;
    select = 11;
    while(!dpRdy)
        @(negedge clk);
    -> comp_start;
    @(negedge clk);
    dataValid = 0;
end

initial begin
    tbRdy = 0;
    @(reset_done_trig);
    @(comp_start);
    tbRdy = 1;
    while(!opValid)
        @(negedge clk);
    @(negedge clk);
    tbRdy = 0;
    -> sim_terminate;

end

initial begin
    @(sim_terminate);
    #10 $finish;
end


always @(posedge clk) begin
        if (tbRdy && opValid) begin
            outreg <= out;
        end
end

barrel #(
    .N      (N),
    .WIDTH  (WIDTH),
    .Rotation_wid      (SEL)
) DUT 
(
    .rot        (sel),
    .ip1        (ip),
    .start      (dataValid),
    .op         (out),
    .clk        (clk),
    .rst        (reset)
);



endmodule