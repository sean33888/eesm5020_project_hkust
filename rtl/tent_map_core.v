module tent_map_core #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,
    input wire flag2,
    input wire [DATA_WIDTH-1:0] tent,
    input wire [DATA_WIDTH-1:0] alpha,
    input wire [1:0] precision_sel,
    output reg [DATA_WIDTH-1:0] key3,
    output reg done3
);
    reg start;
    reg [DATA_WIDTH-1:0] y_current;
    wire [DATA_WIDTH-1:0] one_minus_y, one_minus_alpha, div1, div2;
    

    assign one_minus_y = ~y_current + 1;
    assign one_minus_alpha = ~alpha + 1;
    assign div1 = {y_current, {(DATA_WIDTH){1'b0}}} / alpha;
    assign div2 = {one_minus_y, {(DATA_WIDTH){1'b0}}} / one_minus_alpha;

    always @(posedge clk) begin
        if (!rst_n) begin
            start <= 0;
            y_current <= 12'b0;
            key3 <= 12'b0;
            done3 <= 0;
        end else begin
            if (!flag2) begin
                key3 <= 0;
                y_current <= 0;
                done3 <= 0;
                start <= 0;
            end else if(start == 0)begin
                y_current <= tent;
                start <= 1;
                done3 <= 0;
            end else begin
                key3 <= (y_current < alpha) ? div1 : div2;
                done3 <= 1;
            end
        end
    end

endmodule