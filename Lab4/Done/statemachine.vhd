LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

ENTITY statemachine IS
	PORT (
		clk : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		xdone, ydone : IN STD_LOGIC;
		initx, inity, loady, plot : OUT STD_LOGIC
	);
END statemachine;
	
	
ARCHITECTURE behavioural OF statemachine IS
  TYPE state_types is (sr, sby, sbx, sbdone);
  SIGNAL state : state_types := sr;
BEGIN

	PROCESS(clk, resetb)
		VARIABLE next_state : state_types;
	BEGIN
		IF (resetb = '0') THEN
			state <= sr;
		ELSIF rising_edge(clk) THEN
			CASE state IS
				WHEN sr => 
					next_state := sbx;
				WHEN sby => 
					next_state := sbx;
				WHEN sbx => 
					IF (XDONE = '0') THEN
						next_state := sbx;
					ELSIF (XDONE = '1' AND YDONE = '0') THEN
						next_state := sby;
					ELSE 
						next_state := sbdone;
					END IF;
				WHEN others => 
					next_state := sbdone;
			END CASE;
			state <= next_state;
		END IF;
	END PROCESS;
	
	PROCESS(state)
	BEGIN
		CASE state IS
			WHEN sr => 
				INITX <= '1';
				INITY <= '1';
				LOADY <= '1';
				PLOT <= '0';
			WHEN sby => 
				INITX <= '1';
				INITY <= '0';
				LOADY <= '1';
				PLOT <= '0';
			WHEN sbx => 
				INITX <= '0';
				INITY <= '0';
				LOADY <= '0';
				PLOT <= '1';
			WHEN others => 
				PLOT <= '0';
		END CASE;
	END PROCESS;
		
END behavioural;