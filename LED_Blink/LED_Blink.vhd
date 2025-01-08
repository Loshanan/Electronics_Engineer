----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Loshanan
-- 
-- Create Date: 01/07/2025 09:55:47 AM
-- Design Name: 
-- Module Name: LED_Blink - Blink
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

entity LED_Blink is
    Port (
        i_clk       : in std_logic;
        i_enable    : in std_logic;
        i_switch_1  : in std_logic;
        i_switch_2  : in std_logic;
        o_led_drive : out std_logic
    );
end LED_Blink;

architecture Blink of LED_Blink is
    -- registers to count
    signal r_count_100 : std_logic (31 downto 0);
    signal r_count_50  : std_logic (31 downto 0);
    signal r_count_10  : std_logic (31 downto 0);
    signal r_count_1   : std_logic (31 downto 0);

    -- derived clock signals
    signal clk_100 : std_logic;
    signal clk_50  : std_logic;
    signal clk_10  : std_logic;
    signal clk_1   : std_logic;

    -- final clock for the led
    signal led_clk : std_logic; 
    
begin
    
end Blink;
