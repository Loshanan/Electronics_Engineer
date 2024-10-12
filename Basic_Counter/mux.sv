module mux (
    input logic [15:0] word,
    input logic [1:0] sel,
    output logic [3:0] nib
);
    always_comb begin
        unique case (sel)
            2'b00 : nib = word[15:12];
            2'b01 : nib = word[11:8];
            2'b10 : nib = word[7:4];
            2'b11 : nib = word[3:0];
            default: nib = 4'bxxxx;
        endcase
    end
endmodule