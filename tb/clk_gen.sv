`timescale 1ns/1ps
module clk_gen #(
    parameter CLK_PERIOD = 10
)(
    output reg clk,
    output reg rst_n
);
    real half_period = CLK_PERIOD/2;

    // clk gen
    initial begin
        clk = 0;
        forever #half_period clk = ~clk; // 100 MHz
    end

    // reset gen
    initial begin
        rst_n = 0;
        # CLK_PERIOD;
        rst_n = 1;
        # 10000;
        rst_n = 0;
        # CLK_PERIOD;
        rst_n = 1;
    end

endmodule
