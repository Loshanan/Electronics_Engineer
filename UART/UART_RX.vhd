library ieee;
use ieee.std_logic_1164.all;

entity UART_RX is 
    generic (
        g_CLK_PER_BIT : integer := 87 -- 10 MHz and 115200 Baud rate
    );
    port (
        i_clk       : in std_logic;
        i_RX_serial : in std_logic;
        --
        o_RX_DV     : out std_logic;    -- data valid
        o_RX_byte   : out std_logic_vector (7 downto 0)
    );
end entity;

architecture rtl of UART_RX is

    signal r_RX_serial      : std_logic := '0';
    signal r_RX_serial_sync : std_logic := '0'; 

    signal r_bit_index      : integer range 0 to 7             := 0;
    signal r_clk_count      : integer range 0 to g_CLK_PER_BIT := 0;

    signal r_RX_DV          : std_logic := '0';
    signal r_RX_byte        : std_logic_vector (7 downto 0) := (others => '0');

    type t_SM_main is (s_IDLE, s_RX_START, s_RX_DATA, s_RX_STOP, s_RX_CLEAN);
    signal r_SM_main : t_SM_main := s_IDLE;

begin

    p_SAMPLE : process (i_clk) is
    begin
        if rising_edge(i_clk) then
            r_RX_serial_sync <= i_RX_serial;
            r_RX_serial      <= r_RX_serial_sync;
        end if;
    end process p_SAMPLE;

    p_UART_RX : process (i_clk) is
    begin
        if rising_edge(i_clk) then
            case r_SM_main is
                when s_IDLE =>
                    r_bit_index <= 0;
                    r_clk_count <= 0;
                    r_RX_DV     <= '0';
                    if (r_RX_serial = '0') then
                        r_SM_main <= s_RX_START;
                    else
                        r_SM_main <= s_IDLE;
                    end if;

                when s_RX_START =>
                    if (r_clk_count = (g_CLK_PER_BIT-1)/2) then
                        if (r_RX_serial = '0') then
                            r_clk_count <= 0;
                            r_bit_index <= 0;
                            r_SM_main   <= s_RX_DATA;
                        else
                            r_clk_count <= 0;
                            r_SM_main   <= s_IDLE;
                        end if;
                    else 
                        r_clk_count <= r_clk_count + 1;
                        r_SM_main   <= s_RX_START;
                    end if;

                when s_RX_DATA =>
                    if(r_clk_count = g_CLK_PER_BIT - 1) then
                        r_RX_byte(r_bit_index) <= r_RX_serial;
                        r_clk_count <= 0;
                        if (r_bit_index < 7) then
                            r_bit_index <= r_bit_index + 1;
                            r_SM_main   <= s_RX_DATA;
                        else
                            r_bit_index <= 0;
                            r_SM_main   <= s_RX_STOP;
                        end if;
                    else
                        r_clk_count <= r_clk_count + 1;
                        r_SM_main   <= s_RX_DATA;
                    end if;

                when s_RX_STOP =>
                    if (r_clk_count = g_CLK_PER_BIT - 1) then
                        r_RX_DV     <= '1';
                        r_clk_count <= 0;
                        r_SM_main   <= s_RX_CLEAN;
                    else
                        r_clk_count <= r_clk_count + 1;
                        r_SM_main   <= s_RX_STOP;
                    end if;

                when s_RX_CLEAN =>
                    r_RX_DV   <= '0';
                    r_SM_main <= s_IDLE;

                when others =>
                    r_SM_main <= s_IDLE;

            end case;
        end if;
    end process p_UART_RX;

    o_RX_byte <= r_RX_byte;
    o_RX_DV   <= r_RX_DV;

end rtl;