library ieee;
use ieee.std_logic_1164.all;

entity carry_lookahead_adder_tb is
end entity;

architecture behave of carry_lookahead_adder_tb is
    constant c_WIDTH : natural := 4;
    
    signal r_TERM1  : std_logic_vector(c_WIDTH - 1 downto 0) := (others => '0');
    signal r_TERM2  : std_logic_vector(c_WIDTH - 1 downto 0) := (others => '0');
    signal w_result : std_logic_vector(c_WIDTH downto 0);

    component carry_lookahead_adder is
        generic (
            g_WIDTH : natural
        );
        port (
            i_term1  : in  std_logic_vector(g_WIDTH - 1 downto 0);
            i_term2  : in  std_logic_vector(g_WIDTH - 1 downto 0);
            --
            o_result : out std_logic_vector(g_WIDTH downto 0)        
        );
    end component;
begin
    UUT : carry_lookahead_adder
    generic map (
        g_WIDTH => c_WIDTH
    )
    port map (
        i_term1  => r_TERM1,
        i_term2  => r_TERM2,
        o_result => w_result
    ); 

    process is 
    begin
        r_TERM1 <= "0101";
        r_TERM2 <= "1010";
        wait for 10 ns;
        -- assert w_result = "01111" report "wrong output" severity failure;
        r_TERM1 <= "1100";
        r_TERM2 <= "1110";
        wait for 10 ns;
        r_TERM1 <= "0111";
        r_TERM2 <= "0000";
        wait for 10 ns;
        r_TERM1 <= "1111";
        r_TERM2 <= "1111";
        wait for 10 ns;
        wait;        
    end process;

end behave;