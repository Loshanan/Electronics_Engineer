module uart_TX #(
    CLKS_PER_BIT = 87     // 115200 baud rate with 10MHz clk 
) (
    input  logic       clk,
    input  logic [7:0] dataTX,
    input  logic       dataTXValid,
    output logic       serialTX,
    output logic       activeTX,
    output logic       doneTX
);

    parameter IDLE      = 2'b00;
    parameter START_BIT = 2'b01;
    parameter DATA      = 2'b10;
    parameter STOP_BIT  = 2'b11;

    logic [7:0] regData;       // to store the transmitting data
    logic [2:0] dataIndex;     // 8 bit data length
    logic [7:0] clkCount;      // in 10MHz clk possible baudrates: 57.6K, 115.2K
    logic [1:0] mainSM;        // 4 states 2 bits

    always_ff @( posedge clk ) begin
        unique case(mainSM) 

            IDLE: begin
                dataIndex <= '0;
                clkCount  <= '0;
                doneTX    <= 1'b0;
                serialTX  <= 1'b1;
                if (dataTXValid) begin
                    regData  <= dataTX;
                    mainSM   <= START_BIT;
                    activeTX <= 1'b1;
                end
                else activeTX  <= 1'b0;
            end

            START_BIT: begin
                serialTX <= 1'b0;
                if (clkCount < CLKS_PER_BIT - 1) clkCount <= clkCount + 1;
                else begin
                    clkCount <= '0;
                    mainSM   <= DATA;
                end
            end

            DATA: begin
                serialTX <= regData[dataIndex];         // little endian first
                if (clkCount < CLKS_PER_BIT - 1) clkCount <= clkCount + 1;
                else begin
                    clkCount <= '0;
                    if (dataIndex < 7) begin
                        dataIndex <= dataIndex + 1;
                    end
                    else begin
                        dataIndex <= '0;
                        mainSM    <= STOP_BIT;
                    end
                end 
            end

            STOP_BIT: begin
                serialTX <= 1'b1;
                if (clkCount < CLKS_PER_BIT - 1) clkCount <= clkCount + 1;
                else begin
                    clkCount <= '0;
                    mainSM   <= IDLE;
                    doneTX   <= 1'b1;
                    activeTX <= 1'b0;
                end
            end

            default: begin
                mainSM <= IDLE;
            end
        endcase
    end
    

endmodule