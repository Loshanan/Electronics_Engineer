library ieee;
use ieee.std_logic_1164.all;

entity binary_to_bcd_tb is 
end entity;

architecture behave of binary_to_bcd_tb is

    constant c_INPUT_WIDTH    : integer := 8;
    constant c_DECIMAL_DIGITS : integer := 3;

    signal r_CLK    : std_logic := '0';
    signal r_START  : std_logic := '0';
    signal r_BINARY : std_logic_vector(c_INPUT_WIDTH - 1 downto 0) := (others => '0');

    signal w_BCD    : std_logic_vector(c_DECIMAL_DIGITS*4 - 1 downto 0) := (others => '0');
    signal w_DV     : std_logic;

    component binary_to_bcd is
        generic (
            g_INPUT_WIDTH    : natural;
            g_DECIMAL_DIGITS : natural
        );
        port (
            i_clk    : in  std_logic;
            i_start  : in  std_logic;
            i_binary : in  std_logic_vector (g_INPUT_WIDTH - 1 downto 0);  
            --
            o_bcd    : out std_logic_vector (g_DECIMAL_DIGITS*4 - 1 downto 0);
            o_DV     : out std_logic   
        );
    end component binary_to_bcd;

begin

    UUT : binary_to_bcd
    generic map (
        g_INPUT_WIDTH => c_INPUT_WIDTH,
        g_DECIMAL_DIGITS => c_DECIMAL_DIGITS
    )
    port map (
        i_clk    => r_CLK,
        i_start  => r_START,
        i_binary => r_BINARY,
        o_bcd    => w_BCD,
        o_DV     => w_DV 
    );

    r_CLK <= not r_CLK after 10 ns;

    p_BIN_TO_BCD : process is
    begin
        wait until rising_edge(r_CLK);
        r_BINARY <= X"ff";  -- 255
        wait until rising_edge(r_CLK);
        r_START  <= '1';
        wait until rising_edge(r_CLK);
        r_START  <= '0';
        wait until w_DV = '1';
        wait until rising_edge(r_CLK);
        wait until rising_edge(r_CLK);
        wait until rising_edge(r_CLK);

        r_BINARY <= "01111011";  -- 123
        -- r_BINARY <= "01010001";  -- 81
        wait until rising_edge(r_CLK);
        r_START  <= '1';
        wait until rising_edge(r_CLK);
        r_START  <= '0';
        wait until w_DV = '1';
        wait until rising_edge(r_CLK);
        wait until rising_edge(r_CLK);
        wait;
        
    end process p_BIN_TO_BCD;
end behave;