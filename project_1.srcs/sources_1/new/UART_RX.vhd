library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_def.all;
entity UART_RX is Port ( 
    clk         :in std_logic;
    rst         :in std_logic;
    uart_rxd     :in std_logic;
    rx_data     :out std_logic_vector(7 downto 0);
    tx_enable   :out std_logic);
end UART_RX;

architecture Behavioral of UART_RX is

component baud is Port (
    clk              :in std_logic;
    rst          :in std_logic;
    enable        :in std_logic;
    bps_clk     :out std_logic);
end component;

signal uart_rxd_ff0,uart_rxd_ff1,uart_rxd_ff2 :std_logic;
signal rx_data_r :std_logic_vector(7 downto 0);
signal cnt          :integer range 0 to 10;
signal baund_enable ,bps_clk,neg_rxd :std_logic;
begin

rx_baud :baud port map(
    clk => clk,
    rst => rst,
    enable =>baund_enable,
    bps_clk => bps_clk);
    
process(rst,clk,uart_rxd,uart_rxd_ff0,uart_rxd_ff1,uart_rxd_ff2)--延時去除亞穩態
begin
    
if rst = '1' then
    uart_rxd_ff0 <= '1';
    uart_rxd_ff1 <= '1';
    uart_rxd_ff2 <= '1';
else
    if rising_edge(clk)then
        uart_rxd_ff0 <= uart_rxd;
        uart_rxd_ff1 <= uart_rxd_ff0;
        uart_rxd_ff2 <= uart_rxd_ff1;
    end if;
end if;
--neg_rxd <= uart_rxd_ff2 and uart_rxd_ff1 and (not uart_rxd_ff0) and (not uart_rxd);
neg_rxd <= uart_rxd_ff2;
end process;

process(clk,rst,neg_rxd,cnt)
begin
if rst = '1' then
    baund_enable <= '0';
else
    if cnt = 10 then
        baund_enable <= '0';   
    elsif neg_rxd  = '0' then
        baund_enable <= '1';
    end if;
end if;
end process;
process(bps_clk,rst,uart_rxd_ff2,cnt,rx_data_r)
begin
if rst = '1' then
    rx_data_r <= (others => '0');
    rx_data <= (others => '0');
    tx_enable <= '0';   
    cnt <= 0;
else
    if rising_edge(bps_clk)then
        cnt <= cnt +1;
        if 0< cnt and cnt < 9 then
            rx_data_r(cnt-1) <= uart_rxd_ff2;    
        end if;      
    end if;
    if cnt = 9 then        
        rx_data <= rx_data_r;
        tx_enable <= '1';
    end if;
    if cnt = 10 then
        cnt <= 0;
        tx_enable <= '0';      
    end if;
end if;
end process;
end Behavioral;
