----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2017 11:34:51 AM
-- Design Name: 
-- Module Name: sim_counters - Behavioral
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

entity sim_counters is
--  Port ( );
end sim_counters;

architecture Behavioral of sim_counters is
component SPI_counter is
    Port ( 
 --          RST_IN: in STD_LOGIC;
           SCLK : in STD_LOGIC;
           CS   : in STD_LOGIC;
           MISO : out STD_LOGIC;
           MOSI : in STD_LOGIC; 
           
           ----- ADC control -----
           -----------------------------
           CVN0 : out STD_LOGIC;
           ADC_IN0: in STD_LOGIC;
           -----------------------------
           -----------------------------
           CVN1 : out STD_LOGIC;
           ADC_IN1: in STD_LOGIC;
           -----------------------------
           CVN2 : out STD_LOGIC;
           ADC_IN2: in STD_LOGIC;
           
          LED : out STD_LOGIC;
       --------external control outputs to MUX----------------------
          MUX_ADDR : out STD_LOGIC_VECTOR (4 downto 0);
          MUX_CS : out STD_LOGIC;
          MUX_EN : out STD_LOGIC;
          MUX_WR0 : out STD_LOGIC;
          MUX_WR1 : out STD_LOGIC;
          MUX_WR2 : out STD_LOGIC );
end component;

signal SCLK : STD_LOGIC:='0';
signal CS   : STD_LOGIC:='1';
signal MISO : STD_LOGIC:='0';
signal MOSI : STD_LOGIC:='0';
signal clk  : STD_LOGIC:='0';


signal SCK  : STD_LOGIC:='0';
signal LED : STD_LOGIC:='0';
signal CVN0 : STD_LOGIC:='0';
signal ADC_IN0  : STD_LOGIC:='0';
signal CVN1 : STD_LOGIC:='0';
signal ADC_IN1  : STD_LOGIC:='0';
signal CVN2 : STD_LOGIC:='0';
signal ADC_IN2  : STD_LOGIC:='0';
signal init: STD_LOGIC:='1';
signal MUX_ADDR : STD_LOGIC_VECTOR (4 downto 0):=(OTHERS=>'0');
signal MUX_CS  : STD_LOGIC:='0';
signal MUX_EN  : STD_LOGIC:='0';
signal MUX_WR0 : STD_LOGIC:='0';
signal MUX_WR1 : STD_LOGIC:='0';
signal MUX_WR2 : STD_LOGIC:='0';


begin
s: SPI_counter port map(
--    RST_IN=>RST,
    SCLK=>SCLK,
    CS=>CS,
    MISO=>MISO,
    MOSI=>MOSI,
    LED=>LED,
    ADC_IN0=>ADC_IN0,
    CVN0=>CVN0,
    ADC_IN1=>ADC_IN1,
    CVN1=>CVN1,
    ADC_IN2=>ADC_IN2,
    CVN2=>CVN2,
    MUX_ADDR=>MUX_ADDR,
    MUX_EN=>MUX_EN,
    MUX_CS=>MUX_CS,
    MUX_WR0=>MUX_WR0,
    MUX_WR1=>MUX_WR1,
    MUX_WR2=>MUX_WR2
);

c: process
begin
    wait for 10ns;
    clk<=not clk;
end process;

spi_sclk: process
variable counter: integer:=0;
begin
   wait for 40 ns;
   CS<='0';
   wait for 320 ns;
   CS<='1';
end process;

adc0: process
begin
    wait for 760 ns;
    ADC_IN0<='1';
    wait for 20 ns;
    ADC_IN0<='0';
    wait for 20 ns;
    ADC_IN0<='1';
    wait for 20 ns;
    ADC_IN0<='0';
    wait for 20 ns;
    ADC_IN0<='1';
    wait for 20 ns;
    ADC_IN0<='0';
    wait for 20 ns;
    ADC_IN0<='1';
    wait for 20 ns;
    ADC_IN0<='0';
    wait for 180 ns;
end process adc0;

adc1: process
begin
    if init='1' then
        init<='0';
        wait for 360 ns;
    else
        wait for 760 ns;
        ADC_IN1<='1';
        wait for 160 ns;
        ADC_IN1<='0';
        wait for 140 ns;
        ADC_IN1<='1';
        wait for 20 ns;
        ADC_IN1<='0';
    end if;
end process adc1;

adc2: process
begin
    if init='1' then
       wait for 720 ns;
    else
        wait for 760 ns;
        ADC_IN2<='1';
        wait for 20 ns;
        ADC_IN2<='0';
        wait for 140 ns;
        ADC_IN2<='1';
        wait for 160 ns;
        ADC_IN2<='0';
    end if;
end process adc2;

SCLK<=clk AND (not CS);
end Behavioral;
