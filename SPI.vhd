LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SPI IS
PORT(
	CK, MOSI, nSS, SCK : IN std_logic;
	DOUT : IN std_logic_vector(15 downto 0);
	A : OUT std_logic_vector(7 downto 0);
	DIN : OUT std_logic_vector(15 downto 0);
	MISO, RD, WR : OUT std_logic
	);
END ENTITY;

ARCHITECTURE behavior OF SPI IS

COMPONENT cu IS 
	PORT( 
		Ck, nSS, SCk, TC8, TC15	 : IN STD_LOGIC;
		State: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		RD, WR, LE, SE, SEC, SEA, SED, EC, RST, RST_SL : OUT STD_LOGIC
		);
END COMPONENT;

COMPONENT datapath IS
	PORT(
		CK : IN std_logic;
		MOSI, SEC, SEA, SED, SE, LE, EC, RST, RST_SL : IN std_logic;
		dout : IN std_logic_vector(15 downto 0);
		MISO, TC8, TC15 : OUT std_logic;
		state, A : OUT std_logic_vector(7 downto 0);
		din : OUT std_logic_vector(15 downto 0)
		);
END COMPONENT;

SIGNAL sec, sea, sed, se, le, ec, rst, rst_sl, tc0, tc8, tc15 : std_logic;
SIGNAL state : std_logic_vector(7 downto 0);

BEGIN

DP : datapath PORT MAP(
	CK => CK, 
	MOSI => MOSI, 
	SEC => sec, 
	SEA => sea, 
	SED => sed, 
	SE => se, 
	LE => le, 
	EC => ec, 
	RST => rst,  
	RST_SL => rst_sl,
	dout => DOUT,
	MISO => MISO,
	TC0 => tc0,
	TC8 => tc8,
	TC15 => tc15,
	state => state,
	A => A,
	din => DIN
	);

control_unit : cu PORT MAP( 
	Ck => CK, 
	nSS => nSS, 
	SCk => SCK, 
	TC0 => tc0,
	TC8 => tc8,
	TC15 => tc15,
	State => state,
	RD => RD, 
	WR  => WR, 
	LE => le,
	SE => se,
	SEC => sec,
	SEA => sea,
	SED => sed,
	EC => ec,
	RST => rst,
	RST_SL => rst_sl
	);

END ARCHITECTURE;