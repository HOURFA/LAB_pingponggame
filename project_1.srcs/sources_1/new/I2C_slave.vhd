library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity I2C_slave is  Port (
    sda       : inout std_logic;
    rst     : in std_logic;
    scl     : in std_logic;
    data_in  : in std_logic_vector(7 downto 0); --要傳給master的數據
    data_out : out std_logic_vector(7 downto 0));--master傳過來的數據   
end I2C_slave;

architecture Behavioral of I2C_slave is

signal addr_in : std_logic_vector(7 downto 0);
signal wr_times : integer range 0 to 4;
signal test,addr_start, done,addr_done,wr_done,rd_done,rw_switch ,data_addr_start,match_false,ack_judge,rw_done,ack_done,stop: std_logic;
signal cnt_addr,cnt_wr,cnt_rd : integer range 0 to 10;

constant addr   : std_logic_vector(7 downto 0) := "10101010";

begin

addr_process :process(sda,scl,rst,cnt_addr)
begin
if rst = '1' then
    cnt_addr <= 7;
    match_false <= '0';
    addr_start <= '0';
    addr_done <= '0';
    addr_in <= (others => '0');
else
    if scl = '1' and sda'event and sda = '0' then   --偵測到start
        addr_start <= '1';
    end if;
    if rising_edge(scl) then
        if addr_start = '1' then  
            if cnt_addr > 0 then
                cnt_addr <= cnt_addr -1;
            elsif cnt_addr = 0 then
                cnt_addr <= 7;
                addr_start <= '0'; 
                addr_done <= '1';
                if addr_in = addr then
                    match_false <= '0';     
                else
                    match_false <= '1';
                end if;   
            end if ;            
        else
            addr_done <= '0'; 
        end if; 
    end if;
    if falling_edge(scl) then
        if addr_start = '1' then  
            if cnt_addr <= 7 then
                addr_in(cnt_addr) <= sda;
            end if ;
        end if ;
    end if;
    if stop = '1' then
        addr_in <= (others => '0');
    end if;    
end if;
end process;

rw_process:process(rst,addr_done,sda,scl)
begin
if rst = '1' then
    rw_switch <= 'Z';
    rw_done <= '0';
else
    if rising_edge(scl)then
        if addr_done = '1' then
            rw_switch <= sda;
            rw_done <= '1';
        else
            rw_done <= '0';
        end if;
    end if;
end if;
end process;
ack_process: process(rst,done,ack_judge,wr_done,match_false,rd_done,rw_done,scl,ack_done,stop,sda)
begin
if rst = '1' then 
    data_addr_start <= '0';
    done <= '0';
    stop <= '0';
    ack_judge <= '0';
    ack_done <= '0';  
    sda <= 'Z';     
else
        if scl = '1' and sda'event and sda = '1' then
            stop <= '1'; 
        end if;
        if stop = '1' then
            if sda = '0'then
                stop <= '0';
            end if;
        end if;
        if  rw_done = '1'  or rd_done = '1' or wr_done = '1'then  --當要進入response狀態時 
            if falling_edge(scl) then         
                ack_judge <= '1';              
            end if;
        end if; 
        if ack_judge = '1' then                                         --產生半個 scl 週期的訊號 ack_done
            if  rising_edge(scl)  then
                ack_judge <= '0'; 
            end if;
        end if;             
        if ack_judge = '1' then   
            if rw_done = '1' or (rw_switch = '0' and wr_done = '1' )then                                       --進行ack&nack的判斷                                          
                if done = '1' or match_false = '1' then --nack
                    sda <= '1';
                else                                    --ack
                    sda <= '0';  
                    data_addr_start <= '1';
                end if;                      
            end if;
            if (rd_done = '1' and rw_switch = '1') then
                data_addr_start <= '1';                   
            end if;
        else    
            sda <= 'Z';
        end if;
        if stop = '1' then
            data_addr_start <= '0';
        end if;        
        if wr_times < 4 then
            done <= '0';
        elsif wr_times = 4  then
            done <= '1';
        end if; 
        if ( wr_done = '1' or rd_done = '1' )and ack_judge = '0'then
            data_addr_start <= '0';
        end if;
end if;
end process;

wr_process:process(rst,scl,cnt_wr,data_addr_start,sda,rw_switch,addr_in,wr_times)
begin
if rst = '1' then
    wr_done <= '0';
    cnt_wr <= 8;
    wr_times <= 0; 
    data_out <= (others => '0');
else
    if rising_edge(scl) then
            if rw_switch = '0' then
                if data_addr_start = '1' then
                    wr_done <= '0';
                    if cnt_wr > 0 then
                        cnt_wr <= cnt_wr - 1;
                    elsif cnt_wr = 0 then
                        cnt_wr <= 8;
                        wr_done <= '1';
                        wr_times <= wr_times + 1;                                
                    end if;
                    if cnt_wr <= 7 then
                        data_out(cnt_wr) <= sda;
                    end if ; 
                else
                    wr_done <= '0';
                    cnt_wr <= 8;
                end if;
                if  wr_times = 4 then
                    wr_times <= 0;
                end if;    
            end if;                      
    end if; 
end if;
end process;

rd_process:process(rst,scl,rw_switch,data_addr_start,addr_in,cnt_rd,data_in)
begin
if rst = '1' then
    cnt_rd <= 8;
    rd_done <='0';
    test <= '0';
    sda <= 'Z';
elsif rst ='0' then
    if rising_edge(scl) then
        if rw_switch = '1'then
            if data_addr_start = '1' then
                    if cnt_rd > 0 then
                        cnt_rd <= cnt_rd - 1;
                    elsif cnt_rd = 0 then
                        cnt_rd <= 8; 
                        rd_done <= '1';                     
                    end if; 
            else
                cnt_rd <= 8;
            end if;
        end if;
    end if;
    if scl = '0'then
        if cnt_rd <= 7 then
            sda <= data_in(cnt_rd);
            test <= data_in(cnt_rd);
        end if ;  
    elsif  scl = '1' then
        sda <= 'Z';
    end if;
    if ack_judge = '1' then
        if data_addr_start = '1' or stop = '1' then
            rd_done <= '0';
        end if;
    end if;
end if;
end process;
end Behavioral;
