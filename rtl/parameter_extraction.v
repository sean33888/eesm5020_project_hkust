module parameter_extraction #(
    parameter DATA_WIDTH = 8,
    parameter OUT_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH*4+1:0] key,  
    input wire [DATA_WIDTH-1:0] plaintext_in, 
    input wire key_valid_in,
    input wire plaintext_valid_in,
    output reg [1:0] precision_sel,
    output reg plaintext_valid_out,
    output reg [DATA_WIDTH-1:0] plaintext_out,
    output reg [OUT_WIDTH-1:0] mu, alpha, y0, k,
    output reg key_valid_out
);
    reg [OUT_WIDTH-1:0] temp;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_valid_out <= 0;
            plaintext_valid_out <= 0;
            plaintext_out <= {DATA_WIDTH{1'b0}}; // 8-bit zero
            mu <= {OUT_WIDTH{1'b0}};            // 12-bit zero
            alpha <= {OUT_WIDTH{1'b0}};         // 12-bit zero
            y0 <= {OUT_WIDTH{1'b0}};            // 12-bit zero
            k <= {OUT_WIDTH{1'b0}};             // 12-bit zero
            precision_sel <= 2'b00;
        end else begin
            if (key_valid_in) begin
                mu <= 12'h723 + temp; // key[7:0]
                alpha <= 12'b001100110011 + {{(OUT_WIDTH-DATA_WIDTH){1'b0}}, key[2*DATA_WIDTH-1:DATA_WIDTH]}; // key[15:8]
                y0 <= {key[3*DATA_WIDTH-1:2*DATA_WIDTH], {(OUT_WIDTH-DATA_WIDTH){1'b0}}}; // key[23:16]
                k <= {{(OUT_WIDTH-DATA_WIDTH){1'b0}}, key[4*DATA_WIDTH-1:3*DATA_WIDTH]};
                precision_sel <= key[4*DATA_WIDTH+1:4*DATA_WIDTH];
                key_valid_out <= 1;
            end else begin
                key_valid_out <= 0;
            end
            if (plaintext_valid_in) begin
                plaintext_out[DATA_WIDTH-1:0] <= plaintext_in[DATA_WIDTH-1:0];
                plaintext_valid_out <= 1;
            end else begin
                plaintext_valid_out <= 0;
            end         
            if (y0 == {OUT_WIDTH{1'b0}}) begin
                y0 <= {{(OUT_WIDTH-1){1'b0}}, 1'b1}; // 12'h001
            end
            // Cap mu at 12'h7dc (not 11'hdc)
            if ({{(OUT_WIDTH-DATA_WIDTH){1'b0}}, key[DATA_WIDTH-1:0]} > 12'hdc) begin
                temp <= 12'hdc;
            end else begin
                temp <= {{(OUT_WIDTH-DATA_WIDTH){1'b0}}, key[DATA_WIDTH-1:0]};
            end
            if (alpha == {OUT_WIDTH{1'b0}}) begin
                alpha <= {{(OUT_WIDTH-1){1'b0}}, 1'b1}; // 12'h001
            end   
        end
    end

endmodule
