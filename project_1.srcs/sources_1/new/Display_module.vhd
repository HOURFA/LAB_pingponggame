----------------------------------------------------------------------------------
-- Company: NKUST
-- Engineer: RFA
-- 
-- Create Date: 2022/11/23 20:35:10
-- Design Name: 
-- Module Name: Display_module - Behavioral
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

entity Display_module is Port (
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
end Display_module;

architecture Behavioral of Display_module is

component VGA is Port (
    i_VGA_clk   : in std_logic;
    i_radom_clk : in std_logic;
    i_rst   : in std_logic;
    i_prestate : in std_logic;
    i_act   : in std_logic_vector(2 downto 0);
    o_Rout : out std_logic_vector(3 downto 0);
    o_Gout : out std_logic_vector(3 downto 0);
    o_Bout : out std_logic_vector(3 downto 0);
    o_hsync : out std_logic;
    o_vsync : out std_logic
);
end component;
component LED is Port ( 
    i_clk  : in std_logic;
    i_rst   : in std_logic;
    i_prestate  : in std_logic;
    i_act   : in std_logic_vector(2 downto 0);
    o_led_bus : out std_logic_vector(LED_NUM - 1 downto 0);
    o_led_loc   : out std_logic_vector(3 downto 0)
);
end component;

begin
VGA_1 : VGA Port map(
    i_VGA_clk  => i_VGA_clk,
    i_radom_clk => i_random_clk,
    i_rst  => i_rst,
    i_prestate  => i_prestate,
    i_act   => i_act,
    o_Rout => o_Rout,
    o_Gout => o_Gout,
    o_Bout => o_Bout,
    o_hsync => o_hsync,
    o_vsync => o_vsync
);

LED_1 : LED Port map( 
    i_clk => i_random_clk,
    i_rst   => i_rst,
    i_prestate  => i_prestate,
    i_act   => i_act,
    o_led_bus => o_led_bus,
    o_led_loc => o_led_loc
);
end Behavioral;
