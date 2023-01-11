library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity I2C is Port (
    clk : in std_logic;
    rst : in std_logic;
    rw  : in std_logic;
    en : in std_logic;
    addr_in_master : in std_logic_vector(7 downto 0);
    data_in_master : in std_logic_vector(7 downto 0);
    data_in_slave : in std_logic_vector(7 downto 0);
    data_out_master : out std_logic_vector(7 downto 0);
    data_out_slave : out std_logic_vector(7 downto 0));
end I2C;

architecture Behavioral of I2C is
component I2C_master is Port ( 
    clk     : in std_logic;
    rst     : in std_logic;
    en   : in std_logic;
    rw   : in std_logic;    
    addr_in : in std_logic_vector(7 downto 0);
    data_master_in : in std_logic_vector(7 downto 0);  --要傳給slave的數據 
    data_master_out : out std_logic_vector(7 downto 0);--slave傳回來的數據     
    sda     : inout std_logic;
    scl     : out std_logic);
end component;

signal sda,scl : std_logic;

begin

master : I2C_master port map(
    clk => clk,
    sda => sda,
    scl => scl,
    rst => rst,
    rw => rw,
    en => en,
    addr_in => addr_in_master,
    data_master_in => data_in_master,
    data_master_out => data_out_master);

end Behavioral;
