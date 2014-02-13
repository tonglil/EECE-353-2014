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

	COMPONENT dealcard
		PORT(
			clock : IN  STD_LOGIC;
			resetb : IN  STD_LOGIC;
			new_card  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)	-- new card to deal
		);
	END COMPONENT;

	COMPONENT reg4
		PORT(	
			I:	in std_logic_vector(3 downto 0);
			slow_clock:	in std_logic;
			load:	in std_logic;
			resetb:	in std_logic;
			Q:	out std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT card7seg
		PORT(
			card : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- card type (Ace, 2..10, J, Q, K)
			seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
		);
	END COMPONENT;

	COMPONENT scorehand
		PORT(
			card1, card2, card3 : IN STD_LOGIC_VECTOR(3 downto 0);
			total : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)  -- total value of hand
		);
	END COMPONENT;

	COMPONENT score7seg
		PORT(
			score : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- score (0 to 9)
			seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
		);
	END COMPONENT;

	SIGNAL new_card : STD_LOGIC_VECTOR(3 downto 0);			-- new_card
	SIGNAL pcard1_sig : STD_LOGIC_VECTOR(3 downto 0);		-- temporary player card
	SIGNAL pcard2_sig : STD_LOGIC_VECTOR(3 downto 0);		-- temporary player card
	SIGNAL pcard3_sig : STD_LOGIC_VECTOR(3 downto 0);		-- temporary player card
	SIGNAL pscore : STD_LOGIC_VECTOR(3 downto 0);			-- temporary player score
	SIGNAL dcard1_sig : STD_LOGIC_VECTOR(3 downto 0);		-- temporary dealer card
	SIGNAL dcard2_sig : STD_LOGIC_VECTOR(3 downto 0);		-- temporary dealer card
	SIGNAL dcard3_sig : STD_LOGIC_VECTOR(3 downto 0);		-- temporary dealer card
	SIGNAL dscore : STD_LOGIC_VECTOR(3 downto 0);			-- temporary dealer score

BEGIN

	dc : dealcard PORT MAP (
		clock => fast_clock,
		resetb => resetb,
		new_card => new_card
	);
	
	-- Player datapaths
	pcard1 : reg4 PORT MAP(	
		I => new_card,
		slow_clock => slow_clock,
		load => load_pcard1,
		resetb => resetb,
		Q => pcard1_sig
	);

	pcard2 : reg4 PORT MAP(	
		I => new_card,
		slow_clock => slow_clock,
		load => load_pcard2,
		resetb => resetb,
		Q => pcard2_sig
	);

	pcard3 : reg4 PORT MAP(	
		I => new_card,
		slow_clock => slow_clock,
		load => load_pcard3,
		resetb => resetb,
		Q => pcard3_sig
	);
	
	pcard3_out <= pcard3_sig;
	
	pcard1seg : card7seg PORT MAP(
		card : pcard1_sig;
		seg7 : HEX0
	);
	
	pcard2seg : card7seg PORT MAP(
		card : pcard2_sig;
		seg7 : HEX1
	);
	
	pcard3seg : card7seg PORT MAP(
		card : pcard3_sig;
		seg7 : HEX2
	);
	
	pscorehand : scorehand PORT MAP(
		card1 => pcard1_sig,
		card2 => pcard2_sig,
		card3 => pcard3_sig,
		total => pscore
	);
	
	pscore_out <= pscore;

	p7seg : score7seg PORT Map(
		score => pscore,
		seg7 => HEX3
	);

	-- Dealer datapaths
	dcard1 : reg4 PORT MAP(	
		I => new_card,
		slow_clock => slow_clock,
		load => load_dcard1,
		resetb => resetb,
		Q => dcard1_sig
	);

	dcard2 : reg4 PORT MAP(	
		I => new_card,
		slow_clock => slow_clock,
		load => load_dcard2,
		resetb => resetb,
		Q => dcard2_sig
	);

	dcard3 : reg4 PORT MAP(	
		I => new_card,
		slow_clock => slow_clock,
		load => load_dcard3,
		resetb => resetb,
		Q => dcard3_sig
	);

	dcard1seg : card7seg PORT MAP(
		card : dcard1_sig;
		seg7 : HEX4
	);
	
	dcard2seg : card7seg PORT MAP(
		card : dcard2_sig;
		seg7 : HEX5
	);
	
	dcard3seg : card7seg PORT MAP(
		card : dcard3_sig;
		seg7 : HEX6
	);
	
	dscorehand : scorehand PORT MAP(
		card1 => dcard1_sig,
		card2 => dcard2_sig,
		card3 => dcard3_sig,
		total => dscore
	);
	
	dscore_out <= dscore;
	
	d7seg : score7seg PORT Map(
		score => dscore,
		seg7 => HEX7
	);
	
END;