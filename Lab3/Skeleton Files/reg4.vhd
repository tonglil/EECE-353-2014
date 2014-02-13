LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

ENTITY reg4 IS
	PORT(	
		I:	in std_logic_vector(3 downto 0);
		slow_clock:	in std_logic;
		load:	in std_logic;
		resetb: in std_logic;
		Q:	out std_logic_vector(3 downto 0)
);
END reg4;


ARCHITECTURE behavioral OF reg4 IS

signal Q_tmp: std_logic_vector(3 downto 0);

BEGIN
	process(I, slow_clock, load, resetb)
	begin
		if resetb = '0' then
			-- use 'range in signal assigment 
			Q_tmp <= (Q_tmp'range => '0');
		elsif (slow_clock='1' and slow_clock'event) then
			if load = '1' then
				Q_tmp <= I;
			end if;
		end if;
	end process;
	-- concurrent statement
	Q <= Q_tmp;
END;