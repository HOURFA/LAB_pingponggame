library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.constant_def.all;
use work.ascii_decoder_lib.all;
entity allgame is port(
    rst                  :  in std_logic;
    clk                  :  in std_logic;
    rx                   :  in std_logic;
    buttom_player_left   :  in std_logic;
    buttom_player_right  :  in std_logic;
    tx                       : out std_logic;
    led_bus              : out std_logic_vector(LED_NUM - 1 downto 0));           
end allgame;
architecture game of allgame is

component div is port(
    rst                      :  in std_logic;
    UB                    :  in integer;
    clk_in                :  in std_logic;
    clk_out              : out std_logic);
end component;

component buttom is port(
    rst                  :  in std_logic;
    clk                  :  in std_logic;
    click                :  in std_logic;
    buttom               : out std_logic);
end component;

component FSM is port(
    rst                  :  in std_logic;
    clk                  :  in std_logic;
    click_left           :  in std_logic;
    click_right          :  in std_logic;        
    led_loc              :  in std_logic_vector(3 downto 0 );
    display_en         :  out std_logic;        
    prestate             : out std_logic;
    led_act              : out std_logic_vector(2 downto 0);
    score_left           : out std_logic_vector(3 downto 0);
    score_right          : out std_logic_vector(3 downto 0));
end component;

component led_action is Port (
    rst                  :  in std_logic;
    clk                  :  in std_logic;
    prestate             :  in std_logic;
    act                  : in std_logic_vector(2 downto 0);
    led                  : out std_logic_vector(3 downto 0));
end component;

component led8 is port(
    q                    :  in std_logic_vector(3 downto 0);
    led                  : out std_logic_vector(LED_NUM - 1 downto 0));
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
    DIV_CLK_CONSTANT : out integer);
end component;

signal score_left_sig            :std_logic_vector(3 downto 0);
signal score_right_sig           :std_logic_vector(3 downto 0);
signal led_reg               :std_logic_vector(3 downto 0);
signal act                   :std_logic_vector(2 downto 0);
signal divclk                :std_logic;
signal de_buttom_left_sig    :std_logic;
signal de_buttom_right_sig   :std_logic;
signal display_en : std_logic;

signal uart_player_left    :std_logic;
signal uart_player_right    :std_logic;

signal click_left : std_logic;
signal click_right: std_logic;

signal ps                    :std_logic;

signal rx_data ,de_bug,setting_in:std_logic_vector(7 downto 0);
signal tx_series :std_logic_vector(7 downto 0);
signal div_clk : std_logic;
signal tx_enable,baund_enable : std_logic;
signal rst_system,rst_all,score_en,sda_master,rx_en,enter,s_en: std_logic;
signal DIV_CLK_CONSTANT : integer;

begin

click_left <= buttom_player_left or uart_player_left;
click_right <= buttom_player_right or uart_player_right;
rst_all <= rst or rst_system;
div1    : div      port map(
    rst                => rst_all,
    UB                 => DIV_CLK_CONSTANT,
    clk_in             => clk,
    clk_out            => divclk);
left    : buttom    port map(
    rst                => rst_all,
    clk                => clk,
    click              => click_left,
    buttom             => de_buttom_left_sig);
right   : buttom    port map(
    rst                => rst_all,
    clk                => clk,
    click              => click_right,
    buttom             => de_buttom_right_sig);
SYSTEM  : FSM       port map(
    rst                => rst_all,
    clk                => divclk,
    led_loc            => led_reg,
    click_left         => de_buttom_left_sig,
    click_right        => de_buttom_right_sig,
    score_left         => score_left_sig,
    score_right        => score_right_sig,
    display_en         => display_en,
    led_act            => act,
    prestate           => ps);
led_act : led_action port map (
    rst                => rst_all,
    clk                => divclk,
    prestate           => ps,
    act                => act,
    led                => led_reg);
l       : led8      port map(
    q                  => led_reg,
    led                => led_bus);                              
rx_uart : UART_RX port map(
    clk                => clk,
    rst                => rst_all,
    uart_rxd           => rx,
    rx_data            => rx_data,
    tx_enable          => tx_enable);    
tx_uart : UART_TX port map(
    clk                => clk,
    rst                => rst_all,
    tx_en              => score_en,
    uart_txd           => tx,
    tx_data            => tx_series);
input : input_controller port map(
    rst                => rst_all,
    clk                => divclk,
    ascii_in           => rx_data,
    enter              => enter,
    buttom_left        => uart_player_left,
    buttom_right       => uart_player_right);   
    
s_en <=    display_en or enter;
    
output : output_controller port map(
    rst                => rst_all,
    clk                => clk,
    setting_in         => rx_data,
    display_en         => s_en,
    score_left         => score_left_sig,
    score_right        => score_right_sig,
    tx_series          => tx_series,
    tx_en              => score_en,
    rst_system         => rst_system,
    DIV_CLK_CONSTANT   => DIV_CLK_CONSTANT); 
process(display_en)
begin
    if display_en = '1'then
        de_bug <= "11111111";
    else
        de_bug<= rx_data;
    end if;
end process;      
end game;