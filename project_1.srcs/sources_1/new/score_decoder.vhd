library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.ascii_decoder_lib.all;
entity score_decoder is
    Port (
            rst : in STD_LOGIC;
            clk : in STD_LOGIC;
            display_en : in STD_LOGIC;
            score_left : in STD_LOGIC_VECTOR (3 downto 0);
            score_right : in STD_LOGIC_VECTOR (3 downto 0);
            tx_series : out STD_LOGIC_VECTOR (7 downto 0);
            tx_en : out std_logic;
            empty : out std_logic
    );
end score_decoder;

architecture Behavioral of score_decoder is
component baud is Port (
    clk              :in std_logic;
    rst          :in std_logic;
    enable        :in std_logic;
    bps_clk     :out std_logic);
end component;

signal ascii_score_left : std_logic_vector(7 downto 0);
signal ascii_score_right: std_logic_vector(7 downto 0);
signal str_series          : std_logic_vector(39 downto 0);
signal str                    : std_logic_vector(7 downto 0);
signal bps_clk: std_logic;
signal done,tx_en_sig : std_logic;
signal cnt,str_num : integer;
begin
tx_baud :baud port map(
    clk => clk,
    rst => rst,
    enable =>done,
    bps_clk => bps_clk);

score2ascii     :process(rst,clk,score_left,score_right)
begin
    if rst = '1' then
        ascii_score_left <= a_0;
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


decoder_process : process(rst,clk,ascii_score_left,ascii_score_right)
begin
    if rst = '1'then
        str_series <= (others => '0');
        done <= '0';
    else
--        if rising_edge(clk)then
            if display_en = '1'then
                    str_series <= ascii_score_right & space & colon & space & ascii_score_left;
                    done <= '1';
            else
                done <= '0';
            end if;
--        end if; 
    end if;
end process;

counter : process(rst,clk,done,str_series)
begin
    if rst = '1'then
        cnt <= 0;
        str_num <= 0;
        tx_en_sig <= '0';
    else
        if rising_edge(bps_clk)then             
            if done = '1' then
                if cnt < 10 then
                    cnt <= cnt +1;
                    tx_en_sig <='1';
                else
                    str_num <= str_num + 1;
                    tx_en_sig <= '0';
                    cnt <= 0;
                end if;
                if str_num = 5 then
                    str_num <= 0;
                end if;
            else
                tx_en_sig <= '0';
                cnt <= 0;
            end if;
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
                when 0 => str <= ascii_score_left;
                when 1 => str <= space;
                when 2 => str <= colon;
                when 3 => str <= space;
                when 4 => str <= ascii_score_right;
                when others => NULL;
            end case;
        end if;
    end if;
end process;


end Behavioral;
