----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/16 21:11:15
-- Design Name: 
-- Module Name: addres_counter - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constant_def.all;
entity addres_counter is
    Port (
        clk             : in std_logic;
        reset           : in std_logic;      
        shift       : in integer;        
        vga_vs_cnt      : in integer;
        vga_hs_cnt      : in integer;
        en              : out std_logic;
        addra           : out std_logic_vector (13 downto 0));
end addres_counter;

architecture Behavioral of addres_counter is
signal cnt_addr : std_logic_vector (13 downto 0);
signal ena,clr : std_logic;
begin
process(clk,reset,cnt_addr,ena)
begin
    if (reset = '1') then
        cnt_addr <= (others => '0');
    else
        if rising_edge(clk)  then   
            if (clr = '0') then
                if ena = '1' then
                    if cnt_addr = (img_height*img_width)-1 then 
                        cnt_addr <= (others => '0');
                    elsif cnt_addr < (img_height*img_width)-1 then
                         cnt_addr <= cnt_addr + '1' ;           
                    end if;
                end if;
            else
                cnt_addr <= (others => '0');
            end if;
        end if;
    end if; 
addra     <= cnt_addr;
end process;
process(vga_vs_cnt,vga_hs_cnt)
begin
    if (vga_vs_cnt > (center_v+(img_height/2))) then
        clr <= '1';
    else
        clr <= '0';
    end if;
    if (vga_vs_cnt >= (center_v-(img_height/2))) and (vga_vs_cnt < (center_v+(img_height/2))) and(vga_hs_cnt >= (shift-(img_width/2))) and (vga_hs_cnt <(shift+(img_width/2))) then 
        ena <= '1';
    else
        ena <= '0';
    end if;
end process;
en <= ena;
end Behavioral;
