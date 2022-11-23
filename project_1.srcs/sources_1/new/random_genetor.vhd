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
use ieee.numeric_std.all;
entity Random_genetor is Port ( 
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    en : in STD_LOGIC;
    random_value : out std_logic_vector(3 downto 0));
end Random_genetor;


architecture Behavioral of Random_genetor is

signal cnt : std_logic_vector(3 downto 0);

begin

random_process : process(clk,rst)
begin
    if rst = '1' then
        random_value <= (others => '0');
        cnt <= ("0111");
    else
        if rising_edge(clk)then
            if en = '1' then
                cnt <= std_logic_vector(unsigned(cnt) + 1 );             
                cnt(0) <= cnt(3) XOR cnt(2);
                cnt(1) <= cnt(2) XOR cnt(1);
                cnt(2) <= cnt(1) XOR cnt(0);
                cnt(3) <= cnt(3);
                random_value <= cnt;
            else           
                random_value <= (others => '0');
            end if;
        end if;
    end if;
    
end process;


end Behavioral;
