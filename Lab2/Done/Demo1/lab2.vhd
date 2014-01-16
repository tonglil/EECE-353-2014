
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lab2 is
	port(key : in std_logic_vector(3 downto 0);  -- pushbutton switches
            sw : in std_logic_vector(8 downto 0);  -- slide switches
            ledg : out std_logic_vector(7 downto 0);
            lcd_rw : out std_logic;
            lcd_en : out std_logic;
            lcd_rs : out std_logic;
            lcd_on : out std_logic;
            lcd_blon : out std_logic;
            lcd_data : out std_logic_vector(7 downto 0);
            hex0 : out std_logic_vector(6 downto 0));  -- one of the 7-segment diplays
end lab2 ;


architecture behavioural of lab2 is
begin

      -- These will not change

        lcd_blon <= '1';
        lcd_on <= '1';
        lcd_en <= key(0);
        lcd_rw <= '0';

      -- Your code goes here
      -- Hint: for task 2, I did it as a single process structured as
      -- a Moore state machine.  See Slide Set 2 for some inspiration. 
 
end behavioural;

