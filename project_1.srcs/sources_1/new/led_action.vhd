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

signal temp:std_logic_vector(4 downto 0);
begin
process(rst,clk,act) 
begin
if rst = '1' then
	temp <= "10000";	
else        
    if rising_edge(clk) then 
        case act is
            when "000"  =>if temp = "10000"     then     temp     <="00000";
                       elsif temp = "01111"   then     temp 	  <= "10000";    
                       end if;
                       if temp < "01111"      then     temp     <= unsigned(temp)+1;--¥ª²¾
                       end if;                              
            when "001"  =>if temp = "10000"      then     temp    <= "01110";                                                  
                       elsif temp = "00000"    then     temp    <= "10000";
                       end if;
                       if temp > "00000"       then     temp    <= unsigned(temp)-1;--¥k²¾
                       end if;                            
            when "010" =>if temp >= "10000"     then     temp    <= "00001";   --¸Ñ¨M·¸¦ì              
                        elsif temp < "10000"    then     temp    <= unsigned(temp)+1;
                        end if;                    
            when "011" =>if temp >= "01111"     then     temp    <= "01110";
                        else temp <= unsigned(temp)-1;
                        end if;                    
            when "100"  =>
                        if prestate = '1'      then temp 		<= "00000";
                        elsif prestate = '0'    then temp 	    <= "01111";	                   	
                        end if;
           when "101" => temp <= "10000";
                         if temp = "10000"then
                            temp <= "11111";
                         end if;
            when others => NULL;
        end case;
    end if;	
end if;
end process;
led <= temp(3 downto 0);
end Behavioral;
