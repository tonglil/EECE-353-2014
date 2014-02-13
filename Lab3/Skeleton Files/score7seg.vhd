LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY score7seg IS
	PORT(
		score : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- score (0 to 9)
		seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
	);
END;


ARCHITECTURE behavioral OF score7seg IS
BEGIN

	PROCESS (score)
	BEGIN
		CASE score IS
			WHEN "0000" => seg7 <= "1000000"; --0
			WHEN "0001" => seg7 <= "1111001"; --1
			WHEN "0010" => seg7 <= "0100100"; --2
			WHEN "0011" => seg7 <= "0110000"; --3
			WHEN "0100" => seg7 <= "0011001"; --4
			WHEN "0101" => seg7 <= "0010010"; --5
			WHEN "0110" => seg7 <= "0000010"; --6
			WHEN "0111" => seg7 <= "1111000"; --7
			WHEN "1000" => seg7 <= "0000000"; --8
			WHEN "1001" => seg7 <= "0010000"; --9
			WHEN others => seg7 <= "1110111"; --_
		END CASE;
	END PROCESS;


END;
