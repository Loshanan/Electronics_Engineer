module decoder (
    input logic [1:0] sel,
    output logic [3:0] out
);
    always_comb begin
        unique case (sel)
            2'b00 : out = 4'b1000;
            2'b01 : out = 4'b0100;
            2'b10 : out = 4'b0010;
            2'b11 : out = 4'b0001; 
            default: out = 4'bxxxx;
        endcase
    end
endmodule