library ieee;
use ieee.std_logic_1164.all;

entity carry_lookahead is
    generic (
        g_WIDTH : natural := 4
    );
    port (
        i_term1 : in  std_logic_vector(g_WIDTH - 1 downto 0);
        i_term2 : in  std_logic_vector(g_WIDTH - 1 downto 0);
        i_carry : in  std_logic;
        --
        o_carry : out std_logic_vector(g_WIDTH - 1 downto 0)
    );
end entity;

architecture rtl of carry_lookahead is
    signal w_cg : std_logic_vector(g_WIDTH - 1 downto 0);   -- carry generation
    signal w_cp : std_logic_vector(g_WIDTH - 1 downto 0);   -- carry propagation
    signal w_c  : std_logic_vector(g_WIDTH downto 0);       -- carry wires
begin

    w_c(0) <= i_carry;

    CARRY_GEN : for ii in 0 to g_WIDTH - 1 generate
        w_cg(ii)    <= i_term1(ii) and i_term2(ii);
        w_cp(ii)    <= i_term1(ii) xor i_term2(ii);
        w_c(ii + 1) <= w_cg(ii) or (w_cp(ii) and w_c(ii));
    end generate CARRY_GEN;

    o_carry <= w_c(g_WIDTH downto 1); 

end architecture;