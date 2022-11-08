library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_def.all;

entity UART_TX is Port ( 
    clk         :in std_logic;
    rst         :in std_logic;
    tx_en   :in std_logic;
    b_enable : out std_logic;
    uart_txd     :out std_logic;
    tx_data     :in std_logic_vector(7 downto 0));
end UART_TX;

architecture Behavioral of UART_TX is


component baud is Port (
    clk              :in std_logic;
    rst          :in std_logic;
    enable        :in std_logic;
    bps_clk     :out std_logic);
end component;

signal tx_en_ff0,tx_en_ff1,tx_en_ff2,tx_en_ff:std_logic;
signal cnt,tx_cnt : integer range 0 to 10;
signal baund_enable ,bps_clk :std_logic;
signal tx_data_all : std_logic_vector(9 downto 0);
begin

tx_baud :baud port map(
    clk => clk,
    rst => rst,
    enable =>baund_enable,
    bps_clk => bps_clk);

process(clk,rst,tx_en,tx_en_ff0,tx_en_ff1,tx_en_ff2)
begin
if rst = '1' then
    tx_en_ff0 <= '0';
    tx_en_ff1 <= '0';
    tx_en_ff1 <= '0';
else
    if rising_edge(clk)then
        tx_en_ff0 <= tx_en;
        tx_en_ff1 <= tx_en_ff0;
        tx_en_ff2 <= tx_en_ff1;
    end if;
end if;
end process;

process(rst,tx_en_ff2,cnt,tx_data)
begin
if rst = '1'then
    baund_enable <= '0' ; 
    tx_data_all <= (others => '0');
else
    if  rising_edge(tx_en_ff2) then
        baund_enable <= '1' ;
        tx_data_all <= '1' & tx_data & '0';
    end if;
    if cnt = 10 then
        baund_enable <= '0';
    end if;      
end if;
b_enable <= baund_enable;
end process;
process(rst,bps_clk,cnt,tx_data_all,baund_enable)
begin
if rst = '1' then
    uart_txd <= '1';
    cnt <= 0;
else
    if rising_edge(bps_clk)then
        cnt <= cnt + 1;
        uart_txd <= tx_data_all(cnt-1);
    end if;
    if cnt = 10 then
        cnt <= 0;
    end if;        
end if;
end process;
end Behavioral;
