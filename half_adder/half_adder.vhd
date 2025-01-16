----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Loshanan
-- 
-- Create Date: 01/16/2025 07:05:32 PM
-- Design Name: 
-- Module Name: half_adder - rtl
-- Project Name: Basic modules from NandLand
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

entity half_adder is
    Port (
        i_bit1  : in  std_logic;
        i_bit2  : in  std_logic;

        o_sum   : out std_logic;
        o_carry : out std_logic
    );
end half_adder;

architecture rtl of half_adder is
begin
    o_sum   <= i_bit1 xor i_bit2;
    o_carry <= i_bit1 and i_bit2;
end rtl;
