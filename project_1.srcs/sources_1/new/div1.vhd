library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_def.all;
entity div is
    port(
            rst                     :  in std_logic;
            clk_in               :  in std_logic;
            clk_out              : out std_logic
    );
end div;
architecture arch1 of div is

signal cnt2        :std_logic;
signal cnt1      : integer range 0 to DIV_CLK_CONSTANT :=1;
begin
process(rst,clk_in,cnt2)    --divider1
    
    begin
    if rst = '1' then
        cnt2 <= '0';
        cnt1 <= 0;
    else 
        if rising_edge(clk_in) then
            if cnt1 < DIV_CLK_CONSTANT then
                cnt1  <= cnt1 + 1;
            else
                cnt1 <= 0; 
            end if;
            if((cnt1 = DIV_CLK_CONSTANT / 2) or (cnt1 = DIV_CLK_CONSTANT)) then 
                cnt2 <= not cnt2;
            end if;
        end if;
    end if;
end process;
clk_out <= cnt2;
end arch1;