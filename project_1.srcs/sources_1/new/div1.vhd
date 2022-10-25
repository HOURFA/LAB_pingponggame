library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity my_div1 is
--generic(divisor1       :integer:=35000000);
generic(divisor1       :integer:=300);
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
    clk_out1 <= cnt2;
    end arch1;