library ieee;
use ieee.std_logic_1164.all;

entity UART_tb is
end entity;

architecture behave of UART_tb is
    component UART_TX is
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
    end component UART_TX;

    component UART_RX is 
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
    end component UART_RX;

    constant c_CLK_PER_BIT : integer := 87;
    constant c_BIT_PERIOD : time := 8680 ns;

    signal r_CLOCK     : std_logic := '0';
    signal r_TX_DV     : std_logic := '0';
    signal r_TX_byte   : std_logic_vector (7 downto 0) := (others => '0');
    signal w_TX_serial : std_logic;
    signal w_TX_done   : std_logic;
    signal w_RX_DV     : std_logic;
    signal w_RX_byte   : std_logic_vector(7 downto 0);
    signal r_RX_serial : std_logic := '1';

    procedure UART_WRITE_WIRE (
        i_data_in : in std_logic_vector(7 downto 0);
        signal o_serial : out std_logic
    ) is
    begin
        o_serial <= '0';
        wait for c_BIT_PERIOD;

        for ii in 0 to 7 loop
            o_serial <= i_data_in(ii);
            wait for c_BIT_PERIOD;
        end loop;

        o_serial <= '1';
        wait for c_BIT_PERIOD;

    end UART_WRITE_WIRE;
    
begin

    UART_TX_INST : UART_TX
    generic map (
        g_CLK_PER_BIT => c_CLK_PER_BIT
    ) 
    port map (
        i_clk => r_CLOCK,
        i_TX_byte => r_TX_byte,
        i_TX_DV => r_TX_DV,
        o_TX_active => open,
        o_TX_serial => w_TX_serial,
        o_TX_done => w_TX_done
    );

    UART_RX_INST :UART_RX 
    generic map (
        g_CLK_PER_BIT => c_CLK_PER_BIT
    )
    port map (
        i_clk => r_CLOCK,
        i_RX_serial => r_RX_serial,
        o_RX_byte => w_RX_byte,
        o_RX_DV => w_RX_DV
    );

    r_CLOCK <= not r_CLOCK after 50 ns;

    process is 
    begin
        wait until rising_edge(r_CLOCK);
        wait until rising_edge(r_CLOCK);
        r_TX_DV <= '1';
        r_TX_byte <= X"AE";
        wait until rising_edge(r_CLOCK);
        r_TX_DV <= '0';
        wait until w_TX_done = '1';


        wait until rising_edge(r_CLOCK);
        UART_WRITE_WIRE(X"3F", r_RX_serial);
        wait until rising_edge(r_CLOCK);

        if (w_RX_byte = X"3F") then 
            report "Test Fassed - correct byte received" severity note;
        else
            report "Test Failed - incorrect bte received" severity note;
        end if;

        wait;
    end process;
end behave;