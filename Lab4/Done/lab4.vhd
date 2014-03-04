library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab4 is
  port(CLOCK_50            : in  std_logic;
       KEY                 : in  std_logic_vector(3 downto 0);
       SW                  : in  std_logic_vector(17 downto 0);
       VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0);  -- The outs go to VGA controller
       VGA_HS              : out std_logic;
       VGA_VS              : out std_logic;
       VGA_BLANK           : out std_logic;
       VGA_SYNC            : out std_logic;
       VGA_CLK             : out std_logic);
end lab4;

architecture rtl of lab4 is

 --Component from the Verilog file: vga_adapter.v

  component vga_adapter
    generic(RESOLUTION : string);
    port (resetn                                       : in  std_logic;
          clock                                        : in  std_logic;
          colour                                       : in  std_logic_vector(2 downto 0);
          x                                            : in  std_logic_vector(7 downto 0);
          y                                            : in  std_logic_vector(6 downto 0);
          plot                                         : in  std_logic;
          VGA_R, VGA_G, VGA_B                          : out std_logic_vector(9 downto 0);
          VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK : out std_logic);
  end component;
  
  TYPE state_types is (sr, sy, sx, sdone);
  SIGNAL state : state_types := sr;

  signal x      : std_logic_vector(7 downto 0) := "00000000";
  signal y      : std_logic_vector(6 downto 0) := "0000000";
  signal colour : std_logic_vector(2 downto 0) := "111";
  signal plot   : std_logic;
  
  signal inity, initx : std_logic;
  signal xdone, ydone : std_logic;
  signal loady : std_logic;

  
begin

  -- includes the vga adapter, which should be in your project 

  vga_u0 : vga_adapter
    generic map(RESOLUTION => "160x120") 
    port map(resetn    => KEY(3),
             clock     => CLOCK_50,
             colour    => colour,
             x         => x,
             y         => y,
             plot      => plot,
             VGA_R     => VGA_R,
             VGA_G     => VGA_G,
             VGA_B     => VGA_B,
             VGA_HS    => VGA_HS,
             VGA_VS    => VGA_VS,
             VGA_BLANK => VGA_BLANK,
             VGA_SYNC  => VGA_SYNC,
             VGA_CLK   => VGA_CLK);


	PROCESS(CLOCK_50, KEY(3))
	VARIABLE next_state : state_types;
	BEGIN
		IF (KEY(3) = '0') THEN
			state <= sr;
		ELSIF rising_edge(CLOCK_50) THEN
			CASE state IS
				WHEN sr => 
					INITX <= '1';
					INITY <= '1';
					LOADY <= '1';
					PLOT <= '0';
					next_state := sx;
				WHEN sy => 
					INITX <= '1';
					INITY <= '0';
					LOADY <= '1';
					PLOT <= '0';
					next_state := sx;
				WHEN sx => 
					INITX <= '0';
					INITY <= '0';
					LOADY <= '0';
					PLOT <= '1';
					IF (XDONE = '0') THEN
						next_state := sx;
					ELSIF (XDONE = '1' AND YDONE = '0') THEN
						next_state := sy;
					ELSE 
						next_state := sdone;
					END IF;
				WHEN others => 
					PLOT <= '0';
					next_state := sdone;
			END CASE;
			state <= next_state;
		END IF;
	END PROCESS;
	
	PROCESS(CLOCK_50)
	VARIABLE y_tmp : unsigned(6 downto 0) := "0000000";
	VARIABLE x_tmp : unsigned(7 downto 0) := "00000000";
	BEGIN
		IF rising_edge(CLOCK_50) THEN
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
	END PROCESS;


end RTL;


