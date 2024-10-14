module main (
    input logic dataclk,
    input logic incr,
    input logic rst,

    input logic ledclk,
    output [6:0] abcdefg,
    output [3:0] digit
);
    
    logic [15:0] data;

    localparam WIDTH = 16;

    counter #(.WIDTH(WIDTH)) counter1 (dataclk, rst, incr, data);

    data_to_led display_unit (ledclk, rst, data, abcdefg, digit);
    
endmodule