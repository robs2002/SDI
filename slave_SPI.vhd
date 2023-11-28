LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;

ENTITY slave_SPI IS
--PORT(CK, MOSI, nSS, SCK, RST_S : IN STD_LOGIC;MISO: OUT STD_LOGIC);
	port
	(
		-- Main clock inputs
		mainClk	: in std_logic;
		-- Logic state analyzer/stimulator
		lsasBus	: inout std_logic_vector( 3 downto 0 );
		-- Dip switches
		switches	: in std_logic_vector( 0 downto 0 );
		-- LEDs
		leds		: out std_logic_vector( 0 downto 0 )
	);
END slave_SPI;

ARCHITECTURE behavior OF slave_SPI IS

COMPONENT SPI IS
PORT(
	CK, MOSI, nSS, SCK, RST_S : IN STD_LOGIC;
	DOUT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	A : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	DIN : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	MISO, RD, WR : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT memory is
PORT(
  	 clk, RD, WRn : in STD_LOGIC;
	 address : in STD_LOGIC_VECTOR(7 DOWNTO 0);
 	 data_in : in STD_LOGIC_VECTOR(15 DOWNTO 0);
 	 data_out : out STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END COMPONENT;

SIGNAL DOUT, DIN : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL RD, WR, WRn :  STD_LOGIC;
SIGNAL A : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

WRn <= not WR;

mem : memory PORT MAP(mainClk, RD, WRn, A, DIN, DOUT);
spi1 :SPI PORT MAP(mainClk, lsasBus(0), lsasBus(1), lsasBus(2), switches(0), DOUT, A, DIN, lsasBus(3), RD, WR);

led: PROCESS (switches(0))
BEGIN
	IF (switches(0)='1') THEN
		leds(0) <= '1';
	ELSE
		leds(0) <= '0';
	END IF;
END PROCESS;

END behavior;
