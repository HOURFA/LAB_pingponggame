	library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	entity seven_seg is  --七段顯示器
			port(num_in          :in std_logic_vector(3 downto 0);
				num_out         :out std_logic_vector(6 downto 0));
	end seven_seg;
		architecture score of  seven_seg is
	begin
	process(num_in)
	begin
        case num_in is 
               when "0000" => num_out <= "1000000";
               when "0001" => num_out <= "1111001";
               when "0010" => num_out <= "0100100";
               when "0011" => num_out <= "0110000";
               when "0100" => num_out <= "0011001";
               when "0101" => num_out <= "0010010";
               when "0110" => num_out <= "0000010";
               when "0111" => num_out <= "1111000";
               when "1000" => num_out <= "0000000";
               when "1001" => num_out <= "0010000";
               when others => num_out <= "ZZZZZZZ";
	   end case;
	end process;
	end score;