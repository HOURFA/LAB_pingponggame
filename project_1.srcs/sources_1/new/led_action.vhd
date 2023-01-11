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
entity led_action is
    Port (
            rst                   :  in std_logic;
            clk                  :  in std_logic;
            prestate           :  in std_logic;
            act                  :  in std_logic_vector(2 downto 0);
            led                  : out std_logic_vector(3 downto 0)
    );
end led_action;

architecture Behavioral of led_action is

signal temp:std_logic_vector(3 downto 0);
begin
process(rst,clk,act) 
begin
if rst = '1' then
    temp <= "1001";	
else        
    if rising_edge(clk) then 
        case act is
            when "000"  =>          -- left shift
                if temp = "1000" then
                    temp <= "0000";
                elsif temp = "0111" then
                    temp <= "1010";
                end if;
                if temp < "0111"      then     
                    temp     <= unsigned(temp)+1;
                end if;                           
            when "001"  =>      -- right shift
               if temp > "0000" then     
                    temp    <= unsigned(temp)-1;
               end if;                            
            when "010" =>if temp >= "1000"     then     temp    <= "0001";   --¸Ñ¨M·¸¦ì              
                        elsif temp < "1000"    then     temp    <= unsigned(temp)+1;
                        end if;                    
            when "011" =>if temp >= "0111"     then     temp    <= "0110";
                        else temp <= unsigned(temp)-1;
                        end if;                    
            when "100"  =>temp <= "1000";               --serve
                        if temp = "1000" then
                            temp <= "0000";
                        end if;
           when "101" => temp <= "1000";                --setting
                         if temp = "1000"then
                            temp <= "1111";
                         end if;
            when "110" => temp <= "1000";               --all off
            when "111" => temp <= "1001";               --head¡Btail                   
            when others => NULL;
        end case;
    end if;	
end if;
end process;
led <= temp;
end Behavioral;
