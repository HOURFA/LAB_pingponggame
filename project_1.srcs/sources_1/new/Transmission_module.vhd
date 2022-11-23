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

begin

s_en <=    i_display_en or enter;    


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
