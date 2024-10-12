module nib2led (
    input logic [3:0] nib,      // input nibble
    output logic [6:0] led      // for 7 segment led display
);
    always_comb begin
        unique case (nib)
            4'd0  : led = 7'h7e;
            4'd1  : led = 7'h30;
            4'd2  : led = 7'h6d;
            4'd3  : led = 7'h79;
            4'd4  : led = 7'h33;
            4'd5  : led = 7'h5b;
            4'd6  : led = 7'h5f;
            4'd7  : led = 7'h70;
            4'd8  : led = 7'h7f;
            4'd9  : led = 7'h7b;
            4'd10 : led = 7'h77;
            4'd11 : led = 7'h1f;
            4'd12 : led = 7'h4e;
            4'd13 : led = 7'h3d;
            4'd14 : led = 7'h4f;
            4'd15 : led = 7'h47;
            default: led = 7'bxxxxxxx;
        endcase
    end
endmodule