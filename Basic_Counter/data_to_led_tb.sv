module data_to_led_tb ();
    
    `timescale 1ns/1ps

    logic clk;
    localparam CLK_PERIOD = 10;

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk <= ~clk;
    end

    logic rst;
    logic [15:0] data;
    logic [6:0] abcdefg;
    logic [3:0] digit;

    data_to_led dut (.*);

    initial begin
        #(CLK_PERIOD * 2);
        rst = 1;

        data = 16'h8787;
        #(CLK_PERIOD * 4);
        
        rst = 0;
        #(CLK_PERIOD * 5);

        rst = 1;
        data = 16'h06ae;
        #(CLK_PERIOD * 2);
        
        rst = 0;
        #(CLK_PERIOD * 5);
        
        $finish;
    end
    
endmodule