----------------------------------------------------------------------------------
-- Company:  NKUST
-- Engineer: RFA
-- 
-- Create Date: 2022/11/16 16:15:08
-- Design Name: 
-- Module Name: VGA_display - Behavioral
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
use work.constant_def.all;
use work.ascii_decoder_lib.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_display is Port ( 
    clk : in STD_LOGIC;
    div_clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    vga_vs_cnt : in integer;
    vga_hs_cnt : in integer;
    prestate    : in std_logic;
    act : in std_logic_vector(2 downto 0);
    shift       : inout integer;
    img_in          : in std_logic_vector(11 downto 0);
    Rout            : inout std_logic_vector(3 downto 0); --
    Gout            : inout std_logic_vector(3 downto 0); --
    Bout            : inout std_logic_vector(3 downto 0));
end VGA_display;

architecture Behavioral of VGA_display is

--signal shift : integer ;

begin
ball_process : process (rst,clk,act)
begin
    if rst = '1' then
        Rout <= (others => '0');
        Gout <= (others => '0');
        Bout <= (others => '0');
    else
        if rising_edge(clk)then
            if (vga_hs_cnt < horizontal_resolution  and vga_vs_cnt < vertical_resolution ) then   
                if (vga_vs_cnt >= (center_v-(img_height/2))) and (vga_vs_cnt < (center_v+(img_height/2)))
                    and(vga_hs_cnt >= (shift-(img_width/2))) and (vga_hs_cnt <(shift+(img_width/2)))  then
                    Rout <= img_in(11 downto 8);
                    Gout <= img_in(7 downto 4);
                    Bout <= img_in(3 downto 0);
                else
                    Rout <= (others => '0');
                    Gout <= (others => '0');
                    Bout <= (others => '0');                        
                end if;       
            else
                Rout <= (others => '0');
                Gout <= (others => '0');
                Bout <= (others => '0');
            end if;            
        end if;
    end if;
end process;

shift_process : process (rst,clk)
begin
    if rst = '1' then
        shift <= ball_radius;
    else
        if rising_edge(div_clk)then
            case act is
                when "000" => -- left_shift
                if shift <= horizontal_resolution - 50 then
                    shift <= shift - (50 * 2);
                end if;                                
                when "001" => -- right_shift
                if shift > 0 then                    
                    shift <= shift + (50 * 2);
                end if;                
                when "010" => --¥k¦^À»
                    if shift > horizontal_resolution - 50 then
                        shift <= horizontal_resolution -150;
                    else
                        shift <= shift - (50 * 2);
                    end if;
                when "011" =>
                    if shift < 100 then
                        shift <= 150;
                    else
                        shift <= shift + (50 * 2);
                    end if;
                when "100" => 
                    if prestate = '1' then
                        shift <= horizontal_resolution - 50;
                    elsif prestate = '0' then
                        shift <= 50;                    
                    end if;                
                when "101" => shift <= center_h;
                when others => NULL; 
            end case;
        end if;
    end if;
end process;

end Behavioral;