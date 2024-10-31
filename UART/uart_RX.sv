module uart_RX #(
    CLKS_PER_BIT = 87
) (
    input  logic       serial,
    input  logic       clk,
    output logic [7:0] dataRX,
    output logic       dataRXValid
);
    
    parameter IDLE      = 2'b00;
    parameter START_BIT = 2'b01;
    parameter DATA      = 2'b10;
    parameter STOP_BIT  = 2'b11;

    logic [7:0] clkCount;
    logic [2:0] dataIndex;
    logic [7:0] data;
    logic [1:0] mainSM;

    always_ff @( posedge clk ) begin
        unique case (mainSM)
            IDLE: begin
                clkCount    <= '0;
                dataIndex   <= '0;
                dataRXValid <=  0;
                if (!serial) begin
                    mainSM <= START_BIT;
                end
            end

            START_BIT: begin
                if (clkCount < CLKS_PER_BIT/2 - 1) clkCount <= clkCount + 1;
                else begin
                    if (!serial) begin
                        mainSM   <= DATA;
                        clkCount <= '0;
                    end 
                    else begin
                        mainSM   <= IDLE;
                    end
                end
            end

            DATA: begin
                if (clkCount < CLKS_PER_BIT - 1) clkCount <= clkCount + 1;
                else begin
                    data[dataIndex] = serial;
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
                if (clkCount < CLKS_PER_BIT - 1) clkCount <= clkCount + 1;
                else begin
                    dataRXValid <= 1;
                    clkCount    <= '0;
                    mainSM      <= IDLE;
                end
            end

            default: begin
                mainSM <= IDLE;
            end
        endcase
    end

    assign dataRX = data;

endmodule