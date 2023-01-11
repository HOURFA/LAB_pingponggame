----------------------------------------------------------------------------------
-- Company:  NKUST
-- Engineer:  RFA
-- 
-- Create Date: 2022/11/09 20:07:47
-- Design Name: 
-- Module Name: random_genetor - Behavioral
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
use ieee.std_logic_arith.all;
entity FSM is 
    port(
            rst                    :  in std_logic;
            clk                    :  in std_logic;
            en                     :  in std_logic;
            click_left           :  in std_logic;
            click_right          :  in std_logic;                   
            led_loc              :  in std_logic_vector(3 downto 0 );
            display_en : out std_logic;
            prestate                : out std_logic;
            led_act                : out std_logic_vector(2 downto 0);
            score_left            : out std_logic_vector(3 downto 0);
            score_right         : out std_logic_vector(3 downto 0);
            d_trans              : out std_logic;
            d_receive           : in std_logic; 
            i2c_rw               : out std_logic
    ); 
end FSM;
architecture main of FSM is
type FSM2 is(serve,hit,wait_ball,trans,receive);--定義FSM2=>sa,sb為發球，ha,hb為擊球判斷，j為得分判斷
signal s,point_a,point_b,temp:std_logic_vector(3 downto 0);
signal ps :std_logic;
signal SYS_FSM:FSM2;
signal cnt : integer range 0 to 16;
begin
process(rst,clk,click_right,SYS_FSM,led_loc)
begin
if rst = '1' then
	SYS_FSM 	<= serve;
	led_act <= "101";
	point_a <= (others => '0');--右邊
	point_b <= (others => '0');--左邊	
	i2c_rw <= '0';
	cnt <= 0;
	ps <= '1';
else
    if rising_edge(clk) then
        if en = '1' then
            case SYS_FSM is
                when serve =>led_act	<= "100";
                            if click_right = '1' then --b發球 
                                ps	<= '1';                                                      	                                                             	                               
                                SYS_FSM <= trans;                                                               
                            else 
                                SYS_FSM <= serve;
                            end if;
                when hit  =>led_act <= "001";
                            case click_right is
                                when '1' => if led_loc = "0000" then--正確回擊
--                                                led_act  <= "010";
                                                SYS_FSM <= trans;
                                            else --錯誤回擊
--                                                led_act 		<= "100";
                                                point_a <= point_a +1;
                                                SYS_FSM 	<= serve; 
                                            end if;
                                when '0' => case led_loc is 
                                                when "0000" =>
                                                    point_a <= point_a +1;
--                                                    led_act 		<= "100";                                                
                                                    SYS_FSM  	<= serve;
                                                when others =>SYS_FSM <= hit;
                                            end case;                                                    
                                when others => NULL;                                 
                            end case;     
                when wait_ball =>
                    led_act <= "111";
                    if d_receive = '1' then                        
                        SYS_FSM <= hit;
                    end if;                    
                when trans =>
                    i2c_rw <= '1';
                    ps <= '1';
                    led_act	<= "000";                                  
                    if led_loc = "0111" then                                          
                       SYS_FSM <= receive;
                   else
                       SYS_FSM <= trans;
                   end if;  
                when receive   =>
                    i2c_rw <= '0';                
                    led_act <= "110"; 
                    if d_receive = '1' then                        
                        SYS_FSM <= wait_ball;
                    else
                        SYS_FSM <= receive;
                    end if;
                when others => NULL;
            end case;
        end if;
    end if;
end if;
prestate    <= ps;
score_left 	<= point_a;
score_right <= point_b;    
end process;

process(clk ,rst , SYS_FSM)
begin
    if rst = '1' then
        d_trans <= '0';
    else
        case SYS_FSM is
            when trans =>
                if led_loc = "0111" then
                    d_trans <= '1';
                else
                    d_trans <= '0';
                end if;            
            when others => d_trans <= '0';
        end case;
    end if;
end process;

display_process : process(rst,clk)
begin
    if rst = '1' then
     display_en <= '0';
    else
        if rising_edge(clk)then
            if hit = receive then
                display_en <= '1';
            else
                display_en <= '0';
            end if;
        end if;
    end if;
end process;

end main;