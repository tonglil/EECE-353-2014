LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

ENTITY datapath IS
	PORT (
		clk : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		initx, inity, loady : IN STD_LOGIC;
		x : OUT STD_LOGIC_VECTOR(7 downto 0);
		y : OUT STD_LOGIC_VECTOR(6 downto 0);
		xdone, ydone : OUT STD_LOGIC
	);
END datapath;

ARCHITECTURE mixed OF datapath IS
BEGIN

	PROCESS(clk, resetb)
		VARIABLE y_tmp : unsigned(6 downto 0) := "0000000";
		VARIABLE x_tmp : unsigned(7 downto 0) := "00000000";
	BEGIN
		IF (resetb = '0') THEN
			y_tmp := "0000000";
			x_tmp := "00000000"; -- ARE THESE NECESSARY?
		ELSIF rising_edge(clk) THEN
			IF (INITY = '1') THEN
				y_tmp := "0000000";
			ELSIF (LOADY = '1') THEN 
				y_tmp := y_tmp + 1;
			END IF;
			IF (y_tmp = 119) THEN
				YDONE <= '1';
			ELSE
				YDONE <= '0';
			END IF;
			Y <= std_logic_vector(y_tmp);
			
			IF (INITX = '1') THEN
				x_tmp := "00000000";
			ELSE 
				x_tmp := x_tmp + 1;
			END IF;
			IF (x_tmp = 159) THEN
				XDONE <= '1';
			ELSE
				XDONE <= '0';
			END IF;
			X <= std_logic_vector(x_tmp);
		END IF;
	END PROCESS;


END mixed;