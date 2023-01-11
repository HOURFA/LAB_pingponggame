----------------------------------------------------------------------------------
-- Company:  NKUST
-- Engineer:  RFA
-- 
-- Create Date: 2022/11/09 20:07:47
-- Design Name: 
-- Module Name: random_genetor - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.constant_def.all;

entity allgame is port(
    rst                  :  in std_logic;
    clk                  :  in std_logic;
    rx                   :  in std_logic;
    buttom_player_right  :  in std_logic;
    tx                       : out std_logic;
    led_bus              : out std_logic_vector(LED_NUM - 1 downto 0);
   Rout            : out std_logic_vector(3 downto 0); --
   Gout            : out std_logic_vector(3 downto 0); --
   Bout            : out std_logic_vector(3 downto 0); -- 
   hsync           : out std_logic;
   vsync           : out std_logic;
   dinout          : inout std_logic
--   --
--    scl : inout std_logic;
--    sda : inout std_logic
--   --
   );           
end allgame;
architecture game of allgame is



component buttom is port(
    rst                  :  in std_logic;
    clk                  :  in std_logic;
    click                :  in std_logic;
    buttom               : out std_logic);
end component;

component Divider_module is Port (
    i_clk                        :  in std_logic;
    i_rst                         :  in std_logic;
    i_UB                       :  in integer; 
    i_random_en          :  in std_logic;
    o_random_div        : out std_logic;
    o_VGA_div            : out std_logic);
end component;

component Transmission_module is Port ( 
    i_clk   :  in std_logic;
    i_rst   :  in std_logic;
    i_rx   :  in std_logic;
----
--    i_i2c_sda : inout std_logic;
--    i_i2c_scl : inout std_logic;
--    i_i2c_rw : in std_logic;
--    i_act : in std_logic_vector(2 downto 0);
--    i_led_loc : in std_logic_vector(3 downto 0);
--    i_i2c_en : in std_logic;
--    i_prestate : in std_logic;
--    o_i2c_data_s2m : out std_logic_vector(7 downto 0);
----    
    i_display_en    : in std_logic;
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
end component;
--
signal i_i2c_rw : std_logic;
signal i_i2c_en : std_logic;
signal i_i2c_data_m2s : std_logic_vector(7 downto 0);
signal o_i2c_data_s2m : std_logic_vector(7 downto 0);
--
component Display_module is Port (
    i_random_clk  : in std_logic;
    i_VGA_clk  : in std_logic;
    i_rst   : in std_logic;
    i_prestate  : in std_logic;
    i_act   : in std_logic_vector(2 downto 0);
    o_led_bus : out std_logic_vector(LED_NUM - 1 downto 0);
    o_led_loc   : out std_logic_vector(3 downto 0);
    o_Rout : out std_logic_vector(3 downto 0);
    o_Gout : out std_logic_vector(3 downto 0);
    o_Bout : out std_logic_vector(3 downto 0);
    o_hsync : out std_logic;
    o_vsync : out std_logic
);
end component;

component Controller_module is port(
    i_rst                  :  in std_logic;
    i_clk                  :  in std_logic;
    i_en                   :  in std_logic;
    i_click_left           :  in std_logic;
    i_click_right          :  in std_logic;        
    i_led_loc              :  in std_logic_vector(3 downto 0 );
    o_display_en         :  out std_logic;        
    o_prestate             : out std_logic;
    o_led_act              : out std_logic_vector(2 downto 0);
    o_score_left           : out std_logic_vector(3 downto 0);
    o_score_right          : out std_logic_vector(3 downto 0);
    d_trans              : out std_logic;
    d_receive           : in std_logic;     
    o_i2c_rw                : out std_logic);
end component;
 
component Transmission is
    Port (
            clk       :  in std_logic;
            rst       :  in std_logic;
            data_trans :   in std_logic;
            data_receive      : out std_logic;
            Dinout : inout std_logic
    );
end component;
 
signal divclk                :std_logic;
signal de_buttom_left_sig,de_buttom_right_sig ,uart_player_left,uart_player_right ,sig_display_enable  :std_logic;
signal sig_random_enable,sig_random_div,sig_VGA_div,sig_game_start :std_logic;
signal rst_all,rst_system : std_logic;
signal click_left : std_logic;
signal click_right,sig_prestate: std_logic;
signal sig_led_loc ,sig_score_left,sig_score_right: std_logic_vector(3 downto 0);
signal sig_led_act : std_logic_vector(2 downto 0);
signal sig_UB : integer;

signal i2c_en ,d_trans,d_receive: std_logic;

begin

click_left <= de_buttom_left_sig or uart_player_left or o_i2c_data_s2m(7);

click_right <= de_buttom_right_sig or uart_player_right;
rst_all <= rst or rst_system;


right   : buttom    port map(
    rst                => rst_all,
    clk                => clk,
    click              => buttom_player_right,
    buttom             => de_buttom_right_sig);

DIVIDER : Divider_module Port map(
    i_clk           => clk,        
    i_rst           => rst_all,  
    i_UB            => sig_UB,       
    i_random_en     => sig_random_enable, 
    o_random_div    => sig_random_div,
    o_VGA_div       => sig_VGA_div
    );
CONTROLLER :  Controller_module port map(
    i_rst             => rst_all,
    i_clk             => sig_random_div,
    i_en              => sig_game_start,
    i_click_left      => click_left, 
    i_click_right     => click_right,
    i_led_loc         => sig_led_loc,
    o_display_en      => sig_display_enable,
    o_prestate        => sig_prestate,  
    o_led_act         => sig_led_act,    
    o_score_left      => sig_score_left, 
    o_score_right     => sig_score_right,
    d_trans           => d_trans,
    d_receive         => d_receive,
    o_i2c_rw          => i_i2c_rw
    );

DISPLAY : Display_module Port map(
    i_random_clk    => sig_random_div,
    i_VGA_clk       => sig_VGA_div,
    i_rst           => rst_all,
    i_prestate      => sig_prestate,
    i_act           => sig_led_act,
    o_led_bus       => led_bus,
    o_led_loc       => sig_led_loc,
    o_Rout          => Rout,
    o_Gout          => Gout,
    o_Bout          => Bout,
    o_hsync         => hsync,
    o_vsync         => vsync
);   
process(rst)
begin
    if rst = '1'then
        i2c_en <= '0';
    elsif sig_led_loc > "00111"then
        i2c_en <='1';
    else
        i2c_en <='0';
    end if;
end process;

DINOUT_module : Transmission
    Port map(
            clk           => clk,
            rst           => rst,
            data_trans    => d_trans ,
            data_receive  => d_receive,
            Dinout        => Dinout
    );
TRANSMISSION_uart:  Transmission_module Port map( 
    i_clk               => clk,
    i_rst               => rst_all,
    i_rx                => rx,
----
--    i_i2c_sda           => sda,
--    i_i2c_scl           => scl,
--    i_i2c_rw            => i_i2c_rw,
--    i_act               => sig_led_act,
--    i_prestate          => sig_prestate,
--    i_led_loc           => sig_led_loc,
--    i_i2c_en            => i2c_en,
--    o_i2c_data_s2m      => o_i2c_data_s2m,
------
    i_display_en        => sig_display_enable,
    i_score_left_sig    => sig_score_left,
    i_score_right_sig   => sig_score_right,
    o_tx                => tx,
    o_buttom_left   => uart_player_left,
    o_buttom_right  => uart_player_right,
    o_rst_system    => rst_system,
    o_random_enable => sig_random_enable,
    o_game_start    => sig_game_start,
    o_random_bound  => sig_UB
);                   
       
end game;