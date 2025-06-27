module logistic_map_core #(
    parameter DATA_WIDTH = 12
)(
    input wire clk,   
    input wire rst_n,                
    input wire start,                 
    input wire [DATA_WIDTH-1:0] key2, // k
    input wire [DATA_WIDTH-1:0] key1, // Initial value x0
    input wire [DATA_WIDTH-1:0] mu,   // Parameter mu
    input wire [1:0] precision_sel,   
    input wire [1:0] order,           
    output reg [DATA_WIDTH-1:0] keyout, // Output result
    output reg done2                  // Done signal
);
    // Internal registers
    reg [DATA_WIDTH-1:0] x_current;   // Current x_n value
    reg [6:0] iter_count;  // Iteration counter
    reg [1:0] state;                  // State machine state

    
    wire [DATA_WIDTH-1:0] one_minus_x;
    wire [DATA_WIDTH*3-1:0] next_x;     

    // Calculate 1 - x_current in Q4.4
    assign one_minus_x = (1 << DATA_WIDTH) - x_current; // 1.0 - x_current
    assign next_x = mu * x_current * one_minus_x;

    // State machine states
    localparam IDLE = 2'b00,
               INIT = 2'b01,
               COMPUTE = 2'b10,
               DONE = 2'b11;

    // State machine and computation
    always @(posedge clk) begin
        if (!rst_n) begin
                state <= IDLE;
                keyout <= 12'b0;
                done2 <= 0;
                x_current <= 12'b0;
                iter_count <= 6'b0;
            end else begin
                case (state)
                    IDLE: begin
                        if (start) begin
                            state <= INIT;
                            done2 <= 0;
                        end
                    end
                    INIT: begin
                        x_current <= key1; // Initialize x0 with key1
                        iter_count <= 0;
                        state <= COMPUTE;
                    end
                    COMPUTE: begin
                        if (iter_count < key2) begin
                            x_current <= (next_x[DATA_WIDTH*3-4:DATA_WIDTH*2-4] == 0) ?	
                                            {{DATA_WIDTH-1{1'b0}}, {1'b1}} :
                                            next_x[DATA_WIDTH*3-4:DATA_WIDTH*2-4]; // Update x_n+1 = mu * x_n * (1 - x_n)
                            iter_count <= iter_count + 1;
                        end else begin
                            keyout <= next_x[DATA_WIDTH*3-1:DATA_WIDTH*2];
                            state <= DONE;
                        end
                    end
                    DONE: begin
                            state <= IDLE;
                            done2 <= 1;
                    end
                endcase
            end
    end

endmodule
