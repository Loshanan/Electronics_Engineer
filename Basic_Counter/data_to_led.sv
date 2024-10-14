module data_to_led (
    input logic clk, rst,
    input logic [15:0] data,
    output logic [6:0] abcdefg,
    output logic [3:0] digit
);
    logic [1:0] sel;
    logic [3:0] nib;

    mux mux1 (data, sel, nib);

    state_machine sel_gen (clk, rst, sel);

    nib2led ledconvert (nib, abcdefg);

    decoder digit_select (sel, digit);
    
endmodule