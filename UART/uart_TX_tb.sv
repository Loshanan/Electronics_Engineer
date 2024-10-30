module uart_TX_tb ();

    `timescale 1ns/1ps

    localparam CLK_PERIOD = 100;  // 10MHz

    logic clk;

    initial begin
        clk <= 0;
        forever #(CLK_PERIOD/2) clk <= ~clk;
    end

    logic [7:0] dataTX;
    logic       dataTXValid;
    logic       serialTX;
    logic       activeTX;
    logic       doneTX;

    localparam CLKS_PER_BIT = 87;

    uart_TX #(.CLKS_PER_BIT(CLKS_PER_BIT)) dut (.*);

    initial begin
        @(posedge clk)
        dataTX <= 8'b01010101;
        #(10 * CLK_PERIOD)
        @(posedge clk)
        dataTXValid <= 1;
        @(posedge clk)
        dataTXValid <= 0;
        #(12 * CLKS_PER_BIT * CLK_PERIOD);
        $finish;
    end


endmodule