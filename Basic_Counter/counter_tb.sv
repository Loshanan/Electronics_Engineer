module counter_tb ();
    
    `timescale 1ns/1ps

    // clock generation
    logic clk;
    localparam CLK_PERIOD = 10;     // 10ns or 100MHz
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk <= ~clk;
    end

    // others
    logic rst, incr;
    localparam WIDTH = 8;
    logic [WIDTH - 1:0] cnt_out;

    counter #(.WIDTH(WIDTH)) dut (.*);

    // sim start
    initial begin
        #(CLK_PERIOD * 2);

        @(posedge clk);
        rst <= 1;

        #(CLK_PERIOD * 2)
        @(posedge clk);
        rst <= 0;
        incr <= 1;

        #(CLK_PERIOD * 4);
        @(posedge clk);
        incr <= 0;

        #(CLK_PERIOD * 4);
        @(posedge clk);
        rst <= 1;

        #(CLK_PERIOD * 4);
        $finish;
    end
endmodule