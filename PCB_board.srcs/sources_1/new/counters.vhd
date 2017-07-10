----------------------------------------------------------------------------------
-- Company: Starklab
-- Engineer: Nora Gaspar
-- 
-- Create Date: 02/23/2017 10:53:57 AM
-- Design Name: 
-- Module Name: SPI_counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity SPI_counter is
    Port ( 
           ---- RST_IN: in STD_LOGIC;
           SYSCLK: in STD_LOGIC;    --only used for debouncing
           SCLK  : in STD_LOGIC;
           CS    : in STD_LOGIC;
           MISO  : out STD_LOGIC;
           MOSI  : in STD_LOGIC;
           
           ----- ADC control -----
           CVN0   : out STD_LOGIC;
           ADC_IN0: in STD_LOGIC;
           -----------------------------
           CVN1   : out STD_LOGIC;
           ADC_IN1: in STD_LOGIC;
           -----------------------------
           CVN2   : out STD_LOGIC;
           ADC_IN2: in STD_LOGIC;
           
          ----external control outputs to MUX
          MUX_ADDR : out STD_LOGIC_VECTOR (4 downto 0);
          MUX_CS   : out STD_LOGIC;
          MUX_EN   : out STD_LOGIC;
          MUX_WR0  : out STD_LOGIC;
          MUX_WR1  : out STD_LOGIC;
          MUX_WR2  : out STD_LOGIC;
          
          -------- led on pin 48
          LED      : out STD_LOGIC );
end SPI_counter;

architecture Behavioral of SPI_counter is

component mux_adc_block is
Generic(
    MUX_START: integer:=0; --conv start one clk cycle after mux
    CONV_END : integer:=0
    );
 Port (
    ADC_COUNTER: in integer range 0 to 47;
    CS   : in STD_LOGIC;
    CVN  : out STD_LOGIC;
    MUX_WR : out STD_LOGIC
  );
end component;

component commands is
 Port (
    CS: in STD_LOGIC;
    MSB: in STD_LOGIC_VECTOR(7 downto 0);
    LSB: in STD_LOGIC_VECTOR(7 downto 0);
    RESPONSE: out STD_LOGIC_VECTOR(15 downto 0);
    CONV_FLAG: out STD_LOGIC     -- if '1' response should be ignored and ADC results should be read
 );
end component;

component debounce_CS is
    Port ( 
        CS : in STD_LOGIC;
        d_CS : out STD_LOGIC;
        ADC_counter : in integer range 0 to 47);
end component;
----------temporary-------
signal RST: STD_LOGIC:='1';
--------------------------
signal readcmd: STD_LOGIC_VECTOR(15 downto 0):=(OTHERS=>'0');
signal resp: STD_LOGIC_VECTOR(15 downto 0):=(OTHERS=>'1');

signal adc_data_out : STD_LOGIC:='0';
signal resp_data_out : STD_LOGIC:='0';
signal conv_f : STD_LOGIC:='0';

signal debounced_CS: STD_LOGIC:='0';

signal MUX_start_signals: STD_LOGIC_VECTOR(2 downto 0):="000";
signal CONV_start_signals: STD_LOGIC_VECTOR(2 downto 0):="000";

signal next_channel: unsigned(4 downto 0):=(OTHERS=>'0');

signal ADC_counter: integer range 0 to 47:=0;
signal active_read: integer range 0 to 2:=0;
signal sclk_counter: STD_LOGIC_VECTOR(99 downto 0):=(OTHERS=>'1');



constant COMMAND_LENGTH: integer:=16;
constant MSB_LENGTH: integer:=8;
constant num_blocks: integer:=3;

-------the ADC_counter value when the ADC data is ready

type d is array (0 to 2) of integer;
constant delays: d:=(32, 0, 16);

begin
------debouncing CS -----------
deb: process (CS, ADC_COUNTER)
begin
     if (ADC_counter=0 OR ADC_counter=16 OR ADC_counter=32) AND CS='1' then
      debounced_CS<='1';
    else
      debounced_CS<='0';
    end if;
end process deb;

----- reset timer --------------
res: process(SYSCLK, SCLK)
begin
    if rising_edge(SYSCLK) then
            sclk_counter(99)<=SCLK;
            sclk_counter(98 downto 0)<=sclk_counter(99 downto 1);
    end if;
    
end process res;

count: process(SCLK, sclk_counter)
variable zeros: STD_LOGIC_VECTOR(99 downto 0):=(OTHERS=>'0');
begin
    if sclk_counter=zeros then
        ADC_counter<=0;
    else
        if rising_edge(SCLK) then
            if ADC_counter=47 then
                ADC_counter<=0;
            else
                ADC_counter<=ADC_counter+1;
            end if;  
         end if;
    end if;
end process count;
---------------------------------  MISO output multiplexer ------------------------------
read_data:process(ADC_IN0, ADC_IN1, ADC_IN2, active_read, debounced_CS)
begin
    if debounced_CS='0' then
        case active_read is
            when 0 => adc_data_out <= ADC_IN0;
            when 1 => adc_data_out <= ADC_IN1;
            when others => adc_data_out <= ADC_IN2;
        end case;
    else
    adc_data_out<='0';
    end if;
end process;

p:process(debounced_CS, sclk_counter)
variable zeros: STD_LOGIC_VECTOR(99 downto 0):=(OTHERS=>'0');
begin
    if sclk_counter=zeros then
           active_read<=0;
    else
        if rising_edge(debounced_CS) then
            if active_read=2 then
                active_read<=0;
            else
                active_read<=active_read+1;
            end if;
        end if;
    end if;
end process;



---MUX_ADC controllers
GEN_BLOCKS: for i in 0 to 2 generate
b: mux_adc_block
    Generic map(
        MUX_START => MSB_LENGTH+ i*(COMMAND_LENGTH),
        CONV_END  => delays(i)
        )
    Port map(
       ADC_COUNTER => ADC_counter,
       CS     => debounced_CS,
       CVN    => CONV_start_signals(i),
       MUX_WR => MUX_start_signals(i)
   );
end generate;

 
mux_proc: process(ADC_counter, readcmd)
 begin
     --doesn't have to be synchronized, only matters when WR is low
     MUX_ADDR<=readcmd(12 downto 8); --chooses the channel to latch

 end process mux_proc;

-----------------------------
readSPI: process(SCLK, MOSI, debounced_CS)
   variable bitcounter: integer range 0 to 15:=0;
   begin
       if debounced_CS='1' then
            bitcounter:=0;
       else
           if rising_edge(SCLK) then
              readcmd(15-bitcounter)<=MOSI;
              if bitcounter=15 then
                   bitcounter:=15;
              else
                   bitcounter:=bitcounter+1;
              end if;
           end if;
       end if;
 end process readSPI;
 
u: commands
   Port map(
      CS=>debounced_CS,
      MSB=> readcmd(15 downto 8),
      LSB=> readcmd(7 downto 0),
      RESPONSE=>resp,
      CONV_FLAG=> conv_f
   );
  
response_out: process(SCLK, debounced_CS, resp)
  variable bitcounter: integer range 0 to 15:=0;
  begin   
      if debounced_CS='1' then
          resp_data_out<='0';
      else
           if rising_edge(SCLK) then
                resp_data_out<=resp(15-bitcounter);
                if bitcounter=15 then
                    bitcounter:=0;
                else
                    bitcounter:=bitcounter+1;
               end if;
            end if;
      end if;
end process response_out;
 
MISO<=resp_data_out; --adc_data_out when conv_f='1' else resp_data_out;
LED<=SCLK;
CVN0<=CONV_start_signals(0);
CVN1<=CONV_start_signals(1);
CVN2<=CONV_start_signals(2);
MUX_WR0<=MUX_start_signals(0);
MUX_WR1<=MUX_start_signals(1);
MUX_WR2<=MUX_start_signals(2);

MUX_CS<='1';
MUX_EN<='1';

end Behavioral;
