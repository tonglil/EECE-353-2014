LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

ENTITY statemachine IS
	PORT (
		clk : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		xdone, ydone, ldone : IN STD_LOGIC;
		sw : IN STD_LOGIC_VECTOR(17 downto 0);
		draw : IN STD_LOGIC;
		initx, inity, loady, plot, initl, drawl : OUT STD_LOGIC;
		x : OUT STD_LOGIC_VECTOR(7 downto 0);
		y : OUT STD_LOGIC_VECTOR(6 downto 0)
	);
END statemachine;

ARCHITECTURE behavioural OF statemachine IS
  TYPE state_types is (sr, sby, sbx, sbdone, slinit, sldraw, sldone);
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
				WHEN sbdone => 
					IF (draw = '0') THEN
						x <= sw(17 downto 10);
						y <= sw(9 downto 3);
						IF (unsigned(x) <= 159 AND unsigned(y) <= 119) THEN
							next_state := slinit;
						ELSE
							next_state := sbdone;
						END IF;
					ELSE
						next_state := sbdone;
					END IF;
				WHEN slinit => 
					next_state := sldraw;
				WHEN sldraw =>
					IF (LDONE = '1') THEN
						next_state := sldone;
					ELSE
						next_state := sldraw;
					END IF;
				WHEN others =>
					next_state := sldone;
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
				INITL <= '0';
				DRAWL <= '0';
				PLOT <= '0';
			WHEN sby => 
				INITX <= '1';
				INITY <= '0';
				LOADY <= '1';
				INITL <= '0';
				DRAWL <= '0';
				PLOT <= '0';
			WHEN sbx => 
				INITX <= '0';
				INITY <= '0';
				LOADY <= '0';
				INITL <= '0';
				DRAWL <= '0';
				PLOT <= '1';
			WHEN slinit =>
				INITX <= '0';
				INITY <= '0';
				LOADY <= '0';
				INITL <= '1';
				DRAWL <= '0';
				PLOT <= '0';
			WHEN sldraw =>
				INITX <= '0';
				INITY <= '0';
				LOADY <= '0';
				INITL <= '0';
				DRAWL <= '1';
				PLOT <= '1';
			WHEN others => 
				INITX <= '0';
				INITY <= '0';
				LOADY <= '0';
				INITL <= '0';
				DRAWL <= '0';
				PLOT <= '0';
		END CASE;
	END PROCESS;
		
END behavioural;