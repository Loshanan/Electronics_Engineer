`timescale 1ns/1ps
module axiSlave_tb ();

    parameter CLK_PERIOD = 100; 
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 2;

    logic clk;

    // write signals
    logic awvalid;        // write address valid
    logic awready;       // slave ready to accept write adress
    logic [ADDR_WIDTH - 1:0] awaddr; //write address
    logic [DATA_WIDTH - 1:0] wdata; //write data
    logic wvalid;         // write data valid
    logic wready;        // slave ready to accept data
    logic wresp;         // write response

    // read signals
    logic arvalid;        // valid read address presents
    logic arready;        // slave ready to accept read address
    logic [ADDR_WIDTH - 1:0] araddr; //read address
    logic rvalid;         // valid read response is present
    logic [DATA_WIDTH - 1:0] rData; // read data

    logic [DATA_WIDTH - 1:0] reg1;
    logic [DATA_WIDTH - 1:0] reg2;
    logic [DATA_WIDTH - 1:0] reg3;

    axiSlave #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .awvalid(awvalid),
        .awready(awready),
        .awaddr(awaddr),
        .wdata(wdata),
        .wvalid(wvalid),
        .wready(wready),
        .wresp(wresp),
        .arvalid(arvalid),
        .arready(arready),
        .araddr(araddr),
        .rvalid(rvalid),
        .rData(rData),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk <= ~clk;
    end

    initial begin
        // write
        @(posedge clk)
        awaddr = 2'd3;
        wdata = 32'h12345678;
        #100
        awvalid = 1;
        wvalid = 1;
        #500

        // read
        @(posedge clk)
        reg1 = 32'h87654321;
        araddr = 2'd1;
        #100
        arvalid = 1;
        #500;

        $finish;



    end

endmodule