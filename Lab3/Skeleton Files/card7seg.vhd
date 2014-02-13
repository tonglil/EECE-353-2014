LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY card7seg IS
	PORT(
		card : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- card type (Ace, 2..10, J, Q, K)
		seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
	);
END;


ARCHITECTURE behavioral OF card7seg IS
BEGIN

   PROCESS (card)
	BEGIN
		CASE card IS
			WHEN "0000" => seg7 <= "1110111"; --_
			WHEN "0001" => seg7 <= "0001000"; --A
			WHEN "0010" => seg7 <= "0100100"; --2
			WHEN "0011" => seg7 <= "0110000"; --3
			WHEN "0100" => seg7 <= "0011001"; --4
			WHEN "0101" => seg7 <= "0010010"; --5
			WHEN "0110" => seg7 <= "0000010"; --6
			WHEN "0111" => seg7 <= "1111000"; --7
			WHEN "1000" => seg7 <= "0000000"; --8
			WHEN "1001" => seg7 <= "0010000"; --9
			WHEN "1010" => seg7 <= "1000000"; --10
			WHEN "1011" => seg7 <= "1110001"; --j
			WHEN "1100" => seg7 <= "0011000"; --q
			WHEN "1101" => seg7 <= "0001001"; --k
			WHEN others => seg7 <= "1110111"; --_
		END CASE;
	END PROCESS;

END;
