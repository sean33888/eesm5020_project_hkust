module data_control #(
    parameter DATA_WIDTH = 12,
    parameter OUT_WIDTH = 8
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] y0,
    input wire done,
    input wire [DATA_WIDTH-1:0] key_out,
    input wire plaintext_valid,
    input wire [OUT_WIDTH-1:0] plaintext_in, // Add plaintext as input
    //output reg [DATA_WIDTH-1:0] plaintext_out,
    output wire [OUT_WIDTH-1:0] plaintext_out,
    output wire [DATA_WIDTH-1:0] data_key_out,
    output reg [1:0] instruction,
    output wire [DATA_WIDTH-1:0] key_in,
    //output reg valid
    output wire valid
);
    assign key_in = y0;
    assign valid = plaintext_valid && done;
    assign plaintext_out = valid ? plaintext_in : {OUT_WIDTH{1'b0}};
    assign data_key_out = valid ? key_out : {DATA_WIDTH{1'b0}};
    always @(posedge clk) begin
        if (!rst_n) begin
            //plaintext_out <= 12'b0;
            //data_key_out <= 12'b0;
            instruction <= 2'b0;
            //valid <= 0;
        end else begin
            // change the following to assign to remove one cycle delay
            //valid <= plaintext_valid && done;
            instruction <= 2'b01;
            if(valid)begin
		// change the following to assign to remove one cycle delay
                // plaintext_out <= plaintext_in;
                //data_key_out <= key_out;
                instruction <= 2'b10;
            end
        end
    end
endmodule
