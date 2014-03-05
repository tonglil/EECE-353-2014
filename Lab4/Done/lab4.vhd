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

 -- Component from the Verilog file: vga_adapter.v
	component vga_adapter
		generic(RESOLUTION : string);
		port (
			 resetn                                       : in  std_logic;
			 clock                                        : in  std_logic;
			 colour                                       : in  std_logic_vector(2 downto 0);
			 x                                            : in  std_logic_vector(7 downto 0);
			 y                                            : in  std_logic_vector(6 downto 0);
			 plot                                         : in  std_logic;
			 VGA_R, VGA_G, VGA_B                          : out std_logic_vector(9 downto 0);
			 VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK : out std_logic);
	  end component;
  
	component statemachine is
		PORT (				
			clk : IN STD_LOGIC;
			resetb : IN STD_LOGIC;
			xdone, ydone : IN STD_LOGIC;
			initx, inity, loady, plot : OUT STD_LOGIC
		);
	end component;
	
	component datapath is
		PORT (
			clk : IN STD_LOGIC;
			resetb : IN STD_LOGIC;
			initx, inity, loady : IN STD_LOGIC;
			x : OUT STD_LOGIC_VECTOR(7 downto 0);
			y : OUT STD_LOGIC_VECTOR(6 downto 0);
			xdone, ydone : OUT STD_LOGIC
		);
	end component;

  signal x      : std_logic_vector(7 downto 0) := "00000000";
  signal y      : std_logic_vector(6 downto 0) := "0000000";
  signal colour : std_logic_vector(2 downto 0) := "111";
  signal plot   : std_logic;
  
  signal inity, initx : std_logic;
  signal xdone, ydone : std_logic;
  signal loady : std_logic;

  
begin

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

	dp : datapath PORT MAP(
		resetb	=> KEY(3),
		clk		=> CLOCK_50,
		initx		=> initx,
		inity		=> inity,
		x			=> x,
		y			=> y,
		xdone		=> xdone,
		ydone		=> ydone,
		loady		=> loady
	);
	
	sm : statemachine PORT MAP(
		clk		=> CLOCK_50,
		resetb	=> KEY(3),
		xdone		=> xdone,
		ydone		=> ydone,
		initx		=> initx,
		inity		=> inity,
		loady		=> loady,
		plot		=> plot
	);

end rtl;