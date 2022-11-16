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
use work.constant_def.all;
entity div is
    port(
            rst                      :  in std_logic;
            UB                    :  in integer;
            random_value : in std_logic_vector(3 downto 0);
            random_en                   :  in std_logic;
            clk_in                :  in std_logic;
            clk_out              : out std_logic
    );
end div;
architecture arch1 of div is

signal cnt2 ,rst_random       :std_logic;
signal cnt1      : integer ;
signal UB_random : integer;



begin
random_process : process(rst,clk_in)
begin
    if rst = '1' then
        UB_random <= 0;
    else
        if random_en  = '1' then
            if rising_edge(cnt2)then
                if random_value(3) = '1' then
                    UB_random <= UB + to_integer(unsigned(random_value))*5000000 ;
               elsif random_value(3) = '0' then
                    UB_random <= UB - to_integer(unsigned(random_value))*5000000 ;
                end if;
            end if;
        else
            UB_random <= UB;
        end if;
        if rst_random = '1' then
            UB_random <= UB;
        end if;
    end if;
end process;
process(rst,clk_in,cnt2)    --divider1
    
    begin
    if rst = '1' then
        cnt2 <= '0';
        cnt1 <= 0;
        rst_random <= '0';
    else 
        if rising_edge(clk_in) then
            if cnt1 < UB_random then
                cnt1  <= cnt1 + 1;
            else
                cnt1 <= 0; 
            end if;
            if((cnt1 = UB_random / 2) or (cnt1 >= UB_random))then 
                cnt2 <= not cnt2;
            elsif cnt1 = UB_random then
                rst_random <= '1';
            else
                rst_random <= '0';
            end if;
        end if;
    end if;
end process;
clk_out <= cnt2;
end arch1;