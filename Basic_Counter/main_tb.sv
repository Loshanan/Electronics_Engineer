module main_tb();

    `timescale 1ns/1ps

    localparam LED_CLK_PERIOD = 10;
    localparam DATA_CLK_PERIOD = 16 * LED_CLK_PERIOD;
    // led clock should be much higher for smooth transition


    logic dataclk;
    logic ledclk;

    // input clock for the counter
    initial begin
        dataclk = 0;
        forever #(DATA_CLK_PERIOD/2) dataclk <= ~dataclk;
    end
    
    // clock for led display update
    initial begin
        ledclk = 0;
        forever #(LED_CLK_PERIOD/2) ledclk <= ~ledclk;
    end

    logic rst, incr;
    logic [6:0] abcdefg;
    logic [3:0] digit;

    main dut (.*);

    initial begin
        #(10);
        rst = 1;
        #(DATA_CLK_PERIOD);

        incr = 1;
        rst = 0;
        #(DATA_CLK_PERIOD * 5);

        incr = 0;
        #(DATA_CLK_PERIOD * 2);

        incr = 1;
        #(DATA_CLK_PERIOD * 2);

        rst = 1;
        #(DATA_CLK_PERIOD);

        $finish;
    end


endmodule