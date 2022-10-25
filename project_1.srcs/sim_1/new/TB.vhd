      LIBRARY ieee;
        USE ieee.std_logic_1164.ALL;
        ENTITY TB2 IS
        END TB2;
         
        ARCHITECTURE behavior OF TB2 IS 
            COMPONENT allgame
            PORT(
                 rst : IN  std_logic;
                 click_a: IN  std_logic;
                 click_b : IN  std_logic;
                 clk : IN  std_logic;
                 led_bus : OUT  std_logic_vector(7 downto 0);
                 sa : OUT  std_logic_vector(6 downto 0);
                 sb : OUT  std_logic_vector(6 downto 0)
                );
            END COMPONENT; 
           --Inputs
           signal rst : std_logic := '0';
           signal click_a : std_logic := '0';
           signal click_b : std_logic := '0';
           signal clk : std_logic := '0';
        
            --Outputs
           signal led_bus : std_logic_vector(7 downto 0);
           signal sa : std_logic_vector(6 downto 0);
           signal sb: std_logic_vector(6 downto 0);
           
           -- Clock period definitions
           constant clk_period : time := 10 ns;
           constant clk1 :time:=5000 ns;--50000000
           constant clk2 :time:=1000 ns;--10000000
         
        BEGIN
         
            -- Instantiate the Unit Under Test (UUT)
           uut: allgame PORT MAP (
                  rst => rst,
                  click_a => click_a,
                  click_b => click_b,
                  clk => clk,
                  sa => sa,
                  sb => sb,
                  led_bus => led_bus
                );
                
           -- Clock process definitions
           clk_process :process--時脈週期為10ns，從0~10花費105ns
           begin
                clk <= '0';
                wait for clk_period/2;
                clk <= '1';
                wait for clk_period/2;
           end process;
 stim_proc: process
            begin		
            wait for 1*clk1 ;	
            rst<='1';
			wait for 3*clk1;
			click_a <='1';
			wait for 4*clk2;
			click_a<='0';
            wait for 10*clk1;
			click_b<='1';
			wait for 4*clk2;
			click_b<='0';
			wait for 10*clk1;	
			click_a<='1';
			wait for 4*clk2;
			click_a<='0';
			wait for 22us;	
			click_b<='1';
			wait for 4*clk2;
			click_b<='0';
			wait for 20us;	
			click_a<='1';
			wait for 4*clk2;
			click_a<='0';
			wait for 10us;	
			click_b<='1';
			wait for 4*clk2;
			click_b<='0';			
            wait;
                end process;
        
        END;
