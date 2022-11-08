library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity I2C_master is Port ( 
    clk     : in std_logic;
    rst     : in std_logic;
    en   : in std_logic;
    rw   : in std_logic;    
    addr_in : in std_logic_vector(6 downto 0);
    data_master_in : in std_logic_vector(7 downto 0);  --要傳給slave的數據 
    data_master_out : out std_logic_vector(7 downto 0);--slave傳回來的數據     
    sda     : inout std_logic;
    scl     : out std_logic;
    state : out std_logic_vector(5 downto 0));
end I2C_master;

architecture Behavioral of I2C_master is
type FSM1 is (idle,addr,initial,wr_data,rd_data,start,stop,response);
type FSM2 is (data_wait,data_receive);

signal I2C_state : FSM1;
signal addr_state,wr_data_state,rd_data_state ,initial_state   :FSM2;
signal addr_done,data_done,response_done,rw_done,stop_sig,stop_done,rd_done,done,rd_start:std_logic;
signal cnt , initial_cnt : integer range 0 to 10;
signal rd_times :integer range 0 to 4 ;
signal initial_sig , bps_clk: std_logic;

signal first_initial : std_logic_vector(7 downto 0) := "001100XX";              --set 8 bits
signal second_initial : std_logic_vector(7 downto 0) := "00001110";           --display on
signal third_initial : std_logic_vector(7 downto 0) := "00000110";
signal addr_initial : std_logic_vector(7 downto 0) := "00100111";    
signal addr_slave : std_logic_vector(7 downto 0);                      

component baud is Port (
    clk              :in std_logic;
    rst          :in std_logic;
    enable        :in std_logic;
    bps_clk     :out std_logic);
end component;

begin

bps :  baud Port map(
    clk             => clk,
    rst             => rst,
    enable         => en,
    bps_clk        => bps_clk
    );
    
-- bpsclk <= bps_clk;
process(rst)
begin
if rst = '1' then
    state <= (others => '0');
else
    case I2C_state is
        when addr => state <= "000001";
        when initial => state <= "000010";
        when rd_data => state <= "000100";
        when wr_data => state <= "001000";
        when response => state <= "010000";
        when stop => state <= "100000";
        when others =>state <= (others => '0');
    end case;
end if;
end process;

addr_slave <= addr_in & rw;

process(rst,bps_clk,en,rw,cnt,response_done,stop_sig,rd_done,I2C_state,initial_state,initial_sig)
begin
if rst = '1' then
    I2C_state <= idle;
    addr_state <= data_receive;
    wr_data_state <= data_receive;
    rd_data_state <= data_receive;
    rd_start <= '0';
    response_done <= '0';
    stop_done <= '0';
    rw_done <= '0';
    cnt <= 7; 
    initial_cnt <= 1;
    initial_sig <= '1';
else
    if rising_edge(bps_clk)then
        case I2C_state is
            when idle =>
                if en = '1'then  I2C_state <= start;
                else I2C_state <= idle;
                end if;
            when start =>               
                    I2C_state <= addr;
            when addr =>             
                case addr_state is
                    when data_wait =>
                        if cnt = 0 then
                            cnt <= 7;                         
                            I2C_state <= response;
                            addr_state <= data_receive;
                        elsif cnt > 0 then
                            cnt <= cnt - 1;                                
                        end if;    
                        addr_state <= data_receive;                        
                    when data_receive =>
                        addr_state <= data_wait;
                end case;
            when initial =>
                case initial_state is
                        when data_wait => 
                            if cnt = 0 then
                                initial_cnt <= initial_cnt + 1;
                                cnt <= 7;                                                     
                                I2C_state <= response;
                                initial_state <= data_receive;     
                            elsif cnt > 0 then
                                cnt <= cnt - 1;                                             
                            end if;  
                            initial_state <= data_receive;    
                        when data_receive =>
                            initial_state <= data_wait;
                    end case;         
            when wr_data =>          
                case wr_data_state is
                    when data_wait =>
                        if cnt = 0 then
                            cnt <= 7;                                                     
                            I2C_state <= response;
                            wr_data_state <= data_receive;     
                        elsif cnt > 0 then
                            cnt <= cnt - 1;                                             
                        end if;  
                        wr_data_state <= data_receive;
                    when data_receive =>
                        wr_data_state <= data_wait;                        
                end case;
            when rd_data =>           
                case rd_data_state is
                    when data_wait =>
                        if cnt = 0 then
                            cnt <= 7;                                               
                            I2C_state <= response;
                            rd_data_state <= data_receive;     
                        elsif cnt > 0 then
                            cnt <= cnt - 1;                                             
                        end if;  
                        rd_data_state <= data_receive;
                    when data_receive =>
                        rd_data_state <= data_wait;                        
                end case;            
            when response =>
                if rd_done = '1' then                    
                    rd_start <= '0';
                end if;      
                if initial_cnt = 5 then
                    initial_sig <= '0';
                    cnt <= 7;
                end if;                       
                case response_done is
                    when '1' => response_done <= '0';                                 
                                case stop_sig is
                                    when '1' => I2C_state <= stop;
                                    when '0' =>
                                        if initial_sig = '1' then
                                            I2C_state <= initial;
                                        else
                                            case rw is
                                                when '1' => I2C_state <= rd_data;
                                                             rd_start <= '1';
                                                when '0' => I2C_state <= wr_data;
                                                when others =>  
                                            end case;
                                        end if;
                                    when others =>
                                end case;
                    when '0' => response_done <= '1';
                    when others =>
                end case;            
            when stop =>
                case stop_done is
                    when '1' => stop_done <= '0';                
                                I2C_state <= idle;
                    when '0' => stop_done <= '1';
                    when others =>  
                end case;
        end case;
    end if;
end if;
end process;
process(rst,I2C_state,addr_state,wr_data_state,rd_data_state,addr_done,data_done,rw_done,response_done,cnt,sda,stop_done,rd_done,done,rd_start,stop_sig,initial_state)
begin
if rst = '1' then
    addr_done <= '0';
    data_done <= '0';
    rd_done <= '0';
    sda <= '1';
    scl <= '1';
    stop_sig <= '0';
    data_master_out <= (others => '0');
else
    case I2C_state is
        when idle =>
            data_done <= '0';
            addr_done <= '0';   
        when start => sda <= '0';                
        when addr =>              
            case addr_state is
                when data_wait =>
                    if cnt = 0 then
                        addr_done <= '1';                     
                    end if;  
                    scl <= '1';  
                    sda <= sda;                 
                when data_receive =>                        
                    sda <= addr_slave(cnt);
                    scl <= '0'; 
            end case;
        when initial =>
            case initial_state is
                when data_wait => 
                    scl <= '1';
                when data_receive =>
                    scl <= '0';                        
                    case initial_cnt is
                        when 1 => sda <= first_initial(cnt);
                        when 2 => sda <= second_initial(cnt);
                        when 3 => sda <= third_initial(cnt);
                        when 4 => sda <= addr_initial(cnt);
                        when others => NULL;
                    end case;
            end case;             
        when wr_data =>   
            case wr_data_state is
                when data_wait =>
                    if cnt = 0 then
                        data_done <= '1';                
                    end if;    
                    scl <= '1';
                when data_receive =>           
                    sda <= data_master_in(cnt);
                    scl <= '0';
            end case;
        when rd_data =>
            if rd_start = '1'then
                rd_done <= '0';
            end if;    
            case rd_data_state is
                when data_wait =>
                    if cnt = 0 then
                        rd_done <= '1';             
                    end if;    
                    sda <= sda;
                    data_master_out(cnt) <= sda;                    
                    scl <= '1';
                when data_receive =>           
                    sda <= 'Z';
                    scl <= '0';
            end case;
        when response =>            
            case response_done is
                when '1' => scl <= '1';
                            sda <= sda;
                when '0' => scl <= '0';
                             sda <= 'Z';
                            case sda is
                                when '1' => stop_sig <= '1';
                                when '0' => stop_sig <= '0';
                                when others => stop_sig <= '0';
                            end case;
                when others =>
            end case;         
        when stop =>
            addr_done <= '0';
            rd_done <= '0';
            case stop_done is
                when '1' => sda <= '1';
                            stop_sig <= '0';
                            sda <= '1';
                when '0' => sda <= '0';
                when others =>                  
            end case;
    end case;  
end if;
end process;
end Behavioral;
