library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity led_action is
    Port (rst,clk,prestate	:in std_logic;	
                  act       : in std_logic_vector(2 downto 0);
                  led             : out std_logic_vector(3 downto 0)
    );
end led_action;

architecture Behavioral of led_action is

signal temp:std_logic_vector(3 downto 0);
begin
process(rst,clk,act)
begin
if rst = '1' then
	if rising_edge(clk) then 
		case act is
			when "000"  =>if temp = "1000"     then     temp     <="0000";
					   elsif temp = "0111"   then     temp 	  <= "1000";    
					   end if;
					   if temp < "0111"      then     temp     <= unsigned(temp)+1;--路徑a 
					   end if;                              
			when "001"  =>if temp = "1000"      then     temp    <= "0110";                                                  
					   elsif temp = "0000"    then     temp    <= "1000";
					   end if;
					   if temp > "0000"       then     temp    <= unsigned(temp)-1;--路徑b
					   end if;                            
			when "010" =>if temp >= "1000"     then     temp    <= "0001";   --解決溢位              
					    elsif temp < "1000"    then     temp    <= unsigned(temp)+1;
					    end if;                    
			when "011" =>if temp >= "0111"     then     temp    <= "0110";
			            else temp <= unsigned(temp)-1;
			            end if;                    
			when "100"  =>temp <= "1000";
					   if temp = "1000" then
							if prestate = '1'      then temp 		<= "0000";
							elsif prestate = '0'    then temp 	    <= "0111";
							end if;	                   	
					   end if;
            when others => NULL;
		end case;
	end if;
else        
	temp <= "1000";
end if;
end process;
led <= temp;
end Behavioral;
