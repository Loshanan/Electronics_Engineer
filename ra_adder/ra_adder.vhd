library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ra_adder is
    generic (
        g_WIDTH : natural := 4
    );
    port (
        i_term1 : in  std_logic_vector (g_WIDTH - 1 downto 0);      
        i_term2 : in  std_logic_vector (g_WIDTH - 1 downto 0);      
        
        o_total   : out std_logic_vector (g_WIDTH downto 0)   -- this includes the carry bit
    );
end ra_adder;

architecture rtl of ra_adder is 
    signal w_carry : std_logic_vector (g_WIDTH downto 0);
    signal w_SUM   : std_logic_vector (g_WIDTH - 1 downto 0);
    

    component full_adder is
        port(
            i_bit1 : in  std_logic;
            i_bit2 : in  std_logic;
            i_cin  : in  std_logic;
    
            o_sum  : out std_logic;
            o_cout : out std_logic
        );
    end component full_adder;

begin

    w_carry(0) <= '0';
    ADDERS : for ii in 0 to g_WIDTH - 1 generate
        full_adder_inst : full_adder 
        port map (
            i_bit1 => i_term1(ii),
            i_bit2 => i_term2(ii),
            i_cin  => w_carry(ii),
            o_cout => w_carry(ii + 1),
            o_sum  => w_SUM(ii)  
        );
    end generate ADDERS;

    o_total <= w_carry(g_WIDTH) & w_SUM;

end rtl;