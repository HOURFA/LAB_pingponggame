library IEEE;
use IEEE.std_logic_1164.all;
package constant_def is
    constant CLK_CONSTANT        : integer := 100000000;        --100MHz 
    constant HIGH_SPEED          : integer := 20000000;         --T = 0.20s
    constant MIDDLE_SPEED        : integer := 35000000;         --T = 0.35s
    constant SLOW_SPEED          : integer := 50000000;         --T = 0.50s
    --constant DIV_CLK_CONSTANT    : integer := 30;         --T = 0.35s
    constant DEBOUNCE_CONSTANT   : integer := 200;
    constant LED_NUM             : integer := 8;
    
    --UART_constant
    constant clk_period : integer := 10;
    constant bps            :integer  :=115200; 
    constant pbclk         :integer := ((10**9)/(bps*clk_period));
    constant score_num : integer := 56;
    constant win_num : integer := 15;
    constant SETTING_IDLE_NUM : integer := 47; -- SETTING_MODE : (1) SPEED (2) SCORE (ESC) QUIT
    constant SETTING_SPEED_NUM : integer := 47; --(1) HIGHT_SPEED (2) MIDDLE_SPEED (3) SLOW SPEED
    constant SETTING_SCORE_NUM : integer := 30; --Please enter maximum score : 
    --
end package;
