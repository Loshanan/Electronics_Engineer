library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_to_bcd is
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
end entity;

architecture rtl of binary_to_bcd is

    type t_SM_main is (s_IDLE, s_SHIFT, s_CHECK_SHIFT_DONE, s_ADD, s_CHECK_DIGIT_INDEX, s_DONE, s_CLEAN);
    
    signal r_sm_main     : t_SM_main := s_IDLE;

    signal r_loop_count  : natural range 0 to g_INPUT_WIDTH  := 0;

    signal r_digit_index : natural range 0 to g_DECIMAL_DIGITS := 0;

    signal r_bcd         : std_logic_vector (g_DECIMAL_DIGITS*4 - 1 downto 0) := (others => '0');

    signal r_binary      : std_logic_vector (g_INPUT_WIDTH - 1 downto 0) := (others => '0');

begin

    p_STATE_MACHINE : process (i_clk) is
        variable v_upper : integer := 0;
        variable v_lower : integer := 0;
        variable v_vec   : unsigned (3 downto 0);
    begin
        if rising_edge(i_clk) then
            case r_sm_main is
                when s_IDLE =>
                    if  (i_start = '1') then
                        r_binary      <= i_binary;
                        r_loop_count  <= 0;
                        r_digit_index <= 0;
                        r_sm_main     <= s_SHIFT;
                    else 
                        r_sm_main     <= s_IDLE;
                    end if;

                when s_SHIFT =>
                    r_bcd        <= r_bcd(r_bcd'left - 1 downto 0) & r_binary(r_binary'left);
                    r_binary     <= r_binary(r_binary'left - 1 downto 0) & '0';
                    r_loop_count <= r_loop_count + 1;
                    r_sm_main    <= s_CHECK_SHIFT_DONE;

                when s_CHECK_SHIFT_DONE =>
                    if (r_loop_count = g_INPUT_WIDTH) then
                        r_loop_count <= 0;
                        r_sm_main <= s_DONE;
                    else
                        r_sm_main <= s_ADD;
                    end if;

                when s_ADD =>
                    v_lower := r_digit_index * 4;
                    v_upper := r_digit_index * 4 + 3; 
                    v_vec   := unsigned(r_bcd(v_upper downto v_lower));
                    if (v_vec > 4) then 
                        r_bcd(v_upper downto v_lower) <= std_logic_vector(v_vec + 3);
                    end if; 
                    r_sm_main     <= s_CHECK_DIGIT_INDEX;                   
                
                when s_CHECK_DIGIT_INDEX =>
                    if (r_digit_index = g_DECIMAL_DIGITS - 1) then 
                        r_digit_index <= 0;
                        r_sm_main     <= s_SHIFT;
                    else 
                        r_digit_index <= r_digit_index + 1;
                        r_sm_main     <= s_ADD;
                    end if;
                    
                when s_DONE =>
                    r_sm_main <= s_CLEAN;

                when s_CLEAN =>
                    r_bcd     <= (others => '0');
                    r_sm_main <= s_IDLE;
                
                when others => 
                    r_sm_main    <= s_IDLE;
            end case;
        end if;
    end process p_STATE_MACHINE;

    o_bcd <= r_bcd;
    o_DV  <= '1' when r_sm_main = s_DONE else '0';

end rtl;