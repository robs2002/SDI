LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CRCconSPI IS
PORT(
	CK, MOSI, nSS, SCK, RST_SW : IN std_logic;
	MISO : OUT std_logic
	);
END ENTITY;

ARCHITECTURE behavior OF CRCconSPI IS

COMPONENT SPI IS
PORT(
	CK, MOSI, nSS, SCK, RST_S : IN std_logic;
	DOUT : IN std_logic_vector(15 downto 0);
	A : OUT std_logic_vector(7 downto 0);
	DIN : OUT std_logic_vector(15 downto 0);
	MISO, RD, WR, RST_M : OUT std_logic
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

blocco_SPI : SPI PORT MAP(CK, MOSI, nSS, SCK, RST_SW, DOUT, add, DIN, MISO, RD, WR, OPEN);

blocco_CRC : CRC PORT MAP(CK, RST_SW, RD, WR, DIN, DOUT, add);

END ARCHITECTURE;