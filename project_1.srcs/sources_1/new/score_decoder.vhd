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
    setting_in : in STD_LOGIC_VECTOR(7 downto 0);
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
type OUTPUT_FSM is (SCORE , WIN , SETTING);
TYPE SETTING_FSM is (IDLE , SPEED_SETTING , SCORE_SETTING );
signal SYSTEM_FSM : FSM;
signal OUTPUT_MODE : OUTPUT_FSM;
signal SETTING_MODE : SETTING_FSM;
signal ascii_score_left : std_logic_vector(7 downto 0);
signal ascii_score_right: std_logic_vector(7 downto 0);
signal str                    : std_logic_vector(7 downto 0);
signal bps_clk,bps_en: std_logic;
signal done , win_left , win_right : std_logic;
signal cnt,str_num ,UB , MAX_SCORE: integer;
signal setting_done : std_logic;
begin
tx_baud :baud port map(
    clk => clk,
    rst => rst,
    enable => bps_en,
    bps_clk => bps_clk);
    
tx_series <= str;

FSM_process : process(rst,clk,str_num)
begin
    if rst = '1' then
        SYSTEM_FSM <= READ;
        UB <= 0;
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
                    case OUTPUT_MODE is
                        when SCORE => UB <= score_num;
                            if str_num = UB then
                                SYSTEM_FSM <= WAIT_EN;
                            else
                                SYSTEM_FSM <= READ;
                            end if;
                        when WIN => UB <= win_num;
                            if str_num = UB then
                                SYSTEM_FSM <= WAIT_EN;
                            else
                                SYSTEM_FSM <= READ;
                            end if;                        
                        when SETTING =>
                            case SETTING_MODE is
                                when IDLE          => UB <= SETTING_IDLE_NUM  ;   -- SETTING_MODE : (1) SPEED  (2) SCORE  (9) QUIT
                                when SPEED_SETTING => UB <= SETTING_SPEED_NUM ;   --(1) HIGHT_SPEED (2) MIDDLE_SPEED (3) SLOW SPEED
                                when SCORE_SETTING => UB <= SETTING_SCORE_NUM ;   --Please enter maximum score : 
                                when others => NULL;
                             end case;
                            if str_num = UB then
                                SYSTEM_FSM <= WAIT_EN;
                            else
                                SYSTEM_FSM <= READ;
                            end if;         
                        when others => NULL;
                    end case;
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

OUTPUT_FSM_process : process(rst, clk)
begin
    if rst = '1' then
        OUTPUT_MODE <= SETTING;
    else
        if rising_edge(clk) then
            case OUTPUT_MODE is
                when SCORE =>
                    if win_left = '1' or win_right = '1' then
                        OUTPUT_MODE <= WIN;
                    else
                        OUTPUT_MODE <= SCORE;
                    end if;
                when WIN => NULL;                        
                when SETTING =>
                    if setting_done = '1' then
                        OUTPUT_MODE <= SCORE;
                    else
                        OUTPUT_MODE <= SETTING;
                    end if;
                when others => NULL;
            end case;
        end if;
    end if;
end process;

SETTING_FSM_process : process(rst,clk)
begin
    if rst = '1' then
        SETTING_MODE <= IDLE;
        setting_done <= '0';
    else
        if rising_edge(clk) then
            case SETTING_MODE is
                when IDLE =>
                    case setting_in is
                        when a_1 => SETTING_MODE <= SPEED_SETTING;
                        when a_2 => SETTING_MODE <= SCORE_SETTING;
                        when a_9 => SETTING_MODE <= IDLE; setting_done <= '1';
                        when others =>  SETTING_MODE <= IDLE;
                    end case; 
                when SPEED_SETTING =>
                    case setting_in is
                        when a_1 => SETTING_MODE <= IDLE;
                        when a_2 => SETTING_MODE <= IDLE;
                        when a_3 => SETTING_MODE <= IDLE;                    
                        when a_9 => SETTING_MODE <= IDLE;
                        when others => SETTING_MODE <= SPEED_SETTING;
                    end case;
                when SCORE_SETTING =>
                    case setting_in is
                        when a_1 => SETTING_MODE <= IDLE;
                        when a_2 => SETTING_MODE <= IDLE;
                        when a_3 => SETTING_MODE <= IDLE;   
                        when a_4 => SETTING_MODE <= IDLE;
                        when a_5 => SETTING_MODE <= IDLE;
                        when a_6 => SETTING_MODE <= IDLE;   
                        when a_7 => SETTING_MODE <= IDLE;
                        when a_8 => SETTING_MODE <= IDLE;                                                                                         
                        when a_9 => SETTING_MODE <= IDLE;
                        when others => SETTING_MODE <= SCORE_SETTING;
                    end case;                
                when others => NULL;
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

win_judge_process : process (rst , clk)
begin
    if rst = '1' then
        win_left <= '0';
        win_right <= '0';    
        MAX_SCORE <= 9 ;
    else
        if rising_edge(clk)then
            if score_right = MAX_SCORE then
                win_right <= '1';
            else
                win_right <= '0';
            end if;
            if score_left = MAX_SCORE then
                win_left <= '1';
            else
                win_left <= '0';
            end if;            
        end if;        
    end if;
end process;

SCORE_process : process(rst,clk,cnt)
begin
    if rst = '1' then
        str <= (others => '0');
    else
        if rising_edge(clk)then
            case OUTPUT_MODE is
                when SCORE =>
                    case str_num is
                        when 0 => str <= l;
                        when 1 => str <= e;
                        when 2 => str <= f;
                        when 3 => str <= t;
                        when 4 => str <= space;
                        when 5 => str <= colon;
                        when 6 => str <= space;                                                                        
                        when 7 => str <= ascii_score_left;
                        when 8 => str <= FF; 
                        when 9 => str <= BS;
                        when 10 => str <= BS;
                        when 11 => str <= BS;
                        when 12 => str <= BS;
                        when 13 => str <= BS;
                        when 14 => str <= BS;
                        when 15 => str <= BS;
                        when 16 => str <= BS;                                                                                                                                                   
                        when 17 => str <= r;
                        when 18 => str <= i;
                        when 19 => str <= g;
                        when 20 => str <= h;
                        when 21 => str <= t;
                        when 22 => str <= space;
                        when 23 => str <= colon;
                        when 24 => str <= space;                    
                        when 25 => str <= ascii_score_right;
                        when 26 => str <= FF;
                        when 27 => str <= BS;
                        when 28 => str <= BS;
                        when 29 => str <= BS;
                        when 30 => str <= BS;
                        when 31 => str <= BS;
                        when 32 => str <= BS;
                        when 33 => str <= BS;
                        when 34 => str <= BS;
                        when 35 => str <= BS;
                        when 36 => str <= dash;
                        when 37 => str <= dash;
                        when 38 => str <= dash;
                        when 39 => str <= dash;
                        when 40 => str <= dash;
                        when 41 => str <= dash;
                        when 42 => str <= dash;
                        when 43 => str <= dash;                    
                        when 44 => str <= dash;
                        when 45 => str <= FF;
                        when 46 => str <= BS;
                        when 47 => str <= BS;
                        when 48 => str <= BS;
                        when 49 => str <= BS;
                        when 50 => str <= BS;
                        when 51 => str <= BS;
                        when 52 => str <= BS;
                        when 53 => str <= BS;
                        when 54 => str <= BS;                                    
                        when others => NULL;
                    end case;
                when WIN =>
                    case str_num is
                        when 0 => str <= w;
                        when 1 => str <= i;
                        when 2 => str <= n;
                        when 3 => str <= n;
                        when 4 => str <= e;
                        when 5 => str <= r;
                        when 6 => str <= space;                                                                        
                        when 7 => str <= colon;
                        when 8 => str <= space; 
                        when 9 => 
                            if win_left = '1' then
                                str <= space;
                            elsif win_right = '1' then
                                str <= r;
                            end if;
                        when 10 =>
                            if win_left = '1' then
                                str <= l;
                            elsif win_right = '1' then
                                str <= i;
                            end if;
                        when 11 =>
                            if win_left = '1' then
                                str <= e;
                            elsif win_right = '1' then
                                str <= g;
                            end if;
                        when 12 =>
                            if win_left = '1' then
                                str <= f;
                            elsif win_right = '1' then
                                str <= h;
                            end if;
                        when 13 =>
                            if win_left = '1' then
                                str <= t;
                            elsif win_right = '1' then
                                str <= t;
                            end if;           
                        when others => NULL;                                             
                    end case;
                when SETTING =>
                    case SETTING_MODE is
                        when IDLE =>
                            case str_num is
                                when 0 => str <= B_S;
                                when 1 => str <= B_E;
                                when 2 => str <= B_E;
                                when 3 => str <= B_T;
                                when 4 => str <= B_T;
                                when 5 => str <= B_I;
                                when 6 => str <= B_N;
                                when 7 => str <= B_G;
                                when 8 => str <= baseline;
                                when 9 => str <= B_M;
                                when 10 => str <= B_O;
                                when 11 => str <= B_D;
                                when 12 => str <= B_E;
                                when 13 => str <= space;
                                when 14 => str <= colon;
                                when 15 => str <= space;
                                when 16 => str <= left_p;
                                when 17 => str <= a_1;
                                when 18 => str <= right_p;
                                when 19 => str <= space;  
                                when 20 => str <= B_S;
                                when 21 => str <= B_P;
                                when 22 => str <= B_E;
                                when 23 => str <= B_E;
                                when 24 => str <= B_D;
                                when 25 => str <= space;
                                when 26 => str <= left_p;
                                when 27 => str <= a_2;
                                when 28 => str <= right_p;
                                when 29 => str <= space;
                                when 30 => str <= B_S;
                                when 31 => str <= B_C;
                                when 32 => str <= B_O;
                                when 33 => str <= B_R;
                                when 34 => str <= B_E;
                                when 35 => str <= space;
                                when 36 => str <= left_p;
                                when 37 => str <= a_9;
                                when 38 => str <= right_p;
                                when 39 => str <= space;
                                when 40 => str <= B_Q;
                                when 41 => str <= B_U;
                                when 42 => str <= B_I;
                                when 43 => str <= B_T;
                                when 44 => str <= FF;                                
                                when others => NULL;                                                                                                                                                                                                                            
                            end case;
                        when SPEED_SETTING =>
                            case str_num is
                                when 0 => str <= left_p;
                                when 1 => str <= a_1;
                                when 2 => str <= right_p;
                                when 3 => str <= space;
                                when 4 => str <= B_H;
                                when 5 => str <= B_I;
                                when 6 => str <= B_G;
                                when 7 => str <= B_H;
                                when 8 => str <= baseline;
                                when 9 => str <= B_S;
                                when 10 => str <= B_P;
                                when 11 => str <= B_E;
                                when 12 => str <= B_E;
                                when 13 => str <= B_D;
                                when 14 => str <= space;
                                when 15 => str <= left_p;
                                when 16 => str <= a_2;
                                when 17 => str <= right_p;
                                when 18 => str <= space;
                                when 19 => str <= B_M;  
                                when 20 => str <= B_I;
                                when 21 => str <= B_D;
                                when 22 => str <= B_D;
                                when 23 => str <= B_L;
                                when 24 => str <= B_E;
                                when 25 => str <= baseline;
                                when 26 => str <= B_S;
                                when 27 => str <= B_P;
                                when 28 => str <= B_E;
                                when 29 => str <= B_E;
                                when 30 => str <= B_D;
                                when 31 => str <= space;
                                when 32 => str <= left_p;
                                when 33 => str <= a_3;
                                when 34 => str <= right_p;
                                when 35 => str <= space;
                                when 36 => str <= B_S;
                                when 37 => str <= B_L;
                                when 38 => str <= B_O;
                                when 39 => str <= B_W;
                                when 40 => str <= baseline;
                                when 41 => str <= B_S;
                                when 42 => str <= B_P;
                                when 43 => str <= B_E;
                                when 44 => str <= B_E;
                                when 45 => str <= B_D;
                                when 46 => str <= FF;                                
                                when others => NULL;
                            end case;
                        when SCORE_SETTING =>
                            case str_num is
                                when 0 => str <= B_P;
                                when 1 => str <= l;
                                when 2 => str <= e;
                                when 3 => str <= a;
                                when 4 => str <= s;
                                when 5 => str <= e;
                                when 6 => str <= space;
                                when 7 => str <= e;
                                when 8 => str <= n;
                                when 9 => str <= t;
                                when 10 => str <= e;
                                when 11 => str <= r;
                                when 12 => str <= space;
                                when 13 => str <= m;
                                when 14 => str <= a;
                                when 15 => str <= x;
                                when 16 => str <= i;
                                when 17 => str <= m;
                                when 18 => str <= u;
                                when 19 => str <= m;  
                                when 20 => str <= space;
                                when 21 => str <= s;
                                when 22 => str <= p;
                                when 23 => str <= e;
                                when 24 => str <= e;
                                when 25 => str <= d;
                                when 26 => str <= space;
                                when 27 => str <= colon;
                                when 28 => str <= space;
                                when 29 => str <= setting_in;
                                when 30 => str <= FF;                                
                                when others => NULL;
                            end case;
                        when others => NULL;
                    end case;
                when others => NULL;
            end case;
        end if;
    end if;
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
                        if str_num = UB then
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
