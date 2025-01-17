library ieee;
use ieee.std_logic_1164.all;

entity full_adder_tb is 
end full_adder_tb;

architecture behave of full_adder_tb is
    signal r_BIT1 : std_logic := '0';
    signal r_BIT2 : std_logic := '0';
    signal r_CIN  : std_logic := '0';
    
    signal w_COUT : std_logic;
    signal w_SUM  : std_logic;

    component full_adder is 
        port (
            i_bit1 : in  std_logic;
            i_bit2 : in  std_logic;
            i_cin  : in  std_logic;
    
            o_sum  : out std_logic;
            o_cout : out std_logic
        );
    end component full_adder;

begin
    UUT : full_adder
    port map (
        i_bit1 => r_BIT1,
        i_bit2 => r_BIT2,
        i_cin  => r_CIN,
        o_sum  => w_SUM,
        o_cout => w_COUT
    );

    process is 
    begin
        r_BIT1 <= '0'; r_BIT2 <= '0'; r_CIN <= '0';
        wait for 10 ns;
        r_BIT1 <= '0'; r_BIT2 <= '1'; r_CIN <= '0';
        wait for 10 ns;
        r_BIT1 <= '1'; r_BIT2 <= '0'; r_CIN <= '0';
        wait for 10 ns;
        r_BIT1 <= '1'; r_BIT2 <= '1'; r_CIN <= '0';
        wait for 10 ns;
        
        r_BIT1 <= '0'; r_BIT2 <= '0'; r_CIN <= '1';
        wait for 10 ns;
        r_BIT1 <= '0'; r_BIT2 <= '1'; r_CIN <= '1';
        wait for 10 ns;
        r_BIT1 <= '1'; r_BIT2 <= '0'; r_CIN <= '1';
        wait for 10 ns;
        r_BIT1 <= '1'; r_BIT2 <= '1'; r_CIN <= '1';
        wait for 10 ns;
        
    end process;
end behave;