library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port(
        i_bit1 : in  std_logic;
        i_bit2 : in  std_logic;
        i_cin  : in  std_logic;

        o_sum  : out std_logic;
        o_cout : out std_logic
    );
end full_adder;

architecture rtl of full_adder is

    signal w_wire1 : std_logic;
    signal w_wire2 : std_logic;
    signal w_wire3 : std_logic;
    
begin

    w_wire1 <= i_bit1  xor i_bit2;
    w_wire2 <= w_wire1 and i_cin;
    w_wire3 <= i_bit1  and i_bit2;

    o_sum   <= w_wire1 xor i_cin;
    o_cout  <= w_wire2 or  w_wire3; 
    
end rtl;