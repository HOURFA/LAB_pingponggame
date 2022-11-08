library IEEE;
use IEEE.std_logic_1164.all;
package constant_def is
    constant CLK_CONSTANT        : integer := 100000000;        --100MHz 
    constant DIV_CLK_CONSTANT    : integer := 35000000;         --T = 0.35s
    --constant DIV_CLK_CONSTANT    : integer := 300;         --T = 0.35s
    constant DEBOUNCE_CONSTANT   : integer := 200;
    constant LED_NUM             : integer := 8;
    
    --UART_constant
    constant clk_period : integer := 10;
    constant bps            :integer  :=115200; 
    constant pbclk         :integer := ((10**9)/(bps*clk_period));
    --
end package;