LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY datapath IS
PORT(
	CK : IN STD_LOGIC;
	MOSI, SEC, SEA, SED, SE, LE, EC, RST, RST_SL : IN STD_LOGIC;
	dout : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	MISO, TC0, TC8, TC15 : OUT STD_LOGIC;
	state, A : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	din : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE behavior OF datapath IS

COMPONENT counter IS
	GENERIC ( N: INTEGER:= 10);
	PORT ( 
		Enable, Clock,Reset: IN STD_LOGIC;
		Q: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
		);
END COMPONENT;

COMPONENT reg IS
	GENERIC (N : INTEGER:=16); 
	PORT (
		Clock,Reset,Enable,R : IN STD_LOGIC; 
		Q : BUFFER STD_LOGIC_VECTOR(N-1 DOWNTO 0)
		);
END COMPONENT;

COMPONENT  reg_load IS
	GENERIC (N : INTEGER:=16); 
	PORT ( DOUT : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	Clock,Reset,Load,Enable: IN STD_LOGIC; 
	R: OUT STD_lOGIC
	);
END COMPONENT;


SIGNAL cnt : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

shift_register_state : reg GENERIC MAP(8) PORT MAP(CK, RST, SEC, MOSI, state);
		
shift_register_address : reg GENERIC MAP(8) PORT MAP(CK, RST, SEA, MOSI, A);
		
shift_register_din : reg GENERIC MAP(16) PORT MAP(CK, RST, SED, MOSI, din);
		
shift_register_load_dout : reg_load GENERIC MAP(16) PORT MAP(dout, CK, RST_SL, LE, SE, MISO);
		
contatore : counter GENERIC MAP (4) PORT MAP(EC, CK, RST, cnt);
		
TC0 <= '1' WHEN (cnt = "0000" ) ELSE '0';	
TC8 <= '1' WHEN (cnt = "1000" ) ELSE '0';	
TC15 <= '1' WHEN (cnt = "1111" ) ELSE '0';

END ARCHITECTURE;


