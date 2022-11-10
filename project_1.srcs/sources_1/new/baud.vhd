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
use work.constant_def.all;

entity baud is Port (
    clk              :in std_logic;
    rst          :in std_logic;
    enable        :in std_logic;
    bps_clk     :out std_logic);
end baud;

architecture Behavioral of baud is

signal cnt : integer;
signal bpsclk :std_logic;
begin

process(rst,enable,clk)
begin

if rst = '1' then
    cnt <= 0;
else
    if enable = '1' then
        if rising_edge(clk) then
            if cnt < pbclk then
                cnt <= cnt + 1;
            elsif cnt = pbclk then
                cnt <= 0;
            end if;
        end if;
    end if;
end if;

end process;

process(rst,clk,bpsclk,enable)
begin
if rst = '1' then
    bpsclk <= '0' ;
else
    if enable = '1' then
        if rising_edge(clk)then
            if cnt = pbclk/2 or cnt = pbclk then
                bpsclk <= not bpsclk;
            end if;
        end if;
    else
        bpsclk <= '0';
    end if;
end if;
end process;
bps_clk <= bpsclk;
end Behavioral;
