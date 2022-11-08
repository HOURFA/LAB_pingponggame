library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_def.all;
use work.ascii_decoder_lib.all;
entity ASCII_decoder is
    Port (
            rst : in STD_LOGIC;
            clk : in STD_LOGIC;
            en   : in STD_LOGIC;
            ascii_in : in STD_LOGIC_VECTOR(7 downto 0);
            buttom_left : out STD_LOGIC;
            buttom_right : out STD_LOGIC
    );
end ASCII_decoder;

architecture Behavioral of ASCII_decoder is

signal  pre: STD_LOGIC_VECTOR(7 downto 0);
signal done : std_logic;
signal cnt : integer;

begin

buttom_process : process(rst,ascii_in)
begin
    if rst = '1' then
        buttom_left <= '0';
        buttom_right <= '0';
        pre <= (others => '0');
    else        
        if rising_edge(clk)then
            if pre /= ascii_in then
                pre <= ascii_in;
                if ascii_in = a then
                    buttom_left <= '1';
                else
                    buttom_left <= '0';
                end if;
                if ascii_in = l then
                    buttom_right <= '1';
                else
                    buttom_right <= '0';
                end if;
            else
                buttom_left <= '0';
                buttom_right <= '0';
            end if;
       end if;
    end if;
end process;

end Behavioral;