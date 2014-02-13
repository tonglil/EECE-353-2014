LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

ENTITY reg4 IS
--	PORT(
--	   card1, card2, card3 : IN STD_LOGIC_VECTOR(3 downto 0);
--		total : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)  -- total value of hand
--	);
	port(	I:	in std_logic_vector(4 downto 0);
	clock:	in std_logic;
	load:	in std_logic;
	clear:	in std_logic;
	Q:	out std_logic_vector(4 downto 0)
);
END reg4;


ARCHITECTURE behavioral OF reg4 IS

   signal Q_tmp: std_logic_vector(4 downto 0);

	BEGIN
		process(I, clock, load, clear)
		begin

		if clear = '0' then
		-- use 'range in signal assigment 
		Q_tmp <= (Q_tmp'range => '0');
		elsif (clock='1' and clock'event) then
			if load = '1' then
			Q_tmp <= I;
			end if;
		end if;

		end process;

		-- concurrent statement
		Q <= Q_tmp;
		 
	END;