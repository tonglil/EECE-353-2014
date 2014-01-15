-- Your Names:  Amitoj Kooner
-- Your Student Numbers: 33263112
-- Your Lab Section:  L2C

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity converterv2 is
	port(
		-- 7-segment display
		HEX0 : out std_logic_vector(6 downto 0);
		
		KEY : in std_logic_vector(0 downto 0)
	);  
end converterv2 ;


architecture behavioural of converterv2 is
signal cnt : integer range 0 to 7 := 0;

begin

	process(KEY)
	begin
		if (rising_edge(KEY(0))) then
			if cnt < 7 then
				cnt <= cnt + 1;
			else
				cnt <= 0;
			end if;
		end if;
	end process;
	
	process(cnt)
	begin
		case cnt is
			when 0 => HEX0 <= "0001000";
			when 1 => HEX0 <= "0000011";
			when 2 => HEX0 <= "1000110";
			when 3 => HEX0 <= "0100001";            
			when 4 => HEX0 <= "0000110";
			when 5 => HEX0 <= "0001110";
			when 6 => HEX0 <= "0010000";
			when others => HEX0 <= "0001001";
		end case;

	end process;
	
end behavioural;

