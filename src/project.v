/*
 * Copyright (c) 2024 Hakan Tasdemir
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none
module tt_um_example (
    input  wire        clk,      // System clock
    input  wire [7:0]  io_in,    // Input pins (heartbeat, reset, etc.)
    output wire [7:0]  io_out,   // Output pins (pacing pulse, etc.)
    output wire [7:0]  io_oeb    // Output enable (active low, keep outputs enabled)
);

    // Instantiate your user module (pacemaker logic)
    user_module user_inst (
        .clk(clk),
        .io_in(io_in),
        .io_out(io_out)
    );

    // Keep outputs always enabled
    assign io_oeb = 8'b0;

endmodule
