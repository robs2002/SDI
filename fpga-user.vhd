LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
LIBRARY lpm;
USE lpm.lpm_components.all;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY user IS
	PORT
	(
		-- Main clock inputs
		mainClk	: IN STD_LOGIC;
		slowClk	: IN STD_LOGIC;
		-- Main reset input
		reset		: IN STD_LOGIC;
		-- MCU interface (UART, I2C)
		mcuUartTx	: IN STD_LOGIC;
		mcuUartRx	: OUT STD_LOGIC;
		mcuI2cScl	: IN STD_LOGIC;
		mcuI2cSda	: INOUT STD_LOGIC;
		-- Logic state analyzer/stimulator
		lsasBus	: INOUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		-- Dip switches
		switches	: IN STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		-- LEDs
		leds		: OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 )
	);
END user;

ARCHITECTURE behavioural OF user IS

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
slv :SPI PORT MAP(mainClk, lsasBus(15), lsasBus(12), lsasBus(13), switches(0), DOUT, A, DIN, lsasBus(14), RD, WR);

test: PROCESS (switches(0))
BEGIN
	IF (switches(0)='1') THEN
		leds(0) <= '1';
	ELSE
		leds(0) <= '0';
	END IF;
END PROCESS;
	
END behavioural;
