library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ra_adder_tb is
end entity;

architecture behave of ra_adder_tb is
    constant c_WIDTH : integer := 4;
    
    signal r_ADD1  : std_logic_vector (c_WIDTH - 1 downto 0) := (others => '0');
    signal r_ADD2  : std_logic_vector (c_WIDTH - 1 downto 0) := (others => '0');
    signal w_RESULT: std_logic_vector (c_WIDTH downto 0);

    component ra_adder is
        generic (
            g_WIDTH : natural
        );
        port (
            i_term1 : in  std_logic_vector (g_WIDTH - 1 downto 0);      
            i_term2 : in  std_logic_vector (g_WIDTH - 1 downto 0);      
            
            o_total : out std_logic_vector (g_WIDTH downto 0)
        );
    end component ra_adder;

begin

    UUT : ra_adder
    generic map (
        g_WIDTH => c_WIDTH
    )
    port map (
        i_term1 => r_ADD1,
        i_term2 => r_ADD2,
        o_total => w_RESULT
    );

    process is 
    begin
        r_ADD1 <= "0010";
        r_ADD2 <= "1101";
        wait for 10 ns;
        r_ADD1 <= "0011";
        r_ADD2 <= "1001";
        wait for 10 ns;  
        r_ADD1 <= "1111";
        r_ADD2 <= "1111";
        wait for 10 ns;  
        wait;    
    end process;
end behave;