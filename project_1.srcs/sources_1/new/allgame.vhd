library IEEE;
use IEEE.std_logic_1164.all;
package constant_def is
    constant CLK_CONSTANT        : integer := 100000000;        --100MHz 
    constant DIV_CLK_CONSTANT    : integer := 35000000;         --T = 0.35s
    constant DEBOUNCE_CONSTANT   : integer := 2000;
    constant LED_NUM             : integer := 8;

end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.constant_def.all;
entity allgame is 
    port(
        rst                  :  in std_logic;
        clk                  :  in std_logic;
        buttom_player_left   :  in std_logic;
        buttom_player_right  :  in std_logic;
        led_bus              : out std_logic_vector(LED_NUM - 1 downto 0);
        score_left           : out std_logic_vector(6 downto 0);
        score_right          : out std_logic_vector(6 downto 0)
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

signal score_left_sig            :std_logic_vector(3 downto 0);
signal score_right_sig           :std_logic_vector(3 downto 0);
signal led_reg               :std_logic_vector(3 downto 0);
signal act                   :std_logic_vector(2 downto 0);
signal divclk                :std_logic;
signal de_buttom_left_sig    :std_logic;
signal de_buttom_right_sig   :std_logic;
signal ps                    :std_logic;

begin
div1    : div      port map(
                        rst                => rst,
                        clk_in             => clk,
                        clk_out            => divclk
                    );
left    : buttom    port map(
                        rst                => rst,
                        clk                => clk,
                        click              => buttom_player_left,
                        buttom             => de_buttom_left_sig
                    );
right   : buttom    port map(
                        rst                => rst,
                        clk                => clk,
                        click              => buttom_player_right,
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
end game;