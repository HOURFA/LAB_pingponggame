     library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	entity my_div2 is
    generic(divisor2:integer:=5000000);--100000
                    port(clk_in: in std_logic;
                            clk_out: out std_logic);
    end my_div2;
        architecture arch2 of my_div2 is
    signal cnt2 : std_logic;
begin
    process(clk_in,cnt2)
    variable cnt1 : integer range 0 to divisor2 :=1;
    begin
       clk_out <= cnt2;
        cnt2 <= '1';
        if(clk_in'event and clk_in='1') then
            if cnt1 <divisor2 then  cnt1  := cnt1 + 1;
            else  cnt1 :=1; 
            end if;
            if((cnt1 = divisor2/2) or (cnt1 = divisor2)) then cnt2 <= not cnt2;
            end if;
        end if;
    end process;
    end arch2;