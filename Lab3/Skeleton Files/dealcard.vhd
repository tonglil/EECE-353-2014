-- Lucky you !!  We are giving you this code.  There is nothing
-- here you need to add or write.  

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY dealcard IS
	PORT(
		clock : IN  STD_LOGIC;
		resetb : IN  STD_LOGIC;
		new_card  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)	-- new card to deal
	);
END;

ARCHITECTURE behavioral OF dealcard IS
	SIGNAL	dealer_card : UNSIGNED(3 DOWNTO 0);
	
BEGIN
	-- The dealer is always shuffling the deck
	PROCESS( clock, resetb )
	BEGIN
		IF resetb='0' THEN
			dealer_card <= "0001";
		ELSIF RISING_EDGE(clock) THEN
			IF dealer_card = "1101" THEN
				dealer_card <= "0001";
			ELSE
				dealer_card <= dealer_card + 1;
			END IF;
		END IF;
	END PROCESS;

	new_card <= std_logic_vector(dealer_card);
END;