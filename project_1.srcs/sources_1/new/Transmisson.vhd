----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/12/07 16:19:10
-- Design Name: 
-- Module Name: Transmission - Behavioral
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

entity Transmission is
    Port (
            clk       :  in std_logic;
            rst       :  in std_logic;
            data_trans :   in std_logic;
            data_receive      : out std_logic;
            Dinout : inout std_logic
    );
end Transmission;

architecture Behavioral of Transmission is

type FSM is (DATA_IN , DATA_OUT);

signal INOUT_FSM : FSM;
signal Din ,Dout: std_logic;

begin


FSM_process : process(clk , rst , INOUT_FSM)
begin
    if rst = '1' then
        INOUT_FSM <= DATA_IN;
    elsif rising_edge(clk)then
        case INOUT_FSM is
            when DATA_IN =>
                if data_trans = '1' then
                    INOUT_FSM <= DATA_OUT;
                else
                    INOUT_FSM <= DATA_IN;
                end if;
            when DATA_OUT =>
                if data_trans = '1' then
                    INOUT_FSM <= DATA_OUT;
                else
                    INOUT_FSM <= DATA_IN;
                end if;
            when others => NULL;
        end case;
    end if;
end process;

in_out_process : process(clk , rst , data_trans)
begin
    if rst = '1' then
        Dinout <= '0';
    elsif rising_edge(clk)then
        case INOUT_FSM is
            when DATA_IN  => Dinout <= 'Z';
            when DATA_OUT => Dinout <= Dout;
            when others => NULL;
        end case;
    end if;
end process;

Dout_process : process(clk , rst , Dout)
begin
    if rst = '1' then
        Dout <= '0';
    elsif rising_edge(clk)then
        case INOUT_FSM is
            when DATA_IN  => Dout <= '0';
            when DATA_OUT => Dout <= data_trans;
            when others => NULL;
        end case;        
    end if;
end process;

Din_process : process(clk , rst , Din)
begin
    if rst = '1' then
        Din <= '0';       
    elsif rising_edge(clk)then
        case INOUT_FSM is
            when DATA_IN  => Din <= Dinout;
            when DATA_OUT => Din <= 'Z';
            when others => NULL;
        end case;
    end if;
end process;

led_process : process(clk , rst , Din)
begin
    if rst = '1' then
        data_receive <= '0';       
    elsif rising_edge(clk)then
        case INOUT_FSM is
            when DATA_IN  => data_receive <= Din;
            when DATA_OUT => data_receive <= '0';
            when others => NULL;
        end case;
    end if;
end process;

end Behavioral;
