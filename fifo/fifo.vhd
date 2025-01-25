library ieee;
use ieee.std_logic_1164.all;

entity fifo is
    generic (
        g_WIDTH : integer := 8;
        g_DEPTH : natural := 32
    );
    port(
        i_clk        : in  std_logic;
        i_rst        : in  std_logic;
        --
        i_write_en   : in  std_logic;
        i_write_data : in  std_logic_vector (g_WIDTH - 1 downto 0);
        o_fifo_full  : out std_logic;
        --
        i_read_en    : in  std_logic;
        o_read_data  : out std_logic_vector (g_WIDTH - 1 downto 0);
        o_fifo_empty : out std_logic
    );
end entity fifo;

architecture rtl of fifo is 

    type t_fifo_memory is array (0 to g_DEPTH - 1) of std_logic_vector(g_WIDTH - 1 downto 0);
    signal r_fifo_data   : t_fifo_memory := (others => (others => '0'));

    signal r_write_index : integer     := 0;
    signal r_read_index  : integer     := 0;

    signal r_fifo_count  : integer       :=  0;

    signal w_fifo_full   : std_logic;
    signal w_fifo_empty  : std_logic;

begin
    
    p_CONTROL : process (i_clk) is 
    begin
        if rising_edge(i_clk) then
            -- reset 
            if (i_rst = '1') then
                r_fifo_count  <= 0;
                r_write_index <= 0;
                r_read_index  <= 0;
            end if;

            -- writing r_write_index register
            if (i_write_en = '1') then
                if (r_write_index = g_DEPTH - 1) then
                    r_write_index <= 0;
                else 
                    r_write_index <= r_write_index + 1;
                end if;
            end if;

            -- writing r_read_index register
            if (i_read_en = '1') then
                if (r_read_index = g_DEPTH - 1) then
                    r_read_index <= 0;
                else
                    r_read_index <= r_read_index + 1;
                end if;
            end if;

            -- writing r_fifo_count register
            if (i_write_en = '1' and i_read_en = '0') then
                r_fifo_count <= r_fifo_count + 1;
            elsif (i_read_en = '1' and i_write_en = '0') then
                r_fifo_count <= r_fifo_count - 1;
            end if;

            -- writing data
            if (i_write_en = '1') then
                r_fifo_data(r_write_index) <= i_write_data;
            end if;

        end if;
    end process p_CONTROL;

    w_fifo_full  <= '1' when r_fifo_count = g_DEPTH else '0';
    w_fifo_empty <= '1' when r_fifo_count = 0     else '0';

    o_read_data  <= r_fifo_data(r_read_index);

    o_fifo_full <= w_fifo_full;
    o_fifo_empty <= w_fifo_empty;

    p_ASSERT : process (i_clk) is 
    begin
        if rising_edge(i_clk) then
            if (i_write_en = '1' and w_fifo_full = '1') then
                report "ASSERT FAILURE - MODULE IS FULL AND BEING WRITTEN" severity failure;
            end if;
            if (i_read_en = '1' and w_fifo_empty = '1') then
                report "ASSERT FAILURE - MODULE IS EMPTY AND BEING READ" severity failure;
            end if;
        end if;
    end process p_ASSERT;

end architecture rtl;