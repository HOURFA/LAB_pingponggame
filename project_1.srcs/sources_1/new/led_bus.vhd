	library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	entity led8 is  --²yªº¸ô®|
			port (q    :in std_logic_vector(3 downto 0);
				 led:out std_logic_vector(7 downto 0));
	end led8;
	architecture led of led8 is
	begin
	process(q)
	begin
        case q is when "0000" => led <= "00000001";
                  when "0001" => led <= "00000010";
                  when "0010" => led <= "00000100";
                  when "0011" => led <= "00001000";
                  when "0100" => led <= "00010000";
                  when "0101" => led <= "00100000";
                  when "0110" => led <= "01000000";
                  when "0111" => led <= "10000000";
                  when others => led <= "00000000";
        end case;
	end process;
	end led;