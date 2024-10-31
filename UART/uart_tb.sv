module uart_tb ();
    
    `timescale 1ns/1ps

    localparam CLK_PERIOD = 100;

    logic clkTX;
    logic clkRX;

    initial begin
        clkTX <= 0;
        forever #(CLK_PERIOD/2) clkTX <= ~clkTX;
    end

    initial begin
        #(CLK_PERIOD/2)
        clkRX <= 0;
        forever #(CLK_PERIOD/2) clkRX <= ~clkRX;
    end

    logic [7:0] dataIn;
    logic       dataInReady;

    logic       serial;
    logic       activeTX;
    logic       doneTX;

    logic [7:0] dataOut;
    logic       dataOutReady;


    localparam CLKS_PER_BIT = 87;

    uart_TX #(.CLKS_PER_BIT(CLKS_PER_BIT)) dutTX (
        .clk(clkTX),
        .dataTX(dataIn),
        .dataTXValid(dataInReady),
        .serialTX(serial),
        .activeTX(activeTX),
        .doneTX(doneTX)
    );

    uart_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) dutRX (
        .serial(serial),
        .clk(clkRX),
        .dataRX(dataOut),
        .dataRXValid(dataOutReady)
    );

    initial begin
        #200;
        dataIn = 8'b01010101;
        #50;
        dataInReady = 1;
        #(CLK_PERIOD);
        dataInReady = 0;
        #(15 * CLKS_PER_BIT *CLK_PERIOD);
        if (dataOut == 8'b01010101)
            $display("Test Passed - Correct Byte received.");
        else
            $display("Test Failed - Incorrect Byte received.");
        $finish;
    end
endmodule