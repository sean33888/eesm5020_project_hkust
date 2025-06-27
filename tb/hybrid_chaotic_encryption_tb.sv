module tb_hybrid_chaotic_encryption;
    // Parameters
    parameter DATA_WIDTH = 12;
    parameter PLAINTEXT_WIDTH = 8;
    parameter KEY_WIDTH = PLAINTEXT_WIDTH * 4 + 2; // 33 bits
    parameter CLK_PERIOD = 10; // clock period (ns)

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
    wire [PLAINTEXT_WIDTH-1:0] ciphertext1, ciphertext2;
    wire ciphertext_valid1, ciphertext_valid2;

    // storing previous value
    reg [PLAINTEXT_WIDTH-1:0] plaintext_prev;
    reg [PLAINTEXT_WIDTH-1:0] ciphertext1_prev;
    reg [PLAINTEXT_WIDTH-1:0] ciphertext2_prev;
    reg plaintext_valid_in_prev, ciphertext_valid1_prev, ciphertext_valid2_prev;
    always @(posedge clk) begin
        plaintext_prev <= plaintext;
        ciphertext1_prev <= ciphertext1;
        ciphertext2_prev <= ciphertext2;
        plaintext_valid_in_prev <= plaintext_valid_in;
        ciphertext_valid1_prev <= ciphertext_valid1;
        ciphertext_valid2_prev <= ciphertext_valid2;
    end

    // storing values
    bit [PLAINTEXT_WIDTH-1:0] plaintext_q [$]; // puts each plaintext input of uut1 to this queue
    bit [PLAINTEXT_WIDTH-1:0] ciphertext1_q [$]; // puts each ciphertext output of uut1 or plaintext input of uut2 to this queue
    int num_transactions_sent = 0; // keep note of number of plaintexts sent
    int num_replies = 0;
    bit [PLAINTEXT_WIDTH-1:0] plaintext_file [$]; // reads plaintext from file
    string plaintext_filename;
    string param_filename;

    // Instantiate the top-level module
    // first module, for encode
    hybrid_chaotic_encryption #(
        .DATA_WIDTH(DATA_WIDTH),
        .INPUT_WIDTH(PLAINTEXT_WIDTH)
    ) uut1 (
        .clk(clk),
        .rst_n(rst_n),
        .plaintext(plaintext),
        .key_valid_in(key_valid_in),
        .plaintext_valid_in(plaintext_valid_in),
        .key(key),
        .ciphertext(ciphertext1),
        .ciphertext_valid(ciphertext_valid1)
    );

    // second module, for decode
    hybrid_chaotic_encryption #(
        .DATA_WIDTH(DATA_WIDTH),
        .INPUT_WIDTH(PLAINTEXT_WIDTH)
    ) uut2 (
        .clk(clk),
        .rst_n(rst_n),
        .plaintext(ciphertext1),
        .key_valid_in(key_valid_in),
        .plaintext_valid_in(ciphertext_valid1),
        .key(key),
        .ciphertext(ciphertext2),
        .ciphertext_valid(ciphertext_valid2)
    );

    // Clock and reset generation
    clk_gen #(
        .CLK_PERIOD(CLK_PERIOD)
    ) clk_gen_inst (
        .clk(clk),
        .rst_n(rst_n)
    );

    // Test stimulus
    bit [33:0] tmp_key, tmp_key2;
    int fp_param;
    int line_num = 0;
    initial begin
        // Initialize inputs
        key_valid_in = 0;
        key = 33'h0;
        $value$plusargs ("PARAM=%s", param_filename);
        $display("data from ", param_filename);
        fp_param = $fopen(param_filename, "r");
        while (!$feof(fp_param)) begin
            if($fscanf(fp_param, "%h %h %h %h %h", tmp_key2[33:32], tmp_key2[31:24], tmp_key2[23:16], tmp_key2[15:8], tmp_key2[7:0])) begin
                if (line_num == 0) begin
                    tmp_key = tmp_key2;
                    $display("precision is %h \nk is %h \ny0 is %h \na is %h \nmu is %h", tmp_key[33:32], tmp_key[31:24], tmp_key[23:16], tmp_key[15:8], tmp_key[7:0]);
                    line_num += 1;
                end
            end
        end
        #30;

        // Test case 1: Verify 12-bit mu, y0
        @(posedge clk);
        //key <= {2'b1, 8'h02, 8'h03, 8'h04, 8'h05}; // precision_sel=1, k=2, y0=3, alpha=4, mu=5
        key <= tmp_key;
        key_valid_in <= 1'b1;

        #9000;
        @(posedge clk);
        key <= '0;
        key_valid_in <= 1'b0;

        // need to receive decoded value for all inputs sent to encoder
        if (num_transactions_sent != num_replies) begin
            $display("ERROR: number of transactions mismatch");
            $display("%d sent, %d received", num_transactions_sent, num_replies);
            $finish;
        end else begin
            num_transactions_sent = 0;
            num_replies = 0;
        end

        #2000;

        // key 2
        @(posedge clk);
        key <= tmp_key2;
        key_valid_in <= 1'b1;

        #9000;
        
        // need to receive decoded value for all inputs sent to encoder
        if (num_transactions_sent != num_replies) begin
            $display("ERROR: number of transactions mismatch");
            $display("%d sent, %d received", num_transactions_sent, num_replies);
            $finish;
        end

        $display("%d data sent and received ", num_transactions_sent);
        $display("PASS: simulation end");
        $finish;
    end

    // input stimulus: plaintext
    int transactions = 0;
    bit [PLAINTEXT_WIDTH-1:0] pt_tmp;
    int fp1;
    bit start_send = 1'b0;
    initial begin
        plaintext_valid_in = 1'b0;
        plaintext = '0;
        $value$plusargs ("PLAINTEXT=%s", plaintext_filename);
        $display("data from ", plaintext_filename);
        fp1 = $fopen(plaintext_filename, "r");
        while (!$feof(fp1)) begin
            // Read 4 bytes (32 bits) at a time
            if($fscanf(fp1, "%h", pt_tmp)) begin
                plaintext_file.push_back(pt_tmp);
            end
        end
        #50;
        forever begin
            @(posedge clk);
            if (uut1.data_ctrl.key_out != '0) begin
                plaintext_valid_in <= 1'b1;
                start_send <= 1'b1;
                //plaintext <= $urandom();
                plaintext <= plaintext_file.pop_front();
                transactions += 1;
            end
            //if (transactions >= 100) begin
            if (plaintext_file.size() == 50) begin
                plaintext_valid_in <= 1'b0;
                @(negedge rst_n);
                break;
            end
        end
        #500;
        forever begin
            @(posedge clk);
            if (uut1.data_ctrl.key_out != '0) begin
                plaintext_valid_in <= 1'b1;
                start_send <= 1'b1;
                //plaintext <= $urandom();
                plaintext <= plaintext_file.pop_front();
                transactions += 1;
            end
            //if (transactions >= 100) begin
            if (plaintext_file.size() == 0) begin
                plaintext_valid_in <= 1'b0;
                break;
            end
        end
    end

    // checker, see whether encode and decode gives same result
    initial begin
        forever begin
            @(negedge clk);
            // two conditions that should put data in queue
            // 1. rising edge of valid
            // 2. valid is 1 and there is a data change
            if(plaintext_valid_in == 1 && (plaintext != plaintext_prev || plaintext_valid_in_prev == 1'b0)) begin
                num_transactions_sent += 1;
                plaintext_q.push_back(plaintext);
            end
            if(ciphertext_valid1 == 1 && (ciphertext1 != ciphertext1_prev || ciphertext_valid1_prev == 1'b0)) begin
                ciphertext1_q.push_back(ciphertext1);
            end
            if(ciphertext_valid2 == 1 && (ciphertext2 != ciphertext2_prev || ciphertext_valid2_prev== 1'b0)) begin
                num_replies += 1;
                if (plaintext_q[0] != ciphertext2) begin
                    $display("Time=%0t", $time);
                    $display("Error: plaintext after encode and decode mismatches");
                    $display("original plaintext is %h \n decoded plaintext is %h \n", plaintext_q[0], ciphertext2);
                end
                plaintext_q.pop_front();
            end
        end
    end

    // prevent simulation hang
    int run_cycles = 0;
    initial begin
        @(posedge clk);
        run_cycles += 1;
        if(run_cycles >= 1000) begin
            $display("ERROR: timeout!");
            $finish;
        end
    end
endmodule

