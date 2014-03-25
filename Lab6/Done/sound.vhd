--Amitoj Kooner: 33263112
--Tongli Li: 15688112


LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY sound IS
	PORT (CLOCK_50,AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK,AUD_ADCDAT			:IN STD_LOGIC;
			CLOCK_27															:IN STD_LOGIC;
			KEY																:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			SW																	:IN STD_LOGIC_VECTOR(17 downto 0);
			I2C_SDAT															:INOUT STD_LOGIC;
			I2C_SCLK,AUD_DACDAT,AUD_XCK								:OUT STD_LOGIC);
END sound;

ARCHITECTURE Behavior OF sound IS

	   -- CODEC Cores
	
	COMPONENT clock_generator
		PORT(	CLOCK_27														:IN STD_LOGIC;
		    	reset															:IN STD_LOGIC;
				AUD_XCK														:OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT audio_and_video_config
		PORT(	CLOCK_50,reset												:IN STD_LOGIC;
		    	I2C_SDAT														:INOUT STD_LOGIC;
				I2C_SCLK														:OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT audio_codec
		PORT(	CLOCK_50,reset,read_s,write_s							:IN STD_LOGIC;
				writedata_left, writedata_right						:IN STD_LOGIC_VECTOR(23 DOWNTO 0);
				AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK		:IN STD_LOGIC;
				read_ready, write_ready									:OUT STD_LOGIC;
				readdata_left, readdata_right							:OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
				AUD_DACDAT													:OUT STD_LOGIC);
	END COMPONENT;

	SIGNAL read_ready, write_ready, read_s, write_s		      :STD_LOGIC;
	SIGNAL writedata_left, writedata_right							:STD_LOGIC_VECTOR(23 DOWNTO 0);	
	SIGNAL readdata_left, readdata_right							:STD_LOGIC_VECTOR(23 DOWNTO 0);	
	SIGNAL reset															:STD_LOGIC;

BEGIN

	reset <= NOT(KEY(0));
	read_s <= '0';

	my_clock_gen: clock_generator PORT MAP (CLOCK_27, reset, AUD_XCK);
	cfg: audio_and_video_config PORT MAP (CLOCK_50, reset, I2C_SDAT, I2C_SCLK);
	codec: audio_codec PORT MAP(CLOCK_50,reset,read_s,write_s,writedata_left, writedata_right,AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK,read_ready, write_ready,readdata_left, readdata_right,AUD_DACDAT);


	PROCESS(CLOCK_50, reset)
		type state_type is (sr, swrh, swrl); -- state_reset, state_write_ready_high, state_write_ready_low
		variable state : state_type := sr;
		CONSTANT TWO_SIXTEEN : signed(23 downto 0) := "000000010000000000000000";
		variable cnt_c : unsigned(6 downto 0) := "1010100";
		variable cnt_d : unsigned(6 downto 0) := "1001011";
		variable cnt_e : unsigned(6 downto 0) := "1000011";
		variable cnt_f : unsigned(6 downto 0) := "0111111";
		variable cnt_g : unsigned(6 downto 0) := "0111000";
		variable cnt_a : unsigned(6 downto 0) := "0110010";
		variable cnt_b : unsigned(6 downto 0) := "0101101";
		variable amplitude : signed(23 downto 0);
		variable amplitude_c : signed(23 downto 0) := TWO_SIXTEEN;
		variable amplitude_d : signed(23 downto 0) := TWO_SIXTEEN;
		variable amplitude_e : signed(23 downto 0) := TWO_SIXTEEN;
		variable amplitude_f : signed(23 downto 0) := TWO_SIXTEEN;
		variable amplitude_g : signed(23 downto 0) := TWO_SIXTEEN;
		variable amplitude_a : signed(23 downto 0) := TWO_SIXTEEN;
		variable amplitude_b : signed(23 downto 0) := TWO_SIXTEEN;
	BEGIN
		if (reset = '1') then
			state := sr;
		elsif (rising_edge(CLOCK_50)) then
			case state is
				when sr =>
					cnt_c := "1010100";
					cnt_d := "1001011";
					cnt_e := "1000011";
					cnt_f := "0111111";
					cnt_g := "0111000";
					cnt_a := "0110010";
					cnt_b := "0101101";
					state := swrh;
				when swrh =>
					if (write_ready = '1') then
						amplitude := (others => '0');
						if (sw(0) = '1') then
							amplitude := amplitude + amplitude_b;
						end if;
						if (sw(1) = '1') then
							amplitude := amplitude + amplitude_a;
						end if;
						if (sw(2) = '1') then
							amplitude := amplitude + amplitude_g;
						end if;
						if (sw(3) = '1') then
							amplitude := amplitude + amplitude_f;
						end if;
						if (sw(4) = '1') then
							amplitude := amplitude + amplitude_e;
						end if;
						if (sw(5) = '1') then
							amplitude := amplitude + amplitude_d;
						end if;
						if (sw(6) = '1') then
							amplitude := amplitude + amplitude_c;
						end if;
						writedata_left <= std_logic_vector(amplitude);
						writedata_right <= std_logic_vector(amplitude);
						write_s <= '1';
						
						cnt_c := cnt_c - 1;
						cnt_d := cnt_d - 1;
						cnt_e := cnt_e - 1;
						cnt_f := cnt_f - 1;
						cnt_g := cnt_g - 1;
						cnt_a := cnt_a - 1;
						cnt_b := cnt_b - 1;
						
						if (cnt_c = "0000000") then
							amplitude_c := -amplitude_c;
							cnt_c := "1010100";
						end if;
						if (cnt_d = "0000000") then
							amplitude_d := -amplitude_d;
							cnt_d := "1001011";
						end if;
						if (cnt_e = "0000000") then
							amplitude_e := -amplitude_e;
							cnt_e := "1000011";
						end if;
						if (cnt_f = "0000000") then
							amplitude_f := -amplitude_f;
							cnt_f := "0111111";
						end if;
						if (cnt_g = "0000000") then
							amplitude_g := -amplitude_g;
							cnt_g := "0111000";
						end if;
						if (cnt_a = "0000000") then
							amplitude_a := -amplitude_a;
							cnt_a := "0110010";
						end if;
						if (cnt_b = "0000000") then
							amplitude_b := -amplitude_b;
							cnt_b := "0101101";
						end if;
						state := swrl;
					end if;
				when swrl =>
					if (write_ready = '0') then
						write_s <= '0';
						state := swrh;
					end if;
				when others => null;
			end case;
		end if;
	END PROCESS;
	
END Behavior;
