module xor_module #(
    parameter DATA_WIDTH = 12,
    parameter OUT_WIDTH = 8
)(
    input wire clk,
    input wire rst_n,
    input wire [OUT_WIDTH-1:0] plaintext,
    input wire [DATA_WIDTH-1:0] key_out,
    input wire valid,
    output reg [OUT_WIDTH-1:0] ciphertext,
    output reg ciphertext_valid
);

    wire [DATA_WIDTH-1:0] binary_seq;
    //reg ciphertext_valid_1dly;

    // Threshold judgment: x_n > 0.5
//    genvar i;
//    generate
//        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : gen_binary_seq
//            assign binary_seq[i] = (key_out[i] > 12'b000010000000) ? 1 : 0;
//        end
//    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ciphertext <= 0;
            ciphertext_valid <= 0;
            //ciphertext_valid_1dly <= 0;
        end else if (valid) begin
            ciphertext <= plaintext ^ key_out[OUT_WIDTH-1:0];
            //ciphertext_valid <= ciphertext_valid_1dly;
            //ciphertext_valid_1dly <= 1;
            ciphertext_valid <= 1'b1;
        end else begin
            ciphertext <= 0;
            //ciphertext_valid <= ciphertext_valid_1dly;
            //ciphertext_valid_1dly <= 0;
            ciphertext_valid <= 1'b0;
        end
    end

endmodule
