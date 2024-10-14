module state_machine (
    input logic clk, rst,
    output logic [1:0] state
);
    
    logic [1:0] current_state;
    logic [1:0] next_state;

    always_comb begin
        unique case (current_state)
            2'b00 : next_state = 2'b01;
            2'b01 : next_state = 2'b10;
            2'b10 : next_state = 2'b11;
            2'b11 : next_state = 2'b00;
            default: next_state = 2'b00;
        endcase
    end

    always_ff @( posedge clk or posedge rst ) begin
        if (rst) current_state <= 2'b00;
        else current_state <= next_state;
    end

    assign state = current_state;

endmodule








// module state_machine (
//     input logic clk, rst,
//     output logic [1:0] state
// );
//     always_ff @( posedge clk or posedge rst ) begin
//         if (rst) state <= 2'b00;
//         else begin
//             unique case (state)
//                 2'b00 : state <= 2'b01;
//                 2'b01 : state <= 2'b10;
//                 2'b10 : state <= 2'b11;
//                 2'b11 : state <= 2'b00; 
//                 default: state <= 2'b00;
//             endcase
//         end
//     end
// endmodule