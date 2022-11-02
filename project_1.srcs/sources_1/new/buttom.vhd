library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity buttom is
generic(bound           :integer:=20000);--20000
port (click,clk,rst       : in std_logic;
        buttom              : out std_logic);
end buttom;

architecture Behavioral of buttom is
begin
    process(rst,clk,click)
    variable cnt1      : integer range 0 to bound :=1;
        begin
        if(clk'event and clk='1') then
            if rst = '1' then     
               cnt1 := 0;                
               buttom <= '0';                       
            else             
                if click = '1' then
                    if (cnt1 < bound)then
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
