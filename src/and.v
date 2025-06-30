module pacemaker(input clk, input heartbeat_in, output reg pace_out);
  reg [31:0] timer;

  always @(posedge clk) begin
    if (heartbeat_in) begin
      timer <= 0;
      pace_out <= 0;
    end else begin
      timer <= timer + 1;
      if (timer > THRESHOLD) begin
        pace_out <= 1; // Trigger pacing pulse
        timer <= 0;
      end else begin
        pace_out <= 0;
      end
    end
  end
endmodule

