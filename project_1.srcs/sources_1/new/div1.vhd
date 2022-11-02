library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity my_div1 is
generic(divisor1       :integer:=3500_0000);          --­ì®É¯ß100MHz => T =  1/100M = 0.00000001s =>T'  = 0.35s =>cnt_bound = T ' / T = 3500_0000 
--generic(divisor1       :integer:=300);
port(rst,clk_in        : in std_logic;
     clk_out1 : out std_logic);
end my_div1;
architecture arch1 of my_div1 is
    signal cnt2        :std_logic;
begin
    process(rst,clk_in,cnt2)    --divider1
    variable cnt1      : integer range 0 to divisor1 :=1;
    begin
    if rst = '1' then
        cnt2 <= '0';
    else 
        if rising_edge(clk_in) then
            if cnt1 < divisor1 then
                cnt1  := cnt1 + 1;
            else
                cnt1 :=1; 
            end if;
            if((cnt1 = divisor1 / 2) or (cnt1 = divisor1)) then 
                cnt2 <= not cnt2;
            end if;
        end if;
    end if;
    end process;
    clk_out1 <= cnt2;
    end arch1;