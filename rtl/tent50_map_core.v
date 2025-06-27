module tent50_map_core #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,
    input wire flag1,
    input wire [DATA_WIDTH-1:0] tent50,
    input wire [DATA_WIDTH-1:0] alpha,
    input wire [1:0] precision_sel,
    output reg [DATA_WIDTH-1:0] key1,
    output reg done1
);
    reg start;
    reg [DATA_WIDTH-1:0] y_current;
    reg [5:0] iter_count; // For 50 iterations
    wire [DATA_WIDTH-1:0] one_minus_y, one_minus_alpha, div1, div2;
    wire [DATA_WIDTH-1:0] y_nxt;

    // when y_current equals to alpha, division gives a 0, so need to change it
    assign y_nxt = (y_current == alpha) ? {~y_current[DATA_WIDTH-1:DATA_WIDTH-2], y_current[DATA_WIDTH-3:2], ~y_current[1:0]} : y_current;

    assign one_minus_y = ~y_nxt + 1;
    assign one_minus_alpha = ~alpha + 1;
    assign div1 = {y_nxt, {(DATA_WIDTH){1'b0}}} / alpha;
    assign div2 = {one_minus_y, {(DATA_WIDTH){1'b0}}} / one_minus_alpha;

    always @(posedge clk) begin
        if (!rst_n) begin
            start <= 0;
            y_current <= 12'b0;
            key1 <= 12'b0;
            done1 <= 0;
            iter_count <= 6'b0;
        end else begin
            if (!flag1) begin
                key1 <= 0;
                y_current <= 0;
                iter_count <= 0;
                done1 <= 0;
                start <= 0;
            end else if(iter_count == 0 && start == 0)begin
                y_current <= tent50;
                start <= 1;
                done1 <= 0;
            end else if (iter_count < 50) begin
                y_current <= (y_nxt < alpha) ? div1 : div2;
                iter_count <= iter_count + 1;
                done1 <= 0;
            end else begin
                key1 <= y_current;
                done1 <= 1;
            end
        end
    end

endmodule
