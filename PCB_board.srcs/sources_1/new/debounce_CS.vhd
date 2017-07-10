----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2017 11:04:44 AM
-- Design Name: 
-- Module Name: debounce_CS - Behavioral
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

entity debounce_CS is
    Port ( CS : in STD_LOGIC;
           d_CS : out STD_LOGIC;
           ADC_counter : in integer range 0 to 47);
end debounce_CS;

architecture Behavioral of debounce_CS is
begin
 if (ADC_counter=0 OR ADC_counter=16 OR ADC_counter=32) AND CS='1' then
   d_CS<='1';
else
   d_CS<='0';
end if;
end Behavioral;


--debounce_CS: process(CS, SYSCLK)
--variable temp: STD_LOGIC_VECTOR (2 downto 0):="000";
-- begin
--    if rising_edge(SYSCLK) then
--    temp(2):=CS;
--    temp(1 downto 0):=temp(2 downto 1);
--    case (temp) is
--        when "000"=> debounced_CS<='0';
--        when "001"=> debounced_CS<='0';
--        when "010"=> debounced_CS<='0';
--        when "100"=> debounced_CS<='0';
--        when others=> debounced_CS<='1';
--    end case;
--    end if;
-- end process debounce_CS;