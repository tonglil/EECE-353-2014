LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- ensure components in other 'vhd' project files can be included  
LIBRARY WORK;
USE WORK.ALL;

ENTITY statemachine IS
	PORT(

	   slow_clock : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		
		dscore, pscore : IN STD_LOGIC_VECTOR(3 downto 0);
		pcard3 : IN STD_LOGIC_VECTOR(3 downto 0);
		
		load_pcard1, load_pcard2, load_pcard3 : OUT STD_LOGIC;
		load_dcard1, load_dcard2, load_dcard3 : OUT STD_LOGIC;
		
  		LEDG : OUT STD_LOGIC_VECTOR(1 downto 0)	
	);
END statemachine;


ARCHITECTURE behavioural OF statemachine IS
	TYPE state_types is (s, lp1, lp2, lp3, ld1, ld2, ld3, go, pwin, dwin, tie);
	SIGNAL STATE : state_types := s;
BEGIN

	PROCESS (slow_clock, resetb)
	VARIABLE NEXT_STATE : state_types;
	BEGIN
		IF(resetb = '0') THEN
			STATE <= s;
		ELSIF (rising_edge(slow_clock)) THEN
			CASE STATE IS
				WHEN s => NEXT_STATE := lp1;
				WHEN lp1 => NEXT_STATE := ld1;
				WHEN ld1 => NEXT_STATE := lp2;
				WHEN lp2 => NEXT_STATE := ld2;
				WHEN ld2 =>
					IF (unsigned(pscore) >= 8 OR unsigned(dscore) >= 8) THEN
						NEXT_STATE := go;
					ELSE
						IF (unsigned(pscore) >= 0 AND unsigned(pscore) <= 5) THEN
							NEXT_STATE := lp3;
						ELSE
							IF (unsigned(dscore) >= 0 AND unsigned(dscore) <= 5) THEN
								NEXT_STATE := ld3;
							ELSE
								NEXT_STATE := go;
							END IF;
						END IF;
					END IF;
				WHEN lp3 =>
					IF (unsigned(dscore) = 7) THEN
						NEXT_STATE := go;
					ELSIF (unsigned(dscore) = 6 AND (unsigned(pcard3) = 6 OR unsigned(pcard3) = 7)) THEN
						NEXT_STATE := ld3;
					ELSIF (unsigned(dscore) = 5 AND (unsigned(pcard3) >= 4 AND unsigned(pcard3) <= 7)) THEN
						NEXT_STATE := ld3;
					ELSIF (unsigned(dscore) = 4 AND (unsigned(pcard3) >= 2 AND unsigned(pcard3) <= 7)) THEN
						NEXT_STATE := ld3;
					ELSIF (unsigned(dscore) = 3 AND unsigned(pcard3) /= 8) THEN --SHOULD CHECK IF THE PLAYER's THIRD CARD IS NOT 8
						NEXT_STATE := ld3;
					ELSIF (unsigned(dscore) >= 0 AND unsigned(pscore) <= 2) THEN
						NEXT_STATE := ld3;
					ELSE
						NEXT_STATE := go;
					END IF;
				WHEN ld3 => NEXT_STATE := go;
				WHEN go =>
					IF (pscore > dscore) THEN
						NEXT_STATE := pwin;
					ELSIF (dscore > pscore) THEN
						NEXT_STATE := dwin;
					ELSE
						NEXT_STATE := tie;
					END IF;
				WHEN others => null;
			END CASE;
			
			STATE <= NEXT_STATE;
		END IF;
	END PROCESS;
	
	PROCESS (STATE)
	BEGIN
		CASE STATE IS
			WHEN s => 
				LEDG <= "00";
				load_pcard1 <= '0';
				load_pcard2 <= '0';
				load_pcard3 <= '0';
				load_dcard1 <= '0';
				load_dcard2 <= '0';
				load_dcard3 <= '0';
			WHEN lp1 =>
				LEDG <= "00";
				load_pcard1 <= '1';
				load_pcard2 <= '0';
				load_pcard3 <= '0';
				load_dcard1 <= '0';
				load_dcard2 <= '0';
				load_dcard3 <= '0';
			WHEN lp2 =>
				LEDG <= "00";
				load_pcard1 <= '0';
				load_pcard2 <= '1';
				load_pcard3 <= '0';
				load_dcard1 <= '0';
				load_dcard2 <= '0';
				load_dcard3 <= '0';
			WHEN lp3 =>
				LEDG <= "00";
				load_pcard1 <= '0';
				load_pcard2 <= '0';
				load_pcard3 <= '1';
				load_dcard1 <= '0';
				load_dcard2 <= '0';
				load_dcard3 <= '0';
			WHEN ld1 =>
				LEDG <= "00";
				load_pcard1 <= '0';
				load_pcard2 <= '0';
				load_pcard3 <= '0';
				load_dcard1 <= '1';
				load_dcard2 <= '0';
				load_dcard3 <= '0';
			WHEN ld2 =>
				LEDG <= "00";
				load_pcard1 <= '0';
				load_pcard2 <= '0';
				load_pcard3 <= '0';
				load_dcard1 <= '0';
				load_dcard2 <= '1';
				load_dcard3 <= '0';
			WHEN ld3 =>
				LEDG <= "00";
				load_pcard1 <= '0';
				load_pcard2 <= '0';
				load_pcard3 <= '0';
				load_dcard1 <= '0';
				load_dcard2 <= '0';
				load_dcard3 <= '1';
			WHEN go =>
				LEDG <= "00";
				load_pcard1 <= '0';
				load_pcard2 <= '0';
				load_pcard3 <= '0';
				load_dcard1 <= '0';
				load_dcard2 <= '0';
				load_dcard3 <= '0';
			WHEN pwin =>
				LEDG <= "01";
				load_pcard1 <= '0';
				load_pcard2 <= '0';
				load_pcard3 <= '0';
				load_dcard1 <= '0';
				load_dcard2 <= '0';
				load_dcard3 <= '0';
			WHEN dwin =>
				LEDG <= "10";
				load_pcard1 <= '0';
				load_pcard2 <= '0';
				load_pcard3 <= '0';
				load_dcard1 <= '0';
				load_dcard2 <= '0';
				load_dcard3 <= '0';
			WHEN tie =>
				LEDG <= "11";
				load_pcard1 <= '0';
				load_pcard2 <= '0';
				load_pcard3 <= '0';
				load_dcard1 <= '0';
				load_dcard2 <= '0';
				load_dcard3 <= '0';
			WHEN others => null;
		END CASE;
	END PROCESS;

END behavioural;
