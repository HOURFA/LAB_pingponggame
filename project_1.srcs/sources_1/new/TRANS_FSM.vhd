----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/12/14 18:16:27
-- Design Name: 
-- Module Name: TRANS_FSM - Behavioral
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

entity TRANS_FSM is 
    Port (
            clk : in std_logic;
            rst : in std_logic 
    );
end TRANS_FSM;

architecture Behavioral of TRANS_FSM is

type FSM is (HIT , SCORE , BALLIN , BALLOUT , TRANS);

signal SYSTEM_FSM : FSM;

begin





end Behavioral;
