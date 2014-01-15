-- Your Names:  type your names here
-- Your Student Numbers: type your student numbers here
-- Your Lab Section:  type your lab section here


-- Lab 1 Skeleton File
-- You should add your code to this file below.  

-- The following lines should be at the top of all your
-- VHDL files.  The lines include standard libraries 
-- that you will need in your labs (and most future labs).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


-- Below is the entity part of the converter.  The inputs are SW(2),
-- SW(1), and SW(0), and the outputs are HEX0(6) downto HEX0(0).
-- Note that the three inputs SW(2), SW(1) and SW(0) are collectively referred to 
-- as the three bit bus SW.  If SW="011", this means that SW(2) is
-- 0 (the first digit), SW(1) is 1 (the second digit), and SW(0) is
-- 1 (the third digit).  In addition, note that seven outputs are
-- collectively referred to as HEX0.  So if HEX0 is "0110111", then
-- HEX0(6) is 0 (the first digit), HEX0(5) is 1 (the second digit), etc.
-- We need to use *exactly* these names, since our "pin assignment" file has
-- these signal names hardcoded.  Don't change these port names!!!

entity converter is
	port(
		-- slide switches	
		SW : in std_logic_vector(2 downto 0);  

		-- 7-segment display
		HEX0 : out std_logic_vector(6 downto 0)
	);  
end converter ;

-- Next is the architecture part of the converter.  This will describe
-- the function of the module.  

architecture behavioural of converter is
begin

	-- There are many ways to describe combinational logic in VHDL, and
	-- we will see a number of them in class.

	-- METHOD 1: MANUAL EQUATIONS

	-- You should write a logic equation for each output bit.
	-- The logic equations would look something like this:
--	HEX0(0) <= SW(2) and     SW(1)  or     SW(0);
--	HEX0(1) <= SW(2) and     SW(1)  or not SW(0);
--	HEX0(2) <= SW(2) and not SW(1)  or     SW(0);
--	HEX0(3) <= SW(2) and not SW(1)  or not SW(0);
--	HEX0(4) <= SW(2)  or     SW(1) and     SW(0);
--	HEX0(5) <= SW(2)  or not SW(1) and     SW(0);
--	HEX0(6) <= SW(2)  or     SW(1) and not SW(0);
	-- Of course, the equations above are completely bogus.
	-- You need to manually determine each logic equation by
	-- producing a truth table for each output, then converting
	-- each truth table into an equation (eg, using a Karnaugh
	-- map). This is tedious, but give it a try.  It will give
	-- you a better appreciation for the power of VHDL when you
	-- read on and use the CASE statement shown below.


-- -----------------------------------------------------------------
	-- If you wish to use the HEX0 equations above by uncommenting them,
	-- you need to comment out the entire process below, from the
	-- line starting with `process' down to the 'end process' line.
-- -----------------------------------------------------------------


	-- METHOD 2: SYNTHESIZABLE LOGIC

	-- The following line indicates the start of a "process".  For now, you
	-- can think of a "process" as a "block of hardware".  The SW in brackets
	-- means that the outputs of this block of hardware may change whenever
	-- the signal SW (which collectively refers to bits SW(2), SW(1) and SW(0) )
	-- changes.  Don't worry too much about this yet; we will talk a lot about
	-- processes in class.  You don't need to change this line for Lab 1.

	process(SW)
	begin

		-- Here we describe the function of this block of hardware.

		-- There are many ways to describe combinational logic, and we will talk
		-- about a number of them in class.  The way we use here is perhaps the 
		-- most common.  The logic is described using something that looks like
		-- a CASE or SWITCH statement in a software language.  The first line
		-- indicates the selection criteria for this CASE statement.  The
		-- remaining lines in the case statement indicate an action that should
		-- occur for each value of the selection criteria.  So for example,
		-- the first "when" line indicates that when the selection criteria SW
		-- is "000", the output HEX0 should be assigned the value "0001000".
		-- The second "when" line indicates that if SW is "001", the output
		-- HEX0 should be assigned the value "0000011".  There is one "when"
		-- line for each possible value of SW (note that the last line is
		-- labeled with "others" rather than "111" ... we will see why this is
		-- in class much later).

		case SW is
			when "000" => HEX0 <= "0001000";
			when "001" => HEX0 <= "0000011";
			when "010" => HEX0 <= "insert a string of 7 bits here";
			when "011" => HEX0 <= "insert a string of 7 bits here";            
			when "100" => HEX0 <= "insert a string of 7 bits here";
			when "101" => HEX0 <= "insert a string of 7 bits here";
			when "110" => HEX0 <= "insert a string of 7 bits here";
			when others => HEX0 <= "insert a string of 7 bits here";
		end case;

	end process;
	
end behavioural;

