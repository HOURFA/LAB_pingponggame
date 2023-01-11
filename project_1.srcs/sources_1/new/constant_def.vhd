library IEEE;
use IEEE.std_logic_1164.all;
package constant_def is
    constant CLK_CONSTANT        : integer := 100000000;        --100MHz 
    constant HIGH_SPEED          : integer := 20000000;         --T = 0.20s
    constant MIDDLE_SPEED        : integer := 35000000;         --T = 0.35s
    constant SLOW_SPEED          : integer := 50000000;         --T = 0.50s
    --constant DIV_CLK_CONSTANT    : integer := 30;         --T = 0.35s 
    constant DEBOUNCE_CONSTANT   : integer := 10;
    constant LED_NUM             : integer := 8;
    
    --UART_constant
    constant clk_period : integer := 10;
    constant bps            :integer  :=115200; 
    constant pbclk         :integer := ((10**9)/(bps*clk_period));
    constant score_num : integer := 32;
    constant win_num : integer := 17;
    constant SETTING_IDLE_NUM : integer := 57; -- SETTING_MODE : (1) SPEED (2) SCORE (3)MODE (ESC) QUIT
    constant SETTING_SPEED_NUM : integer := 48 + 3; --(1) HIGHT_SPEED (2) MIDDLE_SPEED (3) SLOW SPEED
    constant SETTING_SCORE_NUM : integer := 29 + 3; --Please enter maximum score : 
    constant INPUT_NUM : integer := 3; 
    constant SETTING_MODE_NUM  : integer := 41 + 3; --(1) NORMAL_MODE (2) VARIABLE_SPEED_MODE
    --
    -------------------------------------------------------------------------------------------VGA_const 800X600
    -- horizotal
    constant        horizontal_resolution       : integer := 800 ;
    constant        horizontal_Front_porch    : integer :=  56 ;
    constant        horizontal_Sync_pulse     : integer := 120 ;
    constant        horizontal_Back_porch    : integer :=  64 ;
    constant        h_sync_Polarity             : std_logic:= '1' ;
    --
    -- vertical
    constant        vertical_resolution         : integer := 600 ;
    constant        vertical_Front_porch      : integer :=  37 ;
    constant        vertical_Sync_pulse       : integer :=   6 ;
    constant        vertical_Back_porch      : integer :=  23 ;
    constant        v_sync_Polarity            : std_logic:= '1' ;
    --
    
    -- display
    constant        center_v                : integer := vertical_resolution / 2;
    constant        center_h                : integer := horizontal_resolution / 2;
    constant        ball_radius             : integer := 50;
    constant        right_bound             : integer := horizontal_resolution - ( ball_radius / 2);
    constant        left_bound              : integer := ball_radius / 2;
    constant        img_height              : integer := 100;
    constant        img_width              : integer := 100;
    --
    ---------------------------------------------------------------------------------------------VGA_const 1920X1080    
end package;
