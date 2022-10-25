library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity allgame is
	port(rst,clk,click_a,click_b		: in std_logic;
		 led_bus                      	       : out std_logic_vector(7 downto 0);--led_bus為球亮的位置
		 sa,sb                      	       : out std_logic_vector(6 downto 0));--sa,sb為七段顯示器上的數字              
end allgame;
architecture game of allgame is
component my_div1 is
	port(rst,clk_in                   	        : in std_logic;
		 clk_out1          			: out std_logic);
end component;
component buttom is
	port(click,clk,rst       			: in std_logic;
		 buttom 	 	                	: out std_logic);
end component;
component FSM is 
	port(rst,clr_a,clr_b,clk1	: in std_logic;	
	         led_loc                   : in std_logic_vector(3 downto 0 );	
	         prestate                   : out std_logic;
		 led_act  			: out std_logic_vector(2 downto 0);
		 score_a,score_b      : out std_logic_vector(3 downto 0));			
end component;
component seven_seg is
	port(num_in                      	        : in std_logic_vector(3 downto 0);
		 num_out                           	: out std_logic_vector(6 downto 0));
end component;
component led_action is
    Port (rst,clk,prestate	:in std_logic;	
                  act                  : in std_logic_vector(2 downto 0);
                  led                       : out std_logic_vector(3 downto 0));
end component;
component led8 is
	port(q                          	               :in std_logic_vector(3 downto 0);
		 led                         	               :out std_logic_vector(7 downto 0));
end component;
signal score1,score2,l1:std_logic_vector(3 downto 0);
signal act:std_logic_vector(2 downto 0);
signal divclk,c1,c2,ps:std_logic;
begin
div : my_div1 	port map(rst      			=> rst,
						 clk_in      		=> clk,
						 clk_out1    		=> divclk);
b1  : buttom    	port map(rst 				=>rst,
						 clk 				=> clk,
						 click 				=>click_b,
						 buttom 			=>c1);
b2  : buttom    	port map(rst 				=>rst,
						 clk 				=> clk,
						 click 				=>click_a,
						 buttom 			=>c2);            
F   : FSM 	    port map(rst     			=>rst,
						 clk1       		=>divclk,
						 led_loc            =>l1,
						 clr_b      		=> c1,
						 clr_a      		=> c2,
						 score_a    		=> score1,
						 score_b   			=> score2,
						 led_act            =>act,
						 prestate           => ps);
led_act  : led_action port map (rst           => rst,
                              clk           => divclk,
                              prestate	    => ps,
                              act       =>act,
                              led           =>l1);				 
s1  : seven_seg  port map(num_in    			=> score1,
						 num_out   			=> sa);
s2  : seven_seg  port map(num_in    			=> score2,
						 num_out   			=> sb);
l   : led8        port map(q       	   		=> l1,
						 led        		=> led_bus);                          
end game;