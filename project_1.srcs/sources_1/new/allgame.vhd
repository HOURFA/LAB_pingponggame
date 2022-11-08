library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.constant_def.all;
use work.ascii_decoder_lib.all;
entity allgame is 
    port(
        rst                  :  in std_logic;
        clk                  :  in std_logic;
        rx                   :  in std_logic;
        lcd_en : in std_logic;
        buttom_player_left   :  in std_logic;
        buttom_player_right  :  in std_logic;
        tx                       : out std_logic;
        led_bus              : out std_logic_vector(LED_NUM - 1 downto 0);
        score_left           : out std_logic_vector(6 downto 0);
        score_right          : out std_logic_vector(6 downto 0);
        sda : inout std_logic;
        scl : out std_logic;
        led : out std_logic_vector(5 downto 0)
    );           
end allgame;
architecture game of allgame is

component div is
    port(
        rst                  :  in std_logic;
        clk_in               :  in std_logic;
        clk_out              : out std_logic
    );
end component;

component buttom is
    port(
        rst                  :  in std_logic;
        clk                  :  in std_logic;
        click                :  in std_logic;
        buttom               : out std_logic
    );
end component;

component FSM is 
    port(
        rst                  :  in std_logic;
        clk                  :  in std_logic;
        click_left           :  in std_logic;
        click_right          :  in std_logic;        
        led_loc              :  in std_logic_vector(3 downto 0 );
        display_en         :  out std_logic;        
        prestate             : out std_logic;
        led_act              : out std_logic_vector(2 downto 0);
        score_left           : out std_logic_vector(3 downto 0);
        score_right          : out std_logic_vector(3 downto 0)
    );
end component;

component seven_seg is
    port(
        num_in               :  in std_logic_vector(3 downto 0);
        num_out              : out std_logic_vector(6 downto 0)
    );
end component;
component led_action is
    Port (
        rst                  :  in std_logic;
        clk                  :  in std_logic;
        prestate             :  in std_logic;
        act                  : in std_logic_vector(2 downto 0);
        led                  : out std_logic_vector(3 downto 0)
    );
end component;
component led8 is
    port(
        q                    :  in std_logic_vector(3 downto 0);
        led                  : out std_logic_vector(LED_NUM - 1 downto 0)
     );
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

component score_decoder is
    Port (
            rst : in STD_LOGIC;
            clk : in STD_LOGIC;
            display_en : in STD_LOGIC;
            score_left : in STD_LOGIC_VECTOR (3 downto 0);
            score_right : in STD_LOGIC_VECTOR (3 downto 0);
            tx_series : out STD_LOGIC_VECTOR (7 downto 0);
            tx_en : out std_logic;
            empty : OUT STD_LOGIC
    );
end component;

component UART is Port ( 
    clk              :in std_logic;
    divclk     :in std_logic;
    rst          :in std_logic;
    rx               :in std_logic;
    tx               :out std_logic;
    new_sig     :out std_logic;
    buttom_left : out STD_LOGIC;
    buttom_right : out STD_LOGIC);
end component;

component I2C_master is Port ( 
    clk     : in std_logic;
    rst     : in std_logic;
    en   : in std_logic;
    rw   : in std_logic;    
    addr_in : in std_logic_vector(6 downto 0);
    data_master_in : in std_logic_vector(7 downto 0);  --要傳給slave的數據 
    data_master_out : out std_logic_vector(7 downto 0);--slave傳回來的數據     
    sda     : inout std_logic;
    scl     : out std_logic;
    state : out std_logic_vector(5 downto 0));
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

signal rx_data :std_logic_vector(7 downto 0);
signal tx_series :std_logic_vector(7 downto 0);
signal div_clk : std_logic;
signal tx_enable,baund_enable : std_logic;
signal new_sig,score_en,sda_master : std_logic;

begin

click_left <= buttom_player_left or uart_player_left;
click_right <= buttom_player_right or uart_player_right;



div1    : div      port map(
                        rst                => rst,
                        clk_in             => clk,
                        clk_out            => divclk
                    );
left    : buttom    port map(
                        rst                => rst,
                        clk                => clk,
                        click              => click_left,
                        buttom             => de_buttom_left_sig
                    );
right   : buttom    port map(
                        rst                => rst,
                        clk                => clk,
                        click              => click_right,
                        buttom             => de_buttom_right_sig
                    );
SYSTEM  : FSM       port map(
                        rst                => rst,
                        clk                => divclk,
                        led_loc            => led_reg,
                        click_left         => de_buttom_left_sig,
                        click_right        => de_buttom_right_sig,
                        score_left         => score_left_sig,
                        score_right        => score_right_sig,
                        display_en         => display_en,
                        led_act            => act,
                        prestate           => ps
                    );
led_act : led_action port map (
rst         => rst,
                              clk           => divclk,
                              prestate      => ps,
                              act           => act,
                              led           => led_reg
                              );
s_left  : seven_seg port map(
                        num_in             => score_left_sig,
                        num_out            => score_left
                    );
s_right : seven_seg port map(
                        num_in             => score_right_sig,
                        num_out            => score_right
                    );
l       : led8      port map(
                        q                  => led_reg,
                        led                => led_bus
                    );

                               
rx_uart : UART_RX port map(
    clk => clk,
    rst => rst,
    uart_rxd =>rx,
    rx_data => rx_data,
    tx_enable => tx_enable);    
tx_uart : UART_TX port map(
    clk => clk,
    rst => rst,
    tx_en => display_en,
    uart_txd => tx,
    tx_data => tx_series);
ascii : ASCII_decoder port map(
    rst  => rst,
    clk => divclk,
    en  => tx_enable,
    ascii_in => rx_data,
    buttom_left  => uart_player_left,
    buttom_right => uart_player_right);      
s_decoder : score_decoder port map(
            rst => rst,
            clk => clk,
            display_en => display_en,
            score_left  => score_left_sig,
            score_right =>score_right_sig,
            tx_series => tx_series,
            tx_en  => score_en);
            
            
master : I2C_master port map(
    clk => clk,
    sda => sda,
    scl => scl,
    rst => rst,
    rw => '0',
    en => lcd_en,
    addr_in => "0100000",--0x27 0100111     --0x3f 0111000
    data_master_in => "00001110",
    state => led);       
    
end game;