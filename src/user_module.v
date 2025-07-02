`default_nettype none
module user_module(
    input wire clk,
    input wire [7:0] io_in,
    output wire [7:0] io_out
);

    wire heartbeat_in = io_in[0];
    reg pace_out = 0;

    parameter THRESHOLD = 24_000_000;
    reg [31:0] timer = 0;

    always @(posedge clk) begin
        if (heartbeat_in) begin
            timer <= 0;
            pace_out <= 0;
        end else begin
            timer <= timer + 1;
            if (timer > THRESHOLD) begin
                pace_out <= 1;
                timer <= 0;
            end else begin
                pace_out <= 0;
            end
        end
    end

    assign io_out[0] = pace_out;
    assign io_out[7:1] = 7'b0;

endmodule
