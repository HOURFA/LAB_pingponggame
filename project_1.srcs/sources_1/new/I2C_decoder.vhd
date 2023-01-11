----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/30 17:59:17
-- Design Name: 
-- Module Name: I2C_decoder - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity I2C_decoder is Port ( 
    rst : in std_logic;
    clk : in std_logic;
    act : in std_logic_vector(2 downto 0);
    led : in std_logic;
    decoder_out : out  std_logic_vector(7 downto 0)
);
end I2C_decoder;

architecture Behavioral of I2C_decoder is

begin

decoder_process : process(rst, clk)
begin
    if rst = '1' then
        decoder_out <= (others => '0');
    elsif rising_edge(clk)then
        case act is
            when "000" => decoder_out <= "0000" & act & led;
            when "001" => decoder_out <= "0000" & act & led;
            when "010" => decoder_out <= "0000" & act & led;
            when "011" => decoder_out <= "0000" & act & led;
            when "100" => decoder_out <= "0000" & act & led;
            when "000" => decoder_out <= "0000" & act & led;
            when others => NULL;
        end case;
    end if;
end process;

end Behavioral;
