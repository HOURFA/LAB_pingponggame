----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/23 20:35:10
-- Design Name: 
-- Module Name: Controller_module - Behavioral
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

entity Controller_module is port(
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
end Controller_module;

architecture Behavioral of Controller_module is

component FSM is port(
    rst                  :  in std_logic;
    clk                  :  in std_logic;
    en                   :  in std_logic;
    click_left           :  in std_logic;
    click_right          :  in std_logic;        
    led_loc              :  in std_logic_vector(3 downto 0 );
    display_en         :  out std_logic;        
    prestate             : out std_logic;
    led_act              : out std_logic_vector(2 downto 0);
    score_left           : out std_logic_vector(3 downto 0);
    score_right          : out std_logic_vector(3 downto 0);
    d_trans              : out std_logic;
    d_receive           : in std_logic; 
    i2c_rw               : out std_logic
    );
    
end component;
begin

SYSTEM  : FSM       port map(
    rst                => i_rst,
    clk                => i_clk,
    en                 => i_en,
    led_loc            => i_led_loc,
    click_left         => i_click_left,
    click_right        => i_click_right,
    score_left         => o_score_left,
    score_right        => o_score_right,
    display_en         => o_display_en,
    led_act            => o_led_act,
    prestate           => o_prestate,
    d_trans           => d_trans,
    d_receive         => d_receive,
    i2c_rw             => o_i2c_rw);
end Behavioral;
