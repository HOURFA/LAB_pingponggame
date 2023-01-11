library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity divider is
generic(divisor1       :integer:=3500_0000);          --­ì®É¯ß100MHz => T =  1/100M = 0.00000001s =>T'  = 0.35s =>cnt_bound = T ' / T = 3500_0000 
port(rst,clk_in        : in std_logic;
     div_clk : out std_logic);
end divider;
architecture arch1 of divider is
    signal cnt2        :std_logic;
begin
    process(rst,clk_in,cnt2)    --divider1
    variable cnt1      : integer range 0 to divisor1 :=1;
    begin
    if rst = '0' then
        if(clk_in'event and clk_in='1') then
            if cnt1 < divisor1 then
                cnt1  := cnt1 + 1;
            else
                cnt1 :=1; 
            end if;
            if((cnt1 = divisor1 / 2) or (cnt1 = divisor1)) then 
                cnt2 <= not cnt2;
            end if;
        end if;
    else 
        cnt2 <= '0';
    end if;
    end process;
    div_clk <= cnt2;
    end arch1;