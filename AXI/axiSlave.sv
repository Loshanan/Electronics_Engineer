module axiSlave #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 2
) (
    input logic clk, rst,

    // axi write signals
    input logic awvalid,        // write address valid
    output logic awready,       // slave ready to accept write adress
    input logic [ADDR_WIDTH - 1:0] awaddr, //write address
    input logic [DATA_WIDTH - 1:0] wdata, //write data
    input logic wvalid,         // write data valid
    output logic wready,        // slave ready to accept data
    // output logic bvalid,        // write response in present on the bus
    // input logic bready,         // master ready to accept response
    output logic wresp,         // write response

    // axi read signal
    input logic arvalid,        // valid read address presents
    output logic arready,       // slave ready to accept read address
    input logic [ADDR_WIDTH - 1:0] araddr, //read address
    // input logic rready,         // master ready to accept data
    output logic [DATA_WIDTH - 1:0] rData, // read data
    output logic rvalid,        // valid read response is present


    input logic [DATA_WIDTH - 1:0] reg1,
    output logic [DATA_WIDTH - 1:0] reg2,
    output logic [DATA_WIDTH - 1:0] reg3
);

    logic [ADDR_WIDTH - 1:0] writeAddress;
    logic [DATA_WIDTH - 1:0] writeData;
    // logic writeResponse;

    logic [ADDR_WIDTH - 1:0] readAddress;

    // logic [DATA_WIDTH - 1:0] reg1;
    // logic [DATA_WIDTH - 1:0] reg2;
    // logic [DATA_WIDTH - 1:0] reg3;

    // writing block
    always_ff @( posedge clk or negedge rst) begin
        //reset
        if (!rst) begin
            reg2 <= '0;
            reg3 <= '0;
        end else begin
            // accept write address
            if (awvalid && !awready) begin
                writeAddress <= awaddr;
                awready <= 1;
            end
            else begin
                awready <= 0;
            end

            // accept write data
            if (wvalid && !wready) begin
                writeData <= wdata;
                wready <= 1;
            end
            else begin
                wready <= 0;
            end

            //write data
            if (writeAddress == 2'd2) begin
                reg2 <= writeData;
                wresp <= 1;
            end
            else if (writeAddress == 2'd3) begin
                reg3 <= writeData;
                wresp <= 1;
            end
            else wresp <= 0;
        end
    end

    //reading block
    always_ff @( posedge clk or negedge rst) begin
        // reset
        if (!rst) begin
            reg2 <= '0;
            reg3 <= '0;
        end else begin
            if (arvalid && !arready) begin
                readAddress <= araddr;
                arready <= 1;
            end
            else arready <= 0;

            if (readAddress == 2'd1) begin
                rData <= reg1;
                rvalid <= 1;
            end
            else begin
                rData <= '0;
                rvalid <= 0;
            end
        end
    end

endmodule