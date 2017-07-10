----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/06/2017 09:18:44 PM
-- Design Name: 
-- Module Name: commands - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity commands is
 Port (
   CS: in STD_LOGIC;
   MSB: in STD_LOGIC_VECTOR(7 downto 0);
   LSB: in STD_LOGIC_VECTOR(7 downto 0);
   RESPONSE: out STD_LOGIC_VECTOR(15 downto 0);
   -- if '1' response should be ignored and ADC results should be read
   CONV_FLAG: out STD_LOGIC       
 );
end commands;

architecture Behavioral of commands is
signal delay_resp: STD_LOGIC_VECTOR(15 downto 0):=(OTHERS=>'0');
signal resp: STD_LOGIC_VECTOR(15 downto 0):=(OTHERS=>'0');
signal delay_conv_flag: STD_LOGIC:='0';
signal c_flag: STD_LOGIC:='0';
begin
r: process(CS)
begin
    if  rising_edge(CS) then --finished reading this command
        case MSB(7 downto 6) is
            when "00" => delay_resp<=("0000000000000010");   --conversion: will be overwritten by real data
            when "01" => delay_resp<=("0000000000000000");   --calibration
            when "10" => delay_resp<=("11111111" & LSB);  --write to register
            when others => delay_resp<=("0000000000000001");    --read from register (chip ID)
        end case;
       if MSB(7 downto 6)= "00" then
            delay_conv_flag<='1';
       else
            delay_conv_flag<='0';
       end if;     
     resp<=delay_resp;
     c_flag<=delay_conv_flag;
    end if;
end process r;
RESPONSE<=resp;
CONV_FLAG<=c_flag;


end Behavioral;
