----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2017 12:45:59 PM
-- Design Name: 
-- Module Name: adc - Behavioral
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
entity adc is
    Port ( 
        ---- internal ports from/to the system ----
         --  EN   : in STD_LOGIC;
           CLK  : in STD_LOGIC;
           RST  : in STD_LOGIC;
           START_CONV: in STD_LOGIC;
           END_CONV: in STD_LOGIC;
        --- external ports to control the ADC ----   
           ADC_IN : in STD_LOGIC;  -- input data
           CVN    : out STD_LOGIC; --pulled high: conversion starts, pulled low: communication starts
           SCK    : out STD_LOGIC);
end adc;

architecture Behavioral of adc is

begin


end Behavioral;
