library ieee;
use ieee.std_logic_1164.all;

entity LED_Blink_tb is
end LED_Blink_tb;

architecture behave of LED_Blink_tb is

    -- 25 MHz = 40ns
    constant c_CLK_PERIOD : time := 40 ns;

    -- inputs
    signal r_CLOCK     : std_logic := '0';
    signal r_ENABLE    : std_logic := '0';
    signal r_SWITCH_1  : std_logic := '0';
    signal r_SWITCH_2  : std_logic := '0';

    -- output
    signal w_LED_DRIVE : std_logic;

    -- component declaration
    component LED_Blink is
        port (
            i_clock     : in std_logic;
            i_enable    : in std_logic;
            i_switch_1  : in std_logic;
            i_switch_2  : in std_logic;
            o_led_drive : out std_logic
        );
    end component LED_Blink;
       
begin
    
    -- Instantiate the Unit Under Test (UUT)
    UUT : LED_Blink 
    port map (
        i_clock     => r_CLOCK,
        i_enable    => r_ENABLE,
        i_switch_1  => r_SWITCH_1,
        i_switch_2  => r_SWITCH_2,
        o_led_drive => w_LED_DRIVE
    );

    -- Clock generation
    p_CLK_GEN : process is 
    begin
        wait for c_CLK_PERIOD/2;
        r_CLOCK <= not r_CLOCK;
    end process p_CLK_GEN;

    -- main testing
    process
    begin
        r_ENABLE <= '1';
        r_SWITCH_1 <= '0';
        r_SWITCH_2 <= '0';
        wait for 0.1 sec;

        r_SWITCH_1 <= '0';
        r_SWITCH_2 <= '1';
        wait for 0.2 sec;

        r_SWITCH_1 <= '1';
        r_SWITCH_2 <= '0';
        wait for 1 sec;

        r_SWITCH_1 <= '1';
        r_SWITCH_2 <= '1';
        wait for 2 sec;

    end process;

end behave;