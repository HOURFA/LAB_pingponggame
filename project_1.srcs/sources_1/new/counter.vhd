library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity FSM is 
    port(
            rst                  :  in std_logic;
            clk                  :  in std_logic;
            click_left           :  in std_logic;
            click_right          :  in std_logic;                   
            led_loc              :  in std_logic_vector(3 downto 0 );
            display_en : out std_logic;
            prestate             : out std_logic;
            led_act              : out std_logic_vector(2 downto 0);
            score_left           : out std_logic_vector(3 downto 0);
            score_right          : out std_logic_vector(3 downto 0)
    ); 
end FSM;
architecture main of FSM is
type FSM2 is(sa,sb,ha,hb,j);--�w�qFSM2=>sa,sb���o�y�Aha,hb�����y�P�_�Aj���o���P�_
signal s,point_a,point_b,temp:std_logic_vector(3 downto 0);
signal ps :std_logic;
signal hit:FSM2;
begin
process(rst,clk,click_left,click_right,hit,led_loc)
begin
if rst = '1' then
	hit 	<= sa;
	ps 		<= '0';
	display_en <= '0';
	led_act <= "100";
	point_a <= (others => '0');--�k��
	point_b <= (others => '0');--����	
else
    if rising_edge(clk) then
            case hit is
                when sa  => display_en <= '0';
                            ps	<= '0';
                            if click_left = '1' then--a�o�y  
                                ps	<= '1';
                                led_act	<= "001";
                                hit <= hb;                                                                	                           
                            elsif click_left = '0' then hit <= sa;
                            end if;
                when sb  =>display_en <= '0';
                            ps	<= '1';    
                            if click_right = '1' then --b�o�y 
                                ps	<= '0'; 
                                led_act	<= "000";                                                       	                                                             	                               
                                hit <= ha;                                                               
                            elsif click_right = '0' then hit <= sb;
                            end if;
                when ha  => case click_left is 
                                when '1' => if led_loc = "0111" then--���T�^��
                                                led_act  <= "011";
                                                hit <= hb;
                                            else --���~�^��
                                                led_act 		<= "100";
                                                point_b <= point_b +1 ;
                                                hit 	<= j; 
                                            end if;
                                when '0' => case led_loc is    	                                               
                                                when "0111" =>     --�S������y
                                                    point_b <= point_b +1 ;
                                                    led_act 		<= "100";                                                 
                                                    hit  	<= j;
                                                when others =>hit <= ha;
                                            end case;
                                when others =>hit <= ha;
                            end case;
                when hb  => case click_right is 
                                when '1' => if led_loc = "0000" then--���T�^��
                                                led_act  <= "010";
                                                hit <= ha;
                                            else --���~�^��
                                                led_act 		<= "100";
                                                point_a <= point_a +1;
                                                hit 	<= j; 
                                            end if;
                                when '0' => case led_loc is 
                                                when "0000" =>
                                                    point_a <= point_a +1;
                                                    led_act 		<= "100";                                                
                                                    hit  	<= j;
                                                when others =>hit <= hb;
                                            end case;                                                    
                                when others =>hit	<= hb;                                 
                            end case;                                                         
                when j   => display_en <= '1';
                            case ps is
                                when '0' 	=> hit	<= sa;    	                                       
                                when '1' 	=> hit	<= sb;
                                when others => NULL;
                            end case;
            end case;
        end if;
    end if;
end process;
prestate    <= ps;
score_left 	<= point_a;
score_right <= point_b;
end main;