library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_def.all;

entity UART is Port ( 
    clk              :in std_logic;
    divclk  :in std_logic;
    rst          :in std_logic;
    rx               :in std_logic;
    tx               :out std_logic;
    new_sig     :out std_logic;
    buttom_left : out STD_LOGIC;
    buttom_right : out STD_LOGIC);
end UART;

architecture Behavioral of UART is
component UART_RX is Port ( 
    clk         :in std_logic;
    rst         :in std_logic;
    uart_rxd     :in std_logic;
    rx_data     :out std_logic_vector(7 downto 0);
    tx_enable   :out std_logic);
end component;
component UART_TX is Port ( 
    clk         :in std_logic;
    rst         :in std_logic;
    tx_en   :in std_logic;
    uart_txd     :out std_logic;
    tx_data     :in std_logic_vector(7 downto 0));
end component;
component ASCII_decoder is
    Port (
            rst : in STD_LOGIC;
            clk : in STD_LOGIC; 
            en  : in STD_LOGIC;
            ascii_in : in STD_LOGIC_VECTOR(7 downto 0);
            buttom_left : out STD_LOGIC;
            buttom_right : out STD_LOGIC
    );
end component;
signal rx_data,pre_rx,ascii_in :std_logic_vector(7 downto 0);
signal div_clk : std_logic;
signal tx_enable,baund_enable : std_logic;
begin  

new_sig <= tx_enable;
rx_uart : UART_RX port map(
    clk => clk,
    rst => rst,
    uart_rxd =>rx,
    rx_data => rx_data,
    tx_enable => tx_enable);
tx_uart : UART_TX port map(
    clk => clk,
    rst => rst,
    tx_en => tx_enable,
    uart_txd => tx,
    tx_data => rx_data);
ascii : ASCII_decoder port map(
    rst  => rst,
    clk => divclk,
    en  => tx_enable,
    ascii_in => rx_data,
    buttom_left  => buttom_left,
    buttom_right => buttom_right);        
end Behavioral;
