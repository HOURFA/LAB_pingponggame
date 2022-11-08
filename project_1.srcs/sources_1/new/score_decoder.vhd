library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.constant_def.all;
use work.ascii_decoder_lib.all;
entity score_decoder is Port (
    rst : in STD_LOGIC;
    clk : in STD_LOGIC;
    display_en : in STD_LOGIC;
    score_left : in STD_LOGIC_VECTOR (3 downto 0);
    score_right : in STD_LOGIC_VECTOR (3 downto 0);
    tx_series : out STD_LOGIC_VECTOR (7 downto 0);
    tx_en : out std_logic);
end score_decoder;

architecture Behavioral of score_decoder is
component baud is Port (
    clk              :in std_logic;
    rst          :in std_logic;
    enable        :in std_logic;
    bps_clk     :out std_logic);
end component;

type FSM is (IDLE,READ,WAIT_EN);
signal SYSTEM_FSM : FSM;
signal ascii_score_left : std_logic_vector(7 downto 0);
signal ascii_score_right: std_logic_vector(7 downto 0);
signal str                    : std_logic_vector(7 downto 0);
signal bps_clk,bps_en: std_logic;
signal done : std_logic;
signal cnt,str_num : integer;
begin
tx_baud :baud port map(
    clk => clk,
    rst => rst,
    enable => bps_en,
    bps_clk => bps_clk);

FSM_process : process(rst,clk,str_num)
begin
    if rst = '1' then
        SYSTEM_FSM <= IDLE;
    else
        if rising_edge(clk) then
            case SYSTEM_FSM is  
                when IDLE    =>             --等待en = '1' 啟動FSM
                    if display_en = '1' then
                        SYSTEM_FSM <= READ;
                    else
                        SYSTEM_FSM <= IDLE;
                    end if;
                when READ    =>             --輸出所有要輸出的str後轉態
                    if str_num = total_str_num then
                        SYSTEM_FSM <= WAIT_EN;
                    else
                        SYSTEM_FSM <= READ;
                    end if;
                when WAIT_EN =>             --因display_en = '1' 時間還未結束，等到結束後在判斷下次的en
                    if display_en = '1' then
                        SYSTEM_FSM <= WAIT_EN;
                    elsif display_en = '0' then
                        SYSTEM_FSM <= IDLE;
                    end if;                    
                when others  => NULL;              
            end case;
        end if;    
    end if;   
end process;

ACT_process : process(rst,clk)
begin
    if rst = '1' then
        bps_en <= '0';
        done <= '0';
    else
        if SYSTEM_FSM = idle  then
            bps_en <= '0';
        else
            bps_en <= '1';
        end if; 
    end if;
end process;

score2ascii     :process(rst,clk,score_left,score_right)
begin
    if rst = '1' then
        ascii_score_left  <= a_0;
        ascii_score_right <= a_0;
    else
        if rising_edge(clk)then
            case score_left is
                when "0000" => ascii_score_left <= a_0;
                when "0001" => ascii_score_left <= a_1;
                when "0010" => ascii_score_left <= a_2;
                when "0011" => ascii_score_left <= a_3;
                when "0100" => ascii_score_left <= a_4;
                when "0101" => ascii_score_left <= a_5;
                when "0110" => ascii_score_left <= a_6;
                when "0111" => ascii_score_left <= a_7;
                when "1000" => ascii_score_left <= a_8;
                when "1001" => ascii_score_left <= a_9;
                when others =>NULL;
            end case;
            case score_right is
                when "0000" => ascii_score_right <= a_0;
                when "0001" => ascii_score_right <= a_1;
                when "0010" => ascii_score_right <= a_2;
                when "0011" => ascii_score_right <= a_3;
                when "0100" => ascii_score_right <= a_4;
                when "0101" => ascii_score_right <= a_5;
                when "0110" => ascii_score_right <= a_6;
                when "0111" => ascii_score_right <= a_7;
                when "1000" => ascii_score_right <= a_8;
                when "1001" => ascii_score_right <= a_9;
                when others =>NULL;
            end case;            
        end if;
    end if;
end process;

str_series_process : process(rst,clk,cnt)
begin
    if rst = '1' then
        str <= (others => '0');
    else
        if rising_edge(clk)then
            case str_num is
                when 0 => str <= l;
                when 1 => str <= e;
                when 2 => str <= f;
                when 3 => str <= t;
                when 4 => str <= space;
                when 5 => str <= colon;
                when 6 => str <= space;                                                                        
                when 7 => str <= ascii_score_left;
                when 8 => str <= space; 
                when 9 => str <= space;
                when 10 => str <= space;                                                
                when 11 => str <= r;
                when 12 => str <= i;
                when 13 => str <= g;
                when 14 => str <= h;
                when 15 => str <= t;
                when 16 => str <= space;
                when 17 => str <= colon;
                when 18 => str <= space;                    
                when 19 => str <= ascii_score_right;
                when others => NULL;
            end case;
        end if;
    end if;
tx_series <= str;
end process;


counter : process(rst,bps_clk)
begin
    if rst = '1'then
        cnt <= 0;
        str_num <= 0;
    else
        if rising_edge(bps_clk)then
            case SYSTEM_FSM is
                when READ =>            
                    if cnt < 10 then
                        cnt <= cnt +1;
                    else                
                        if str_num = total_str_num then
                            str_num <= 0;
                        else
                            str_num <= str_num + 1;
                        end if;
                        cnt <= 0;
                    end if;        
                when WAIT_EN =>                             
                    str_num <= 0;
                    cnt <= 0;   
                when others =>NULL;
            end case;
        end if;      
    end if;
end process;

tx_en_process : process (rst , clk)
begin
    if rst = '1' then
        tx_en <= '0';
    else
        if rising_edge(clk)then
            if cnt = 10 then                    -- cnt = 10 =>  finished 1 times  read str 
                tx_en <= '1';
            else
                tx_en <= '0';
            end if;
        end if;
    end if;
end process;

end Behavioral;
