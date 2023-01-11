----------------------------------------------------------------------------------
-- Company: NKUST
-- Engineer: RFA
-- 
-- Create Date: 2022/11/23 20:35:10
-- Design Name: 
-- Module Name: Divider_module - Behavioral
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

entity Divider_module is Port (
    i_clk                        :  in std_logic;
    i_rst                         :  in std_logic;
    i_UB                       :  in integer; 
    i_random_en          :  in std_logic;
    o_random_div        : out std_logic;
    o_VGA_div            : out std_logic);
end Divider_module;

architecture Behavioral of Divider_module is
component Random_div is port(
    rst                        :  in std_logic;
    UB                      :  in integer;
    random_value     :  in std_logic_vector(3 downto 0);
    random_en         :  in std_logic;
    clk_in                 :  in std_logic;
    clk_out              : out std_logic);
end component;
component VGA_div is Port (
        clk             : in std_logic;
        reset           : in std_logic;
        div_clk        : out std_logic);
end component;
component Random_genetor is Port(
    clk  : in std_logic;
    rst  : in std_logic;
    en  : in std_logic;
    random_value : out std_logic_vector(3 downto 0));        
end component;

signal sig_rvalue : std_logic_vector(3 downto 0);

begin

VGA_DIVIDER : VGA_div port map(
    clk            => i_clk,
    reset          => i_rst,
    div_clk        => o_VGA_div);
        
RANDOM_DIVIDER : Random_div port map(
    rst                => i_rst,
    UB                 => i_UB,
    random_en          => i_random_en,
    random_value       => sig_rvalue,
    clk_in             => i_clk,
    clk_out            => o_random_div);
Random : random_genetor Port map(
    clk                => i_clk,
    rst                => i_rst,
    en                 => i_random_en,
   random_value        => sig_rvalue);    
    
end Behavioral;
