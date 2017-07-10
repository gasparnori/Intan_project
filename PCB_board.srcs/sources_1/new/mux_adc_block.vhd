----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/06/2017 05:38:29 PM
-- Design Name: 
-- Module Name: mux_adc_block - Behavioral
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

entity mux_adc_block is
Generic(
    MUX_START: integer:=0; --conv start one clk cycle after mux
    CONV_END: integer:=0
    );
 Port (
    ADC_COUNTER: in integer range 0 to 47;
    CS  : in STD_LOGIC;
    CVN  : out STD_LOGIC;
    MUX_WR : out STD_LOGIC
  );
end mux_adc_block;

architecture Behavioral of mux_adc_block is
signal conv: STD_LOGIC:='0';
signal prev_conv: STD_LOGIC:='0';
signal mux_w: STD_LOGIC:='0';
begin


conv_control: process(CS,ADC_counter, conv, prev_conv)
begin
    if CS='0' then
        prev_conv<=conv;
        if ADC_counter=MUX_START+1 then
            conv<='1';
        elsif ADC_counter=CONV_END then   -- AND falling_edge(CS) 
            conv<='0';
        else
            conv<=prev_conv;
        end if;
    end if;
end process;


mux_write: process(ADC_counter)
 begin
     case ADC_counter is  --if 0: the channels can be changed, if 1: the channels are fixed
        when MUX_START => mux_w<='0';
        when others => mux_w<='1';
     end case;
 end process mux_write;

MUX_WR<=mux_w;
CVN<=conv;

end Behavioral;
