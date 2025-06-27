module tb_hybrid_chaotic_encryption;
    // Parameters
    parameter DATA_WIDTH = 12;
    parameter PLAINTEXT_WIDTH = 8;
    parameter KEY_WIDTH = PLAINTEXT_WIDTH * 4 + 1; // 33 bits

    // Inputs
    reg clk;
    reg rst_n;
    reg [PLAINTEXT_WIDTH-1:0] plaintext;
    reg key_valid_in;
    reg plaintext_valid_in;
    reg [KEY_WIDTH-1:0] key;
    // key format is
    // | precision: 2bits | k | y0 | alpha | mu | (from high to low)
    // Outputs
    wire [PLAINTEXT_WIDTH-1:0] ciphertext;
    wire ciphertext_valid;

    // Instantiate the top-level module
    hybrid_chaotic_encryption #(
        .DATA_WIDTH(DATA_WIDTH),
        .INPUT_WIDTH(PLAINTEXT_WIDTH)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .plaintext(plaintext),
        .key_valid_in(key_valid_in),
        .plaintext_valid_in(plaintext_valid_in),
        .key(key),
        .ciphertext(ciphertext),
        .ciphertext_valid(ciphertext_valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        rst_n = 0;
        plaintext = 8'hAA;
        key_valid_in = 0;
        plaintext_valid_in = 0;
        key = 33'h0;
        #20;

        // Release reset
        rst_n = 1;
        #10;

        // Test case 1: Verify 12-bit mu, y0
        key = {2'b1, 8'h02, 8'h03, 8'h04, 8'h05}; // precision_sel=1, k=2, y0=3, alpha=4, mu=5
        key_valid_in = 1;
        plaintext_valid_in = 1;
        #10;
        $display("Test 1 (t=40ns): mu=%h, y0=%h, data_ctrl_y0=%h", 
                 uut.mu, uut.y0, uut.data_ctrl.y0);
        #10;
        $display("Test 1 (t=50ns): mu=%h, y0=%h, data_ctrl_y0=%h, ciphertext=%h",
                 uut.mu, uut.y0, uut.data_ctrl.y0, ciphertext);
        key_valid_in = 0;
        #500;

        // Test case 2: Different key
        key = {2'b0, 8'h05, 8'h04, 8'h03, 8'h40};
        key_valid_in = 1;
        #10;
        $display("Test 2 (t=580ns): mu=%h, y0=%h, data_ctrl_y0=%h",
                 uut.mu, uut.y0, uut.data_ctrl.y0);
        key_valid_in = 0;
        #100;

        // End simulation
        #5000;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t: mu=%h, y0=%h, data_ctrl_y0=%h", 
                 $time, uut.mu, uut.y0, uut.data_ctrl.y0);
    end
endmodule
