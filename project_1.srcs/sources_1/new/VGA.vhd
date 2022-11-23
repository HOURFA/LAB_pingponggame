----------------------------------------------------------------------------------
-- Company: NKUSY
-- Engineer: RFA
-- 
-- Create Date: 2022/11/23 20:36:57
-- Design Name: 
-- Module Name: VGA - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA is Port (
    i_VGA_clk   : in std_logic;
    i_radom_clk : in std_logic;
    i_rst   : in std_logic;
    i_prestate : in std_logic;
    i_act   : in std_logic_vector(2 downto 0);
    o_Rout : out std_logic_vector(3 downto 0);
    o_Gout : out std_logic_vector(3 downto 0);
    o_Bout : out std_logic_vector(3 downto 0);
    o_hsync : out std_logic;
    o_vsync : out std_logic
);
end VGA;

architecture Behavioral of VGA is

component vga_driver is port(
    clk                     : in std_logic;
    rst                      : in std_logic;
    video_start_en     : in std_logic;
    vga_hs_cnt          : out integer;
    vga_vs_cnt          : out integer;
    hsync                 : out std_logic;
    vsync                 : out std_logic);
 end component;
component addres_counter is
    Port (
        clk             : in std_logic;
        reset           : in std_logic;    
        shift       : in integer;      
        vga_vs_cnt      : in integer;
        vga_hs_cnt      : in integer;
        en              : out std_logic;
        addra           : out std_logic_vector (13 downto 0));
end component; 
component blk_mem_gen_0 IS PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
end component;

component VGA_display is Port ( 
    clk : in STD_LOGIC;
    div_clk : in STD_LOGIC;    
    rst : in STD_LOGIC;
    vga_vs_cnt : in integer;
    vga_hs_cnt : in integer;
    prestate    : in std_logic;    
    shift       : inout integer;    
    img_in          : in std_logic_vector(11 downto 0);    
    act : in std_logic_vector(2 downto 0);
    Rout            : inout std_logic_vector(3 downto 0); --
    Gout            : inout std_logic_vector(3 downto 0); --
    Bout            : inout std_logic_vector(3 downto 0));
end component;

signal Rout_sig ,Gout_sig , Bout_sig : std_logic_vector(3 downto 0);
signal vga_hs_cnt , vga_vs_cnt,shift : integer;

-- bram
signal bram_en : std_logic;
signal img_data : std_logic_vector(11 downto 0);
signal bram_addr : std_logic_vector(13 downto 0);
--
begin

o_Rout <= Rout_sig;
o_Gout <= Gout_sig;
o_Bout <= Bout_sig;



addr_counter_1 :addres_counter port map(
    clk            => i_VGA_clk,
    reset          => i_rst,
    shift          => shift,     
    vga_vs_cnt     => vga_vs_cnt,
    vga_hs_cnt     => vga_hs_cnt,
    en             => bram_en,
    addra          => bram_addr);    
bram : blk_mem_gen_0 port map(
    clka => i_VGA_clk,
    ena  => bram_en,
    addra => bram_addr ,
    douta => img_data);
vga_1 :vga_driver port map( 
    clk             => i_VGA_clk, --
    rst             => i_rst,
    video_start_en  => '1',
    vga_hs_cnt      => vga_hs_cnt,
    vga_vs_cnt      => vga_vs_cnt,
    hsync           => o_hsync,
    vsync           => o_vsync );     

vga_display_1 : VGA_display Port map( 
    clk         => i_VGA_clk,
    div_clk     => i_radom_clk,
    rst         => i_rst,
    prestate    => i_prestate,
    img_in      => img_data,
    shift       => shift,
    vga_vs_cnt => vga_vs_cnt,
    vga_hs_cnt => vga_hs_cnt,
    act        => i_act,
    Rout       => Rout_sig,
    Gout       => Gout_sig,
    Bout       => Bout_sig);
    
end Behavioral;
