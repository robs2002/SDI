LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SPI IS
PORT(
	CK, MOSI, nSS, SCK, RST_S : IN std_logic;
	DOUT : IN std_logic_vector(15 downto 0);
	A : OUT std_logic_vector(7 downto 0);
	DIN : OUT std_logic_vector(15 downto 0);
	MISO, RD, WR, RST_M : OUT std_logic
	);
END ENTITY;

ARCHITECTURE behavior OF SPI IS

COMPONENT cu IS 
	PORT( 
		Ck, nSS, SCk, TC0, TC8, TC15, RST_S : IN STD_LOGIC;
		State: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		RD, WR, LE, SE, SEC, SEA, SED, EC, RST, RST_SL, RST_M : OUT STD_LOGIC
		);
END COMPONENT;

COMPONENT datapath IS
	PORT(
		CK : IN std_logic;
		MOSI, SEC, SEA, SED, SE, LE, EC, RST, RST_SL : IN std_logic;
		dout : IN std_logic_vector(15 downto 0);
		MISO, TC0, TC8, TC15 : OUT std_logic;
		state, A : OUT std_logic_vector(7 downto 0);
		din : OUT std_logic_vector(15 downto 0)
		);
END COMPONENT;

SIGNAL sec, sea, sed, se, le, ec, rst, rst_sl, tc0, tc8, tc15 : std_logic;
SIGNAL state : std_logic_vector(7 downto 0);

BEGIN

DP : datapath PORT MAP(CK, MOSI, sec, sea, sed, se, le, ec, rst, rst_sl, DOUT, MISO, tc0, tc8, tc15, state, A, DIN);

control_unit : cu PORT MAP(CK, nSS, SCK, tc0, tc8, tc15, rst_s, state, RD, WR, le, se, sec, sea, sed, ec, rst, rst_sl, RST_M);

END ARCHITECTURE;