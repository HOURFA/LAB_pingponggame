----------------------------------------------------------------------------------
-- Company: NKUST
-- Engineer: RFA
-- 
-- Create Date: 2022/11/23 20:30:01
-- Design Name: 
-- Module Name: Transmission_module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Transmission_module is Port ( 
    i_clk   :  in std_logic;
    i_rst   :  in std_logic;
    i_rx   :  in std_logic;
--
    i_i2c_sda : inout std_logic;
    i_i2c_scl : inout std_logic;
    i_i2c_rw : in std_logic;
    i_act : in std_logic_vector(2 downto 0);
    i_led_loc : in std_logic_vector(3 downto 0);
    i_i2c_en : in std_logic;
    i_prestate : in std_logic;
    o_i2c_data_s2m : out std_logic_vector(7 downto 0);
--
    i_display_en   : in std_logic;
    i_score_left_sig            :  in std_logic_vector(3 downto 0);
    i_score_right_sig            :  in std_logic_vector(3 downto 0);
    o_tx  : out std_logic;
    o_buttom_left   : out std_logic;
    o_buttom_right : out std_logic;
    o_rst_system : out std_logic;
    o_random_enable : out std_logic;
    o_game_start : out std_logic;
    o_random_bound : out integer    
);
end Transmission_module;

architecture Behavioral of Transmission_module is

component I2C_master is Port ( 
    clk     : in std_logic;
    rst     : in std_logic;
    en   : in std_logic;
    rw   : in std_logic;    
    addr_in : in std_logic_vector(7 downto 0);
    data_in : in std_logic_vector(7 downto 0);  --要傳給slave的數據 
    data_out : out std_logic_vector(7 downto 0);--slave傳回來的數據     
    sda     : inout std_logic;
    scl     : inout std_logic);
end component;

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

component input_controller is Port (
    rst : in STD_LOGIC;
    clk : in STD_LOGIC; 
    clr : in STD_LOGIC;
    ascii_in : in STD_LOGIC_VECTOR(7 downto 0);
    enter       :out STD_LOGIC;
    buttom_left : out STD_LOGIC;
    buttom_right : out STD_LOGIC);
end component;

component output_controller is Port (
    rst : in STD_LOGIC;
    clk : in STD_LOGIC;
    display_en : in STD_LOGIC;
    setting_in : in STD_LOGIC_VECTOR(7 downto 0);    
    score_left : in STD_LOGIC_VECTOR (3 downto 0);
    score_right : in STD_LOGIC_VECTOR (3 downto 0);
    tx_series : out STD_LOGIC_VECTOR (7 downto 0);
    tx_en : out std_logic;
    rst_system : out std_logic;
    DIV_CLK_CONSTANT : out integer;
    random_en        : out STD_LOGIC;
    game_start :  out std_logic);
end component;

signal rx_series ,setting_in:std_logic_vector(7 downto 0);
signal tx_series :std_logic_vector(7 downto 0);
signal div_clk  , div_50Mhz: std_logic;
signal tx_enable,baund_enable : std_logic;
signal s_en,enter : std_logic;
signal random_value : std_logic_vector(3 downto 0);


signal i2c_data_m2s ,s2m,m2s: std_logic_vector(7 downto 0);
begin
i2c_data_m2s <= i_prestate & i_led_loc & i_act;
s_en <=    i_display_en or enter;    
master : I2C_master port map(
    clk => i_clk,
    sda => i_i2c_sda,
    scl => i_i2c_scl,
    rst => i_rst,
    rw => i_i2c_rw,
    en => i_i2c_en,
    addr_in => "10101010",
    data_in => i2c_data_m2s,
    data_out => o_i2c_data_s2m
);
----   
rx_uart : UART_RX port map(
    clk                => i_clk,
    rst                => i_rst,
    uart_rxd           => i_rx,
    rx_data            => rx_series);    
    
tx_uart : UART_TX port map(
    clk                => i_clk,
    rst                => i_rst,
    tx_en              => tx_enable,
    uart_txd           => o_tx,
    tx_data            => tx_series);
    
input : input_controller port map(
    rst                => i_rst,
    clk                => i_clk,
    clr                => i_display_en,
    ascii_in           => rx_series,
    enter              => enter,
    buttom_left        => o_buttom_left,
    buttom_right       => o_buttom_right);   
        
output : output_controller port map(
    rst                => i_rst,
    clk                => i_clk,
    setting_in         => rx_series,
    display_en         => s_en,
    score_left         => i_score_left_sig,
    score_right        => i_score_right_sig,
    tx_series          => tx_series,
    tx_en              => tx_enable,
    rst_system         => o_rst_system,
    DIV_CLK_CONSTANT   => o_random_bound,
    random_en          => o_random_enable,
    game_start         => o_game_start); 

end Behavioral;
