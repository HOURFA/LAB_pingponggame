      LIBRARY ieee;
        USE ieee.std_logic_1164.ALL;
        USE work.constant_def.all;
        ENTITY TB2 IS
        END TB2;
         
        ARCHITECTURE behavior OF TB2 IS 
            COMPONENT allgame
            PORT(
                            rst                  :  in std_logic;
                            clk                  :  in std_logic;
                            rx                   :  in std_logic;
                            lcd_en : in std_logic  ;                          
                            buttom_player_left   :  in std_logic;
                            buttom_player_right  :  in std_logic;
                            tx                       : out std_logic;
                            led_bus              : out std_logic_vector(LED_NUM - 1 downto 0);
                            score_left           : out std_logic_vector(6 downto 0);
                            score_right          : out std_logic_vector(6 downto 0);
                            sda : inout std_logic;
                            scl : out std_logic;
                            led : out std_logic                            
                );
            END COMPONENT; 
           --Inputs
           signal rst : std_logic := '0';
           signal buttom_player_left : std_logic := '0';
           signal buttom_player_right : std_logic := '0';
           signal clk : std_logic := '0';
           signal rx: std_logic;
           signal lcd_en :std_logic := '0';
        
            --Outputs
           signal led_bus : std_logic_vector(7 downto 0);
           signal score_left : std_logic_vector(6 downto 0);
           signal score_right: std_logic_vector(6 downto 0);
           signal tx : std_logic;
           signal      sda : std_logic;
           signal      scl: std_logic;
           signal      led : std_logic;           
           
           -- Clock period definitions
           constant clk_period : time := 10 ns;
           constant clk1 :time:=5000 ns;--50000000
           constant clk2 :time:=1000 ns;--10000000
           constant bpsclk :time := 5208 ns;
        BEGIN
         
            -- Instantiate the Unit Under Test (UUT)
           uut: allgame PORT MAP (
                  rst => rst,
                  buttom_player_left => buttom_player_left,
                  buttom_player_right => buttom_player_right,
                  lcd_en => lcd_en,
                  clk => clk,
                  rx => rx,
                  score_left => score_left,
                  score_right => score_right,
                  led_bus => led_bus,
                  tx => tx,
                  sda => sda,
                  scl => scl,
                  led => led
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
            wait for 1*clk1;
            rst<='0';
			wait for 3*clk1;
			buttom_player_left <='1';
			wait for 4*clk2;
			buttom_player_left<='0';
            wait for 10*clk1;
                        lcd_en <= '1';
			buttom_player_right<='1';
			wait for 4*clk2;
			buttom_player_right<='0';
			wait for 10*clk1;	
			buttom_player_left<='1';
			wait for 4*clk2;
			buttom_player_left<='0';
			wait for 22us;	
			buttom_player_right<='1';
			wait for 4*clk2;
			buttom_player_right<='0';
			wait for 20us;	
			buttom_player_left<='1';
			wait for 4*clk2;
			buttom_player_left<='0';
			wait for 10us;	
			buttom_player_right<='1';
			wait for 4*clk2;
			buttom_player_right<='0';			
            wait;
        end process;
        rx_process:process
        begin
            wait for bpsclk;
            rx <= '1';
            wait for bpsclk*5;
            rx <= '0';
            wait for bpsclk*2-30ns;
            rx <= '1';
            wait for bpsclk*2;
            rx <= '0';
            wait for bpsclk*2;
            rx <= '1';
            wait for bpsclk*2;
            rx <= '0';
            wait for bpsclk*2;
            rx <= '1';
            wait for bpsclk*6;
            rx <= '0';
            wait for bpsclk*2;
            rx <= '1';
            wait for bpsclk*6;
            rx <= '0';
            wait for bpsclk*100000000;
        end process;
        END;
