
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lab2 is
	port(key : in std_logic_vector(0 downto 0);  -- pushbutton switches
            sw : in std_logic_vector(8 downto 0);  -- slide switches
            lcd_rw : out std_logic;
            lcd_en : out std_logic;
            lcd_rs : out std_logic;
            lcd_on : out std_logic;
            lcd_blon : out std_logic;
            lcd_data : out std_logic_vector(7 downto 0);
				ledg : out std_logic_vector(5 downto 0);
				CLOCK_50 : in std_logic );  -- one of the 7-segment diplays
end lab2 ;


architecture behavioural of lab2 is
	TYPE state_types is (r0, r1, r2, r3, r4, r5, c1, c2, c3, c4, c5, m0, m1, m2);
	SIGNAL STATE : state_types := r0;
	SIGNAL cnt : std_logic_vector (24 downto 0) := (others => '0');
	SIGNAL line_cnt : std_logic_vector (5 downto 0) := (others => '0');
begin
	lcd_blon <= '1';
	lcd_on <= '1';
	lcd_en <= cnt(24);
	lcd_rw <= '0';
	
	ledg <= line_cnt;

	PROCESS(CLOCK_50)
	BEGIN
		IF rising_edge(CLOCK_50) THEN
			cnt <= cnt + '1';
		END IF;
	END PROCESS;
	
	PROCESS(KEY, cnt, line_cnt)
	variable SAVED_STATE : state_types;
	BEGIN
		IF (key(0) = '0') THEN
			STATE <= r0;
			line_cnt <= (others => '0');
		ELSIF (rising_edge(cnt(24))) THEN
			CASE STATE IS
				WHEN r0 => STATE <= r1;
				WHEN r1 => STATE <= r2;
				WHEN r2 => STATE <= r3;
				WHEN r3 => STATE <= r4;
				WHEN r4 => STATE <= r5;
				WHEN r5 => 
					STATE <= c1;
					SAVED_STATE := c1;
					line_cnt <= line_cnt + '1';
				WHEN c1 => 
					IF SW(0) = '0' THEN
						STATE <= c2;
						SAVED_STATE := c2;
					ELSE
						STATE <= c5;
						SAVED_STATE := c5;
					END IF;
					line_cnt <= line_cnt + '1';
				WHEN c2 => 
					IF SW(0) = '0' THEN
						STATE <= c3;
						SAVED_STATE := c3;
					ELSE
						STATE <= c1;
						SAVED_STATE := c1;
					END IF;
					line_cnt <= line_cnt + '1';
				WHEN c3 => 
					IF SW(0) = '0' THEN
						STATE <= c4;
						SAVED_STATE := c4;
					ELSE
						STATE <= c2;
						SAVED_STATE := c2;
					END IF;
					line_cnt <= line_cnt + '1';
				WHEN c4 => 
					IF SW(0) = '0' THEN
						STATE <= c5;
						SAVED_STATE := c5;
					ELSE
						STATE <= c3;
						SAVED_STATE := c3;
					END IF;
					line_cnt <= line_cnt + '1';
				WHEN c5 => 
					IF SW(0) = '0' THEN
						STATE <= c1;
						SAVED_STATE := c1;
					ELSE
						STATE <= c4;
						SAVED_STATE := c4;
					END IF;
					line_cnt <= line_cnt + '1';
				WHEN m0 =>
					STATE <= SAVED_STATE;
				WHEN m1 =>
					STATE <= m2;
				WHEN m2 =>
					STATE <= SAVED_STATE;
					line_cnt <= (others => '0');
			END CASE;
			
			IF line_cnt = "10000" THEN
				STATE <= m0;
			ELSIF line_cnt = "100000" THEN
				STATE <= m1;
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS(STATE)
	BEGIN
		CASE STATE IS
			WHEN r0 =>
				lcd_rs <= '0';
				lcd_data <= "00111000";
			WHEN r1 =>
				lcd_rs <= '0';
				lcd_data <= "00111000";
			WHEN r2 =>
				lcd_rs <= '0';
				lcd_data <= "00001100";
			WHEN r3 =>
				lcd_rs <= '0';
				lcd_data <= "00000001"; --clear screen
			WHEN r4 =>
				lcd_rs <= '0';
				lcd_data <= "00000110";
			WHEN r5 =>
				lcd_rs <= '0';
				lcd_data <= "10000000"; --move cursor to first row
			WHEN c1 =>
				lcd_rs <= '1';
				lcd_data <= "01000001"; --write A
			WHEN c2 =>
				lcd_rs <= '1';
				lcd_data <= "01001101"; --write M
			WHEN c3 =>
				lcd_rs <= '1';
				lcd_data <= "01001001"; --write I
			WHEN c4 =>
				lcd_rs <= '1';
				lcd_data <= "01010100"; --write T
			WHEN c5 =>
				lcd_rs <= '1';
				lcd_data <= "01001111"; --write O
			WHEN m0 =>
				lcd_rs <= '0';
				lcd_data <= "11000000"; --move cursor to second row
			WHEN m1 =>
				lcd_rs <= '0';
				lcd_data <= "10000000"; --move cursor to first row
			WHEN m2 =>
				lcd_rs <= '0';
				lcd_data <= "00000001"; --clear screen
		END CASE;
	END PROCESS;
 
 
end behavioural;

