LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

ENTITY datapath IS
	PORT (
		clk : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		initx, inity, loady, initl, drawl : IN STD_LOGIC;
		x : OUT STD_LOGIC_VECTOR(7 downto 0); -- x0
		y : OUT STD_LOGIC_VECTOR(6 downto 0);
		xin : IN STD_LOGIC_VECTOR(7 downto 0); -- x1
		yin : IN STD_LOGIC_VECTOR(6 downto 0);
		xdone, ydone, ldone : OUT STD_LOGIC
	);
END datapath;

ARCHITECTURE mixed OF datapath IS
BEGIN

	PROCESS(clk, resetb)
		VARIABLE x_tmp : unsigned(7 downto 0) := "00000000";
		VARIABLE y_tmp : unsigned(6 downto 0) := "0000000";
		
		VARIABLE dx : signed(7 downto 0);
		VARIABLE dy : signed(6 downto 0);
		
		VARIABLE err : signed(7 downto 0);
		VARIABLE e2 : signed(7 downto 0);
		
		VARIABLE x0 : signed(7 downto 0);	-- 80
		VARIABLE y0 : signed(6 downto 0);	-- 60
		
		VARIABLE x1 : signed(7 downto 0);
		VARIABLE y1 : signed(6 downto 0);
		
		VARIABLE sx : signed(1 downto 0);
		VARIABLE sy : signed(1 downto 0);
	BEGIN
		IF (resetb = '0') THEN
			y_tmp := "0000000";
			x_tmp := "00000000"; -- ARE THESE NECESSARY?
		ELSIF rising_edge(clk) THEN
			IF (initl = '1') THEN
				x0 := "01010000";	-- 80
				y0 := "0111100";	-- 60
				x1 := signed(xin);
				y1 := signed(yin);
				dx := abs(x0 - x1);
				dy := abs(y0 - y1);
				IF (x0 < x1) THEN
					sx := to_signed(1, 2);
				ELSE
					sx := to_signed(-1, 2);
				END IF;
				IF (y0 < y1) THEN
					sy := to_signed(1, 2);
				ELSE
					sy := to_signed(-1, 2);
				END IF;
				err := dx - dy;
				ldone <= '0';
			ELSIF (drawl = '1') THEN
				x <= STD_LOGIC_VECTOR(x0);
				y <= STD_LOGIC_VECTOR(y0);
				IF ((x1 = x0) and (y1 = y0)) THEN
					ldone <= '1';
				ELSE
					e2 := err + err;
					IF (e2 > -dy) THEN
						err := err - dy;
						x0 := x0 + sx;
					END IF;
					IF (e2 < dx) THEN
						err := err + dx;
						y0 := y0 + sy;
					END IF;
				END IF;
			ELSE
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
		END IF;
	END PROCESS;

END mixed;