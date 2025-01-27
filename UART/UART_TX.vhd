library ieee;
use ieee.std_logic_1164.all;

entity UART_TX is
    generic (
        g_CLK_PER_BIT : integer := 87
    );
    port (
        i_clk       : in  std_logic;
        --
        i_TX_byte   : in  std_logic_vector (7 downto 0);
        i_TX_DV     : in  std_logic;
        --
        o_TX_active : out std_logic;
        o_TX_serial : out std_logic;
        o_TX_done   : out std_logic

    );
end entity;

architecture rtl of UART_TX is

    type t_SM_main is (s_IDLE, s_TX_START, s_TX_DATA, s_TX_STOP, s_TX_CLEAN);
    signal r_SM_main : t_SM_main := s_IDLE;

    signal r_clk_count : integer range 0 to g_CLK_PER_BIT - 1 := 0;
    signal r_bit_index : integer range 0 to 7 := 0;

    signal r_TX_active : std_logic := '0';
    signal r_TX_serial : std_logic := '1';
    signal r_TX_done   : std_logic := '0';

    signal r_TX_byte   : std_logic_vector (7 downto 0);
begin 

    p_UART_TX : process (i_clk) is 
    begin
        if rising_edge(i_clk) then 
            case r_SM_main is 
                when s_IDLE =>
                    r_clk_count <= 0;
                    r_bit_index <= 0;
                    r_TX_active <= '0';
                    r_TX_serial <= '1';
                    r_TX_done   <= '0';
                    if (i_TX_DV = '1') then
                        r_TX_byte   <= i_TX_byte;
                        r_SM_main   <= s_TX_start;
                    else
                        r_SM_main   <= s_IDLE;
                    end if;

                when s_TX_START =>
                    r_TX_active <= '1';
                    r_TX_serial <= '0';
                    if (r_clk_count = g_CLK_PER_BIT - 1) then
                        r_clk_count <= 0;
                        r_SM_main   <= s_TX_DATA;
                    else
                        r_clk_count <= r_clk_count + 1;
                        r_SM_main   <= s_TX_START;
                    end if;

                when s_TX_DATA =>
                    r_TX_serial <= r_TX_byte(r_bit_index);
                    if (r_clk_count = g_CLK_PER_BIT - 1) then
                        r_clk_count <= 0;
                        if (r_bit_index = 7) then
                            r_bit_index <= 0;
                            r_SM_main   <= s_TX_STOP;
                        else
                            r_bit_index <= r_bit_index + 1;
                            r_SM_main   <= s_TX_DATA;
                        end if;
                    else
                        r_clk_count <= r_clk_count + 1;
                        r_SM_main   <= s_TX_DATA;
                    end if;

                when s_TX_STOP =>
                    r_TX_serial <= '1';
                    if (r_clk_count = g_CLK_PER_BIT - 1) then
                        r_clk_count <= 0;
                        r_TX_done   <= '1';
                        r_SM_main   <= s_TX_CLEAN;
                    else
                        r_clk_count <= r_clk_count + 1;
                        r_SM_main <= s_TX_STOP;
                    end if;

                when s_TX_CLEAN =>
                    r_TX_active <= '0';
                    r_TX_done   <= '1';

                    r_SM_main <= s_IDLE;
                    
                when others =>
                    r_SM_main <= s_IDLE;
            end case;
        end if;

    end process p_UART_TX;

    o_TX_active <= r_TX_active;
    o_TX_done   <= r_TX_done;
    O_TX_serial <= r_TX_serial;
end rtl;