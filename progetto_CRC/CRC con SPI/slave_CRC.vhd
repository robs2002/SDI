LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
LIBRARY lpm;
USE lpm.lpm_components.all;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY slave_CRC IS
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
END slave_CRC;

ARCHITECTURE behavioural OF slave_CRC IS

COMPONENT SPI IS
PORT(
	CK, MOSI, nSS, SCK, RST_S : IN STD_LOGIC;
	DOUT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	A : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	DIN : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	MISO, RD, WR, RST_M : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT CRC IS
PORT(
	CLK, RST_SW : IN std_logic;
	RD, WR : IN std_logic;
	mosi : IN std_logic_vector(15 downto 0);
	miso : OUT std_logic_vector(15 downto 0);
	add : IN std_logic_vector(7 downto 0)
	);
END COMPONENT;

SIGNAL RD, WR : std_logic;
SIGNAL add : std_logic_vector(7 downto 0);
SIGNAL DIN, DOUT : std_logic_vector(15 downto 0);
	
BEGIN

blocco_SPI :SPI PORT MAP(mainClk, lsasBus(15), lsasBus(12), lsasBus(13), switches(0), DOUT, add, DIN, lsasBus(14), RD, WR,open);
blocco_CRC : CRC PORT MAP(mainClk, switches(0), RD, WR, DIN, DOUT, add);

test: PROCESS (switches(0))
BEGIN
	IF (switches(0)='1') THEN
		leds(0) <= '1';
	ELSE
		leds(0) <= '0';
	END IF;
END PROCESS;
	
END behavioural;
