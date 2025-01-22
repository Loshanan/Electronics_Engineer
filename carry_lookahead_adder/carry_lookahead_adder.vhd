library ieee;
use ieee.std_logic_1164.all;

entity carry_lookahead_adder is
    generic (
        g_WIDTH : natural := 4
    );
    port (
        i_term1  : in  std_logic_vector(g_WIDTH - 1 downto 0);
        i_term2  : in  std_logic_vector(g_WIDTH - 1 downto 0);
        --
        o_result : out std_logic_vector(g_WIDTH downto 0)        
    );
end entity;

architecture rtl of carry_lookahead_adder is
    
    signal w_carry : std_logic_vector(g_WIDTH downto 0);
    signal w_sum   : std_logic_vector(g_WIDTH - 1 downto 0);

    component full_adder is
        port(
            i_bit1 : in  std_logic;
            i_bit2 : in  std_logic;
            i_cin  : in  std_logic;
    
            o_sum  : out std_logic;
            o_cout : out std_logic
        );

    end component full_adder;

    component carry_lookahead is
        generic (
            g_WIDTH : natural
        );
        port (
            i_term1 : in  std_logic_vector(g_WIDTH - 1 downto 0);
            i_term2 : in  std_logic_vector(g_WIDTH - 1 downto 0);
            i_carry : in  std_logic;
            --
            o_carry : out std_logic_vector(g_WIDTH - 1 downto 0)
        );
    end component carry_lookahead;

begin

    w_carry(0) <= '0';
    carry_lookahead_INST : carry_lookahead
    generic map (
        g_WIDTH => g_WIDTH
    )
    port map (
        i_term1 => i_term1,
        i_term2 => i_term2,
        i_carry => w_carry(0),
        o_carry => w_carry(g_WIDTH downto 1)
    );

    ADDERS : for ii in 0 to g_WIDTH - 1 generate
        full_adder_INST : full_adder
        port map(
            i_bit1 => i_term1(ii),
            i_bit2 => i_term2(ii),
            i_cin  => w_carry(ii),
            o_sum  => w_sum(ii),
            o_cout => open
        );
    end generate;

    o_result <= w_carry(g_WIDTH) & w_sum;
end rtl;