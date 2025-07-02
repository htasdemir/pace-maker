/*
 * Copyright (c) 2024 Hakan Tasdemir
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none
module project (
    input  wire        clk,
    input  wire [7:0]  io_in,
    output wire [7:0]  io_out,
    output wire [7:0]  io_oeb
);

    user_module user_inst (
        .clk(clk),
        .io_in(io_in),
        .io_out(io_out)
    );

    assign io_oeb = 8'b0;

endmodule
"""
with open(os.path.join(src_path, "project.v"), "w") as f:
    f.write(project_v)

# Create info.yaml
info_yaml = """\
project:
  name: "Simple Pacemaker Controller"
  owner: "Your Name"
  github_user: "htasdemir"
  description: |
    A simple digital pacemaker controller that generates a pacing pulse
    if no heartbeat is detected within a preset timeout interval.

  language: "Verilog"
  clock_hz: 12000000
  inputs: 2
  outputs: 1
  bidirectional: 0
  sequential: true
  testbench: "tb.v"
  source_files:
    - "src/project.v"
    - "src/user_module.v"
