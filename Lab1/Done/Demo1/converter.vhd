-- Your Names:  Amitoj Kooner, Tongli Li
-- Your Student Numbers: 33263112, 15688112
-- Your Lab Section:  L2C

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity converter is
	port(
		-- slide switches	
		SW : in std_logic_vector(2 downto 0); 
		
		-- 7-segment display
		HEX0 : out std_logic_vector(6 downto 0)
	);  
end converter ;

architecture behavioural of converter is
begin
	-- METHOD 2: SYNTHESIZABLE LOGIC
	process(SW)
	begin
		case SW is
			when "000" => HEX0 <= "0001000";
			when "001" => HEX0 <= "0000011";
			when "010" => HEX0 <= "1000110";
			when "011" => HEX0 <= "0100001";            
			when "100" => HEX0 <= "0000110";
			when "101" => HEX0 <= "0001110";
			when "110" => HEX0 <= "0010000";
			when others => HEX0 <= "0001001";
		end case;
	end process;
end behavioural;

