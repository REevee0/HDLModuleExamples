library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity top is
  generic
  (
    c_clkfreq  : integer := 100_000_000;
    c_baudrate : integer := 115_200;
    c_stopbit   : integer := 2
  );
  port
  (
    clk_i    : in std_logic;
    rx_i     : in std_logic;
    tx_o     : out std_logic;
    redLED   : out std_logic;
    greenLED : out std_logic
  );
end top;

architecture Behavioral of top is

  component Uart_RX is
    generic
    (
      c_clkfreq  : integer := 100_000_000;
      c_baudrate : integer := 115_200
    );
    port
    (
      clk            : in std_logic;
      rx_i           : in std_logic;
      dout_o         : out std_logic_vector (7 downto 0);
      rx_done_tick_o : out std_logic
    );
  end component;

  component uart_tx is
    generic
    (
      c_clkfreq  : integer := 100_000_000;
      c_baudrate : integer := 115200;
      c_stopbit  : integer := 2
    );
    port
    (
      clk            : in std_logic;
      din_i          : in std_logic_vector (7 downto 0);
      tx_start_i     : in std_logic;
      tx_o           : out std_logic;
      tx_done_tick_o : out std_logic
    );
  end component;

  signal RXBuf : std_logic_vector (7 downto 0);
  signal red   : std_logic;
  signal inv   : std_logic;
  
begin
    i_uart_rx : Uart_RX 
    generic map
        (
          c_clkfreq  => c_clkfreq,
          c_baudrate => c_baudrate
        )
        port map
        (
          clk            => clk_i,
          rx_i           => rx_i,
          dout_o         => RXBuf,
          rx_done_tick_o  => red
        );
    o_uart_tx : uart_tx
    generic map
        (
          c_clkfreq  => c_clkfreq,
          c_baudrate => c_baudrate,
          c_stopbit  => c_stopbit
        )
        port map
        (
          clk            => clk_i,
          din_i          => RXBuf,
          tx_start_i     => red,
          tx_o           => tx_o,
          tx_done_tick_o => inv
        );
        greenLED <= inv;
        redLED <= red;
end Behavioral;