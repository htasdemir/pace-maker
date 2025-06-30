# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def pacemaker_test(dut):
    """ Test that pacemaker generates a pacing pulse when no heartbeat is detected """

    # Start the clock (12 MHz clock = period ~83ns)
    clock = Clock(dut.clk, 83, units="ns")
    cocotb.start_soon(clock.start())

    # Initial reset
    dut.io_in.value = 0
    dut._log.info("Applying reset...")
    dut.io_in[1].value = 1  # Reset high
    await Timer(100, units="ns")
    dut.io_in[1].value = 0  # Release reset

    # Step 1: No heartbeat for long time → Expect pacing pulse
    dut._log.info("Waiting for timeout to trigger pacing...")
    pacing_detected = False
    for cycle in range(30000000):  # Enough cycles to exceed TIMEOUT
        await RisingEdge(dut.clk)
        if dut.io_out[0].value == 1:
            pacing_detected = True
            dut._log.info(f"Pacing pulse generated at cycle {cycle}")
            break

    assert pacing_detected, "Pacemaker did not generate pacing pulse after timeout!"

    # Step 2: Send a heartbeat, verify no pacing pulse is generated
    dut.io_in[0].value = 1  # Simulate heartbeat pulse
    await Timer(100, units="ns")
    dut.io_in[0].value = 0

    dut._log.info("After heartbeat, checking no pacing pulse is generated soon after...")
    for cycle in range(1000000):
        await RisingEdge(dut.clk)
        assert dut.io_out[0].value == 0, "Unexpected pacing pulse after heartbeat!"

    dut._log.info("Pacemaker passed both tests ✅")
