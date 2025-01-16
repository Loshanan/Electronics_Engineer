library ieee;
use ieee.std_logic_1164.all;

entity half_adder_tb is
end entity half_adder_tb;

architecture behave of half_adder_tb is
    signal r_BIT1  : std_logic := '0';
    signal r_BIT2  : std_logic := '0';

    signal w_SUM   : std_logic;
    signal w_CARRY : std_logic;

    component half_adder is
        Port (
            i_bit1  : in  std_logic;
            i_bit2  : in  std_logic;
    
            o_sum   : out std_logic;
            o_carry : out std_logic
        );
    end component;

begin

    UUT : half_adder
    port map(
        i_bit1 => r_BIT1,
        i_bit2 => r_BIT2,
        o_sum => w_SUM,
        o_carry => w_CARRY
    );
    
    process is
    begin
        r_BIT1 <= '0'; r_BIT2 <= '0';
        wait for 10 ns;
        r_BIT1 <= '0'; r_BIT2 <= '1';
        wait for 10 ns;
        r_BIT1 <= '1'; r_BIT2 <= '0';
        wait for 10 ns;
        r_BIT1 <= '1'; r_BIT2 <= '1';
        wait for 10 ns;
    end process;

end behave;