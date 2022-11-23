----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/24 00:21:18
-- Design Name: 
-- Module Name: LED - Behavioral
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
use work.constant_def.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LED is Port ( 
    i_clk  : in std_logic;
    i_rst   : in std_logic;
    i_prestate  : in std_logic;
    i_act   : in std_logic_vector(2 downto 0);
    o_led_bus : out std_logic_vector(LED_NUM - 1 downto 0);
    o_led_loc   : out std_logic_vector(3 downto 0)
);
end LED;

architecture Behavioral of LED is

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

signal sig_led : std_logic_vector(3 downto 0);

begin

o_led_loc <= sig_led;

led_act : led_action port map (
    rst                => i_rst,
    clk                => i_clk,
    prestate           => i_prestate,
    act                => i_act,
    led                => sig_led);
l       : led8      port map(
    q                  => sig_led,            
    led                => o_led_bus);    
end Behavioral;
