library ieee;
use ieee.std_logic_1164.all;

entity ra_adder_tb is
end entity;

architecture behave of ra_adder_tb is
    constant c_WIDTH : integer := 4;
    
    signal r_TERM1 : std_logic_vector (c_WIDTH - 1 downto 0);
    signal r_TERM2 : std_logic_vector (c_WIDTH - 1 downto 0);
    signal w_SUM   : std_logic_vector (c_WIDTH downto 0);

    component ra_adder is
        generic (
            g_WIDTH : integer
        );
        port (
            i_term1 : in  std_logic_vector (g_WIDTH - 1 downto 0);      
            i_term2 : in  std_logic_vector (g_WIDTH - 1 downto 0);      
            
            o_sum   : out std_logic_vector (g_WIDTH downto 0)
        );
    end component;

begin

    UUT : ra_adder
    generic map (
        g_WIDTH => c_WIDTH
    )
    port map (
        i_term1 => r_TERM1,
        i_term2 => r_TERM2,
        o_sum   => w_SUM
    );

    process is 
    begin
        r_TERM1 <= X"2";
        r_TERM2 <= X"D";
        wait for 10 ns;
        r_TERM1 <= X"3";
        r_TERM2 <= X"5";
        wait for 10 ns;        
    end process;
end behave;