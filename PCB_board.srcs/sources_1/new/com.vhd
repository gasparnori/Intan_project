----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/06/2017 09:44:19 PM
-- Design Name: 
-- Module Name: com - Behavioral
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

entity com is
    Port (   
    CS: in STD_LOGIC;
    MSB: in STD_LOGIC_VECTOR(7 downto 0);
    LSB: in STD_LOGIC_VECTOR(7 downto 0);
    RESPONSE: out STD_LOGIC_VECTOR(15 downto 0);
      -- if '1' response should be ignored and ADC results should be read
    CONV_FLAG: out STD_LOGIC     
);
end com;

architecture Behavioral of com is
signal delay_resp: STD_LOGIC_VECTOR(15 downto 0):=(OTHERS=>'0');
signal resp: STD_LOGIC_VECTOR(15 downto 0):=(OTHERS=>'0');
signal delay_conv_flag: STD_LOGIC:='0';
signal c_flag: STD_LOGIC:='0';
begin
r: process(CS)
begin
end process r;

end Behavioral;
