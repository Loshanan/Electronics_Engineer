module state_machine_tb ();

    `timescale 1ns/1ps

    localparam CLK_PERIOD = 10;

    logic clk;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk <= ~clk;
    end

    logic rst;
    logic [1:0] state;

    state_machine dut(.*);

    initial begin
        #(CLK_PERIOD * 2);
        rst = 1;
        #(CLK_PERIOD * 2);
        
        rst = 0;

        #(CLK_PERIOD * 20);
        $finish;
    end
endmodule