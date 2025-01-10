library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_Blink is
    port (
        i_clock     : in std_logic;
        i_enable    : in std_logic;
        i_switch_1  : in std_logic;
        i_switch_2  : in std_logic;
        o_led_drive : out std_logic
    );
end LED_Blink;

architecture rtl of LED_Blink is

    constant c_CNT_100Hz : natural :=    125_000;
    constant c_CNT_50Hz  : natural :=    250_000;
    constant c_CNT_10Hz  : natural :=  1_250_000;
    constant c_CNT_1Hz   : natural := 12_500_000;
    
    -- signals to store the count
    signal r_CNT_100Hz   : natural range 0 to c_CNT_100Hz;
    signal r_CNT_50Hz    : natural range 0 to c_CNT_50Hz;
    signal r_CNT_10Hz    : natural range 0 to c_CNT_10Hz;
    signal r_CNT_1Hz     : natural range 0 to c_CNT_1Hz;

    -- signals to crete clock signals
    signal r_TOGGLE_100Hz :std_logic := '0';
    signal r_TOGGLE_50Hz  :std_logic := '0';
    signal r_TOGGLE_10Hz  :std_logic := '0';
    signal r_TOGGLE_1Hz   :std_logic := '0';
    
    -- frequency select wire
    signal w_LED_SELECT : std_logic;
    
begin

    p_100Hz : process (i_clock) is 
    begin
        if rising_edge(i_clock) then
            if r_CNT_100Hz = c_CNT_100Hz - 1 then
                r_TOGGLE_100Hz <= not r_TOGGLE_100Hz;
                r_CNT_100Hz    <= 0;
            else
                r_CNT_100Hz <= r_CNT_100Hz + 1;
            end if;
        end if;
    end process p_100Hz;

    p_50Hz : process (i_clock) is
    begin
        if rising_edge(i_clock) then
            if r_CNT_50Hz = c_CNT_50Hz - 1 then
                r_TOGGLE_50Hz <= not r_TOGGLE_50Hz;
                r_CNT_50Hz    <= 0;
            else
                r_CNT_50Hz <= r_CNT_50Hz + 1;
            end if;
        end if;
    end process p_50Hz;

    p_10Hz : process (i_clock) is
    begin
        if rising_edge(i_clock) then
            if r_CNT_10Hz = c_CNT_10Hz - 1 then
                r_TOGGLE_10Hz <= not r_TOGGLE_10Hz;
                r_CNT_10Hz    <= 0;
            else
                r_CNT_10Hz <= r_CNT_10Hz + 1;
            end if;
        end if;
    end process p_10Hz;

    p_1Hz : process (i_clock) is
    begin
        if rising_edge(i_clock) then
            if r_CNT_1Hz = c_CNT_1Hz - 1 then
                r_TOGGLE_1Hz <= not r_TOGGLE_1Hz;
                r_CNT_1Hz    <= 0;
            else
                r_CNT_1Hz <= r_CNT_1Hz + 1;
            end if;
        end if;
    end process p_1Hz;

    -- creating mux
    w_LED_SELECT <= r_TOGGLE_100Hz when (i_switch_1 = '0' and i_switch_2 = '0') else
                    r_TOGGLE_50Hz  when (i_switch_1 = '0' and i_switch_2 = '1') else
                    r_TOGGLE_10Hz  when (i_switch_1 = '1' and i_switch_2 = '0') else
                    r_TOGGLE_1Hz;

    -- final output if only enable
    o_led_drive <= w_LED_SELECT and i_enable;

end rtl;