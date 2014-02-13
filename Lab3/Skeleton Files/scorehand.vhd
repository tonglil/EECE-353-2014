LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY scorehand IS
	PORT(
	   card1, card2, card3 : IN STD_LOGIC_VECTOR(3 downto 0);
		total : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)  -- total value of hand
	);
END scorehand;


ARCHITECTURE behavioral OF scorehand IS

BEGIN

	PROCESS (card1, card2, card3)
	VARIABLE c : unsigned (3 downto 0);
	BEGIN
		CASE card1 IS
			WHEN "0000" => c := "0000";
			WHEN "1010" => c := "0000";
			WHEN "1011" => c := "0000";
			WHEN "1100" => c := "0000";
			WHEN others => c := unsigned(card1);
		END CASE;
		CASE card2 IS
			WHEN "0000" => c := c;
			WHEN "1010" => c := c;
			WHEN "1011" => c := c;
			WHEN "1100" => c := c;
			WHEN others => c := (c + unsigned(card2)) mod 10;
		END CASE;
		CASE card3 IS
			WHEN "0000" => c := c;
			WHEN "1010" => c := c;
			WHEN "1011" => c := c;
			WHEN "1100" => c := c;
			WHEN others => c := (c + unsigned(card3)) mod 10;
		END CASE;
		
		total <= std_logic_vector(c);
	END PROCESS;

END;
