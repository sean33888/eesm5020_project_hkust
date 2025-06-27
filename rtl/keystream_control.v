module keystream_control #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,
    input wire rst_n,
    input wire done1, 
    input wire done2, 
    input wire done3,  
    input wire [1:0] instruction,
    input wire [DATA_WIDTH-1:0] k,
    input wire [DATA_WIDTH-1:0] key_in,
    input wire [DATA_WIDTH-1:0] logistic_key_out,
    output reg [1:0] order,
    output wire [DATA_WIDTH-1:0] tent50,
    output wire [DATA_WIDTH-1:0] tent,
    output reg flag1,
    output reg [DATA_WIDTH-1:0] key2,
    output reg flag2,
    output reg [DATA_WIDTH-1:0] key_out,    
    output reg done               
);

    localparam tent50_map = 2'b00,
           logistic_map = 2'b01,
           tent_map = 2'b10,
           final_flag = 2'b11;
    reg [1:0] state;
    
    assign tent50 = key_in;
    assign tent = logistic_key_out;
    always @(posedge clk) begin
        if (!rst_n) begin
            order <= 2'b0;
            flag1 <= 0;
            key2 <= 12'b0;
            flag2 <= 0;
            key_out <= 12'b0;
            done <= 0;
            state <= 2'b0;
        end else begin
            case (state)
                tent50_map: begin
                    if(instruction == 2'b01)begin
                        flag1 <= 1;
                    end
                    
                    if(done1 == 1)begin
                        state <= logistic_map;
                    end
                end
                logistic_map: begin
                    key2 <= k; // Initialize x0 with key1
                    order <= instruction;
                    if(done2 == 1)begin
                        state <= tent_map;
                    end
                end
                tent_map: begin
                    flag2 <= 1;
                    
                    if(done3 == 1)begin
                        state <= final_flag;
                    end
                end
                final_flag: begin
                    if(done2 == 1)begin
                        key_out <= logistic_key_out;
                        done <= 1;
                        flag1 <= 0;
                        flag2 <= 0;
                        state <= tent50_map; //not sure start again or have another signal
                    end
                end
            endcase
        end
    end

endmodule
