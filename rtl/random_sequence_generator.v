module random_sequence_generator #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] mu, alpha, key_in,k,
    input wire [1:0] instruction,
    input wire [1:0] precision_sel,
    output reg [DATA_WIDTH-1:0] key_out,
    output reg done
);
    wire [1:0] order;
    wire [DATA_WIDTH-1:0] logistic_key_out, keystream_key_out, tent50, tent, key1, key2, key3; // Intermediate output from keystream_control
    wire keystream_done; // Intermediate done signal
    // Submodules
    tent50_map_core tent50_core (
        .clk(clk),
        .rst_n(rst_n),
        .flag1(flag1), // Combine start_signal and reset_n
        .tent50(tent50),
        .alpha(alpha),
        .precision_sel(precision_sel),
        .key1(key1),
        .done1(done1)
    );

    logistic_map_core logistic_core(
        .clk(clk),
        .rst_n(rst_n),
        .start(done1),
        .key2(key2),
        .key1(key1),
        .mu(mu),
        .precision_sel(precision_sel),
        .order(order),
        .keyout(logistic_key_out),
        .done2(done2)
    );

    tent_map_core tent_core(
        .clk(clk),
        .rst_n(rst_n),
        .flag2(flag2), // Combine start_signal and reset_n
        .tent(tent),
        .alpha(alpha),
        .precision_sel(precision_sel),
        .key3(key3),
        .done3(done3)
    );

    keystream_control keystream (
        .clk(clk), .rst_n(rst_n), .done1(done1), .done2(done2), .done3(done3),
        .instruction(instruction), .k(k), .key_in(key_in), .logistic_key_out(logistic_key_out),
        .order(order), .tent50(tent50), .tent(tent), .flag1(flag1), .key2(key2),
        .flag2(flag2), .key_out(keystream_key_out), .done(keystream_done)
    );
    
    always @(posedge clk) begin
        if (!rst_n) begin
            key_out <= 12'b0;
            done <= 0;
        end else begin
            key_out <= keystream_key_out;
            done <= keystream_done;
        end
    end

endmodule
