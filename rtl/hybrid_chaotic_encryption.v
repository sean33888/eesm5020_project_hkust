module hybrid_chaotic_encryption #(
    parameter INPUT_WIDTH = 8, // Supports 16, 24, 32-bit precision
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,
    input wire [INPUT_WIDTH-1:0] plaintext,
    input wire key_valid_in,
    input wire plaintext_valid_in,
    input wire [INPUT_WIDTH * 4 + 1:0] key, // Iteration length for perturbation
    output wire [INPUT_WIDTH-1:0] ciphertext,
    output wire ciphertext_valid
);

    wire [1:0] precision_sel, instruction;
    wire [INPUT_WIDTH-1:0] plaintext_in, plaintext_out;
    wire [DATA_WIDTH-1:0] mu, alpha, y0, k, key_in_out, key_out, data_key_out;
    // instantiate modules
    parameter_extraction #(
        .DATA_WIDTH(INPUT_WIDTH),
        .OUT_WIDTH(DATA_WIDTH)
    ) para_extract 
    (
        .clk(clk), .rst_n(rst_n), .key(key), .plaintext_in(plaintext),
        .key_valid_in(key_valid_in), .plaintext_valid_in(plaintext_valid_in),
        .precision_sel(precision_sel), .plaintext_valid_out(plaintext_valid_out),
        .plaintext_out(plaintext_in), .mu(mu), .alpha(alpha),
        .y0(y0), .k(k), .key_valid_out(key_valid_out)
    );

    data_control #(
        .DATA_WIDTH(DATA_WIDTH)
    )  data_ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .y0(y0),
        .done(done),
        .key_out(key_out),
        .plaintext_valid(plaintext_valid_out),
        .plaintext_in(plaintext_in),
        .plaintext_out(plaintext_out),
        .data_key_out(data_key_out),
        .instruction(instruction),
        .key_in(key_in_out),
        .valid(valid)
    );

    random_sequence_generator #(
        .DATA_WIDTH(DATA_WIDTH)
    )   ran_seq_gen (
        .clk(clk),
        .rst_n(rst_n),
        .mu(mu),
        .alpha(alpha),
        .key_in(key_in_out),
        .k(k),
        .instruction(instruction),
        .precision_sel(precision_sel),
        .key_out(key_out),
        .done(done)
    );

    xor_module #(
        .DATA_WIDTH(DATA_WIDTH)
    )   xor_mod (
        .clk(clk),
        .rst_n(rst_n),
        .plaintext(plaintext_out),
        .key_out(data_key_out),
        .valid(valid),
        .ciphertext(ciphertext),
        .ciphertext_valid(ciphertext_valid)
    );

endmodule
