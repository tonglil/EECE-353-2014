LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- ensure components in other 'vhd' project files can be included  
LIBRARY WORK;
USE WORK.ALL;

ENTITY datapath IS
	PORT(
	   slow_clock : IN STD_LOGIC;	-- step through game
		fast_clock : IN STD_LOGIC;	-- shuffling cards
		resetb : IN STD_LOGIC;		-- state machine active low reset
		load_pcard1, load_pcard2, load_pcard3 : IN STD_LOGIC;	-- load player cards
		load_dcard1, load_dcard2, load_dcard3 : IN STD_LOGIC;	-- load dealer cards
		
		dscore_out, pscore_out : out STD_LOGIC_VECTOR(3 downto 0);	-- scores
		pcard3_out	: out STD_LOGIC_VECTOR(3 downto 0);					-- player 3rd card
		
		HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 7
		HEX6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 6
		HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 5
		HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 4
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 3
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 2
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 1
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- digit 0
	);
END datapath;

ARCHITECTURE mixed OF datapath IS

BEGIN
	PROCESS(slow_clock, resetb, load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3)
	BEGIN
		IF rising_edge(slow_clock) THEN
			-- if enable (load_pcard1) is high -> dealcard => register
			IF load_pcard1 = '1' THEN
			END IF;
		END IF;
    -- Your code goes here
	 END PROCESS;
	 
	 
	 
	 
END;


-- add reg4 here

-----

--ARCHITECTURE behavioral OF dealcard IS
--	SIGNAL	dealer_card : UNSIGNED(3 DOWNTO 0);
--	
--BEGIN
--	-- The dealer is always shuffling the deck
--	PROCESS( clock, resetb )
--	BEGIN
--		IF resetb='0' THEN
--			dealer_card <= "0001";
--		ELSIF RISING_EDGE(clock) THEN
--			IF dealer_card = "1101" THEN
--				dealer_card <= "0001";
--			ELSE
--				dealer_card <= dealer_card + 1;
--			END IF;
--		END IF;
--	END PROCESS;
--
--	new_card <= std_logic_vector(dealer_card);
--END;
--
