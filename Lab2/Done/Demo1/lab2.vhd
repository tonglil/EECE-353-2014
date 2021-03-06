-- Your Names:  Amitoj Kooner, Tongli Li
-- Your Student Numbers: 33263112, 15688112
-- Your Lab Section:  L2C

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
		CLOCK_50 : in std_logic
	);  -- one of the 7-segment diplays
end lab2;

architecture behavioural of lab2 is
	TYPE state_types is (r0, r1, r2, r3, r4, r5, c1, c2, c3, c4, c5, m0, m1, m2);
	SIGNAL STATE : state_types := r0;
	SIGNAL cnt : std_logic_vector (24 downto 0) := (others => '0');
begin
	lcd_blon <= '1';
	lcd_on <= '1';
	lcd_en <= cnt(24);
	lcd_rw <= '0';

	PROCESS(CLOCK_50)
	BEGIN
		IF rising_edge(CLOCK_50) THEN
			cnt <= cnt + '1';
		END IF;
	END PROCESS;
	
	PROCESS(KEY, cnt)
	variable NEXT_STATE : state_types;
	variable line_cnt : std_logic_vector (5 downto 0) := (others => '0');
	BEGIN
		IF (key(0) = '0') THEN
			STATE <= r0;
			line_cnt := (others => '0');
		ELSIF (rising_edge(cnt(24))) THEN
			CASE STATE IS
				WHEN r0 => NEXT_STATE := r1;
				WHEN r1 => NEXT_STATE := r2;
				WHEN r2 => NEXT_STATE := r3;
				WHEN r3 => NEXT_STATE := r4;
				WHEN r4 => NEXT_STATE := r5;
				WHEN r5 => 
					NEXT_STATE := c1;

				WHEN c1 => 
					IF SW(0) = '0' THEN
						NEXT_STATE := c2;
					ELSE
						NEXT_STATE := c5;
					END IF;
					line_cnt := line_cnt + '1';
					
				WHEN c2 => 
					IF SW(0) = '0' THEN
						NEXT_STATE := c3;
					ELSE
						NEXT_STATE := c1;
					END IF;
					line_cnt := line_cnt + '1';
					
				WHEN c3 => 
					IF SW(0) = '0' THEN
						NEXT_STATE := c4;
					ELSE
						NEXT_STATE := c2;
					END IF;
					line_cnt := line_cnt + '1';
					
				WHEN c4 => 
					IF SW(0) = '0' THEN
						NEXT_STATE := c5;
					ELSE
						NEXT_STATE := c3;
					END IF;
					line_cnt := line_cnt + '1';
					
				WHEN c5 => 
					IF SW(0) = '0' THEN
						NEXT_STATE := c1;
					ELSE
						NEXT_STATE := c4;
					END IF;
					line_cnt := line_cnt + '1';
					
				WHEN m0 =>
					line_cnt := line_cnt + '1';
				WHEN m1 =>
					line_cnt := line_cnt + '1';
				WHEN m2 => 
					line_cnt := (others => '0');
					
				WHEN others => null;
			END CASE;
			
			IF line_cnt = "10000" THEN
				STATE <= m0;
			ELSIF line_cnt = "100001" THEN
				STATE <= m1;
			ELSIF line_cnt = "100010" THEN
				STATE <= m2;
			ELSE
				STATE <= NEXT_STATE;
			END IF;
			
			ledg <= line_cnt;

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
				lcd_data <= "01101101"; --write M
			WHEN c3 =>
				lcd_rs <= '1';
				lcd_data <= "01101001"; --write I
			WHEN c4 =>
				lcd_rs <= '1';
				lcd_data <= "01110100"; --write T
			WHEN c5 =>
				lcd_rs <= '1';
				lcd_data <= "01101111"; --write O
			WHEN m0 =>
				lcd_rs <= '0';
				lcd_data <= "11000000"; --move cursor to second row
			WHEN m1 =>
				lcd_rs <= '0';
				lcd_data <= "10000000"; --move cursor to first row
			WHEN m2 => -- m2
				lcd_rs <= '0';
				lcd_data <= "00000001"; --clear screen
			WHEN others => null;
		END CASE;
	END PROCESS;
 
 
end behavioural;

