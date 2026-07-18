# HDLModuleExamples

![Language](https://img.shields.io/badge/language-VHDL-c084fc?style=flat-square)
![Status](https://img.shields.io/badge/status-reference-c084fc?style=flat-square)

Reusable, parameterized VHDL building blocks I keep around as copy-paste starting
points for FPGA projects. Each module is self-contained with `generic`s for the
common knobs, so it drops into Vivado / Quartus / Gowin without modification.

## Modules

### `Uart_TX` — UART transmitter

8-N-{1,2} UART transmitter. One-shot send: assert `tx_start_i` for one clock
with `din_i` valid, then wait for `tx_done_tick_o`.

| Generic        | Default       | Notes                  |
|----------------|---------------|------------------------|
| `c_clkfreq`    | `100_000_000` | System clock in Hz     |
| `c_baudrate`   | `115200`      | UART baud rate         |
| `c_stopbit`    | `2`           | Number of stop bits    |

| Port              | Dir | Width | Purpose                          |
|-------------------|-----|-------|----------------------------------|
| `clk`             | in  | 1     | System clock                     |
| `din_i`           | in  | 8     | Byte to send                     |
| `tx_start_i`      | in  | 1     | One-shot start strobe            |
| `tx_o`            | out | 1     | UART line                        |
| `tx_done_tick_o`  | out | 1     | One-clock pulse when byte sent   |

### `Uart_RX` — UART receiver

Companion receiver. `rx_done_tick_o` pulses for one clock when a full byte has
been captured into `dout_o`.

| Generic        | Default       | Notes                  |
|----------------|---------------|------------------------|
| `c_clkfreq`    | `100_000_000` | System clock in Hz     |
| `c_baudrate`   | `115200`      | UART baud rate         |

| Port              | Dir | Width | Purpose                          |
|-------------------|-----|-------|----------------------------------|
| `clk`             | in  | 1     | System clock                     |
| `rx_i`            | in  | 1     | UART line                        |
| `dout_o`          | out | 8     | Received byte                    |
| `rx_done_tick_o`  | out | 1     | One-clock pulse when byte ready  |

### `top` — UART loopback example

Top-level wiring of `Uart_RX` + `Uart_TX`: every byte received is echoed back.
A red LED toggles on receive activity, green on transmit. Good "blinky" for
verifying a board's UART pins.

## Quick instantiate

```vhdl
U_TX : entity work.uart_tx
  generic map (
    c_clkfreq  => 50_000_000,
    c_baudrate => 921_600,
    c_stopbit  => 1
  )
  port map (
    clk            => clk_i,
    din_i          => data_byte,
    tx_start_i     => byte_ready,
    tx_o           => uart_tx_pin,
    tx_done_tick_o => tx_done
  );
```

## Notes

- Tested on a Xilinx 7-series part with the bundled `top.vhd`; H616 / Gowin
  ports should work — just match `c_clkfreq` to your PLL output.
- No testbench in this repo yet — running each module under GHDL or Vivado XSim
  with the obvious stimulus is straightforward.

## License

MIT.
