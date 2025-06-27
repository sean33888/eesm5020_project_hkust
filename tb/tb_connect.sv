`timescale 1ns/1ps

module HYBRID_CHAOTIC_ENCRYPTION_TB();
    
    parameter PARAM_WIDTH = 8;
    parameter TEXT_WIDTH = 8;

    wire clk;
    wire reset;
    wire [1:0] precision_sel; // 00: 16-bit, 01: 24-bit, 10: 32-bit
    wire [PARAM_WIDTH-1:0] mu; // Control parameter for logistic mapping
    wire [PARAM_WIDTH-1:0] x0; // Initial value for logistic mapping
    wire [PARAM_WIDTH-1:0] alpha; // Control parameter for tent mapping
    wire [PARAM_WIDTH-1:0] y0; // Initial value for tent mapping
    wire [31:0] k; // Iteration length
    wire param_vld;

    wire input_p_valid;
    wire [TEXT_WIDTH-1:0] plaintext_in; // 8-bit pixel input
    wire input_p_ready;

    wire [TEXT_WIDTH:0] ciphertext_out; // 8-bit encrypted output
    wire output_valid; 
    
    
    HYBRID_CHAOTIC_ENCRYPTION_TOP DUT_INST#(
        parameter PARAM_WIDTH = PARAM_WIDTH,
        parameter TEXT_WIDTH = TEXT_WIDTH
    )(
        .clk(clk),                  // input
        .rst_n(rst_n),              // input
        .mu(mu),                    // input
        .x0(x0),                    // input
        .y0(y0),                    // input
        .alpha(aplha),              // input
        .k(k),                      // input
        .precision(precision_sel),  // input
        .param_vld(param_vld),      // input
        
        .param_vld(input_p_valid),  // input
        .plaintext_in(plaintext_in),// input
        .p_ready(input_p_ready),    // output

        .ciphertext_out(ciphertext_out) // output
        .output_valid(output_valid)     // output
    );

endmodule
