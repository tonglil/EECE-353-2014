-- Your Names:  Amitoj Kooner
-- Your Student Numbers: 33263112
-- Your Lab Section:  L2C


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity converter is
	port(
		-- slide switches	
		SW : in std_logic_vector(3 downto 0);  

		-- 7-segment display
		HEX0 : out std_logic_vector(6 downto 0)
	);  
end converter ;

architecture behavioural of converter is

begin

	process(SW)
	variable x : std_logic_vector(6 downto 0);
	begin

		x := (others => SW(3));
		case SW(2 downto 0) is
			when "000" => HEX0 <= x XOR "0001000";
			when "001" => HEX0 <= x XOR "0000011";
			when "010" => HEX0 <= x XOR "1000110";
			when "011" => HEX0 <= x XOR "0100001";            
			when "100" => HEX0 <= x XOR "0000110";
			when "101" => HEX0 <= x XOR "0001110";
			when "110" => HEX0 <= x XOR "0010000";
			when others => HEX0 <= x XOR "0001001";
		end case;

	end process;
	
end behavioural;

