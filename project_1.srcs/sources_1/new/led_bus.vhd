library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_def.all;
entity led8 is
    port(
            q                    :  in std_logic_vector(3 downto 0);
            led                  : out std_logic_vector(LED_NUM - 1 downto 0)
    );
end led8;
architecture led of led8 is
begin
process(q)
begin
    case q(2 downto 0) is when "000" => led <= "00000001";
                          when "001" => led <= "00000010";
                          when "010" => led <= "00000100";
                          when "011" => led <= "00001000";
                          when "100" => led <= "00010000";
                          when "101" => led <= "00100000";
                          when "110" => led <= "01000000";
                          when "111" => led <= "10000000";                          
                          when others => led <= "00000000";
    end case;
end process;
end led;