library ieee;
use ieee.std_logic_1164.all;

entity fifo_tb is
end entity fifo_tb;

architecture behave of fifo_tb is

    constant c_WIDTH : integer := 8;
    constant c_DEPTH : integer := 32;

    signal r_WRITE_EN   : std_logic := '0';
    signal r_WRITE_DATA : std_logic_vector(c_WIDTH - 1 downto 0) := x"ae";
    signal r_READ_EN    : std_logic := '0';

    signal r_CLK        : std_logic := '0';
    signal r_RST        : std_logic := '0';

    signal w_READ_DATA  : std_logic_vector (c_WIDTH - 1 downto 0);

    signal w_FIFO_FULL   : std_logic;
    signal w_FIFO_empty  : std_logic;

    component fifo is 
        generic (
            g_WIDTH : natural := 8;
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
    end component fifo;
    
begin 

    UUT : fifo
    generic map (
        g_WIDTH => c_WIDTH,
        g_DEPTH => c_DEPTH
    )
    port map (
        i_clk        => r_CLK,
        i_rst        => r_RST,
        --
        i_write_en   => r_WRITE_EN,
        i_write_data => r_WRITE_DATA,
        o_fifo_full  => w_FIFO_FULL,
        --
        i_read_en    => r_READ_EN,
        o_read_data  => w_READ_DATA,
        o_fifo_empty => w_FIFO_empty
    );

    r_CLK <= not r_CLK after 5 ns;

    p_TEST : process is 
    begin
        wait until r_CLK = '1';
        r_WRITE_EN <= '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        r_WRITE_EN <= '0';
        r_READ_EN <= '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        r_WRITE_EN <= '1';
        r_READ_EN  <= '0';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        r_READ_EN <= '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        r_WRITE_EN <= '0';
        wait until r_CLK = '1';
        wait until r_CLK = '1';
        -- wait until r_CLK = '1';
        -- wait until r_CLK = '1';
        
        
    end process p_TEST;

end behave;