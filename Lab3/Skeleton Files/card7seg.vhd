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
			WHEN "0000" => seg7 <= "0001000"; --A
			WHEN "0001" => seg7 <= "0010010"; --2
			WHEN "0010" => seg7 <= "0000110"; --3
			WHEN "0011" => seg7 <= "1001100"; --4
			WHEN "0100" => seg7 <= "0100100"; --5
			WHEN "0101" => seg7 <= "0100000"; --6
			WHEN "0110" => seg7 <= "0001111"; --7
			WHEN "0111" => seg7 <= "0000000"; --8
			WHEN "1000" => seg7 <= "0000100"; --9
			WHEN "1001" => seg7 <= "0000001"; --10
			WHEN "1010" => seg7 <= "1000111"; --j
			WHEN "1011" => seg7 <= "0001100"; --q
			WHEN "1100" => seg7 <= "1001000"; --k
			WHEN others => seg7 <= "1110111"; --_
		END CASE;
	END PROCESS;

END;
