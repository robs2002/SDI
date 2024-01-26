library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library lpm;
use lpm.lpm_components.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity user is
	port
	(
		-- Main clock inputs
		mainClk	: in std_logic;
		slowClk	: in std_logic;
		-- Main reset input
		reset		: in std_logic;
		-- MCU interface (UART, I2C)
		mcuUartTx	: in std_logic;
		mcuUartRx	: out std_logic;
		mcuI2cScl	: in std_logic;
		mcuI2cSda	: inout std_logic;
		-- Logic state analyzer/stimulator
		lsasBus	: inout std_logic_vector( 31 downto 0 );
		-- Dip switches
		switches	: in std_logic_vector( 7 downto 0 );
		-- LEDs
		leds		: out std_logic_vector( 3 downto 0 )
	);
end user;

architecture behavioural of user is

	signal clk: std_logic;
	signal pllLock: std_logic;

	signal lsasBusIn: std_logic_vector( 31 downto 0 );
	signal lsasBusOut: std_logic_vector( 31 downto 0 );
	signal lsasBusEn: std_logic_vector( 31 downto 0 ) := ( others => '0' );

	signal mcuI2cDIn: std_logic;
	signal mcuI2CDOut: std_logic;
	signal mcuI2cEn: std_logic := '0';	

	component myAltPll
		PORT
		(
			areset		: IN STD_LOGIC  := '0';
			inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC ;
			locked		: OUT STD_LOGIC 
		);
	end component;

-- componenti progetto CRC
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
	
begin

--**********************************************************************************
--* Main clock PLL
--**********************************************************************************

	myAltPll_inst : myAltPll PORT MAP (
		areset	 => reset,
		inclk0	 => mainClk,
		c0	 => clk,
		locked	 => pllLock
	);

--**********************************************************************************
--* LEDs
--**********************************************************************************

	leds <= switches( 3 downto 0 );
	
--**********************************************************************************
--* 		lsasBus	: inout std_logic_vector( 31 downto 0 )
--**********************************************************************************

	lsasBusIn <= lsasBus;

	lsasBus_tristate:
	process( lsasBusEn, lsasBusOut ) is
	begin
		for index in 0 to 31 loop
			if lsasBusEn( index ) = '1'  then
				lsasBus( index ) <= lsasBusOut ( index );
			else
				lsasBus( index ) <= 'Z';
			end if;
		end loop;
	end process;

	-- progetto CRC
	blocco_SPI :SPI PORT MAP(mainClk, lsasBus(15), lsasBus(12), lsasBus(13), switches(0), DOUT, add, DIN, lsasBus(14), RD, WR,open);
	blocco_CRC : CRC PORT MAP(mainClk, switches(0), RD, WR, DIN, DOUT, add);
	
	
end behavioural;
