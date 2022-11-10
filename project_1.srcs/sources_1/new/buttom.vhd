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
entity buttom is
    port(
            rst                       :  in std_logic;
            clk                      :  in std_logic;
            click                   :  in std_logic;
            buttom               : out std_logic
    );
end buttom;

architecture Behavioral of buttom is
begin
process(rst,clk,click)
    variable cnt1      : integer range 0 to DEBOUNCE_CONSTANT :=1;
    begin
        if(clk'event and clk='1') then
            if rst = '1' then     
                              cnt1 := 0;                
               buttom <= '0';                       
            else             
                if click = '1' then
                    if (cnt1 < DEBOUNCE_CONSTANT)then
                                                cnt1 := cnt1 +1;
                        buttom <= '0';
                    else
                        buttom <= '1';
                    end if;
                else
                                        cnt1:= 0;
                    buttom <= '0';
                end if;             
            end if;
		end if;
end process;
end Behavioral;
