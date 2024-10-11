module counter #(
    parameter WIDTH = 8
) (
    input logic clk, rst, incr,
    output logic [WIDTH - 1:0] cnt_out
);
    
    always_ff @( posedge clk ) begin
        if (rst) cnt_out <= 0;
        else if (incr) cnt_out <= cnt_out + 1'b1;
    end

endmodule