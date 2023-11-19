library IEEE;
use IEEE.std_logic_1164.all;

ENTITY datapath IS
PORT(
	CK : IN std_logic;
	MOSI, SEC, SEA, SED, SE, LE, EC, RST_C, RST_S, RST_A, RST_DIN, RST_DOUT : IN std_logic;
	dout : IN std_logic_vector(15 downto 0);
	MISO, TC8, TC15 : OUT std_logic;
	state, A : OUT std_logic_vector(7 downto 0);
	din : OUT std_logic_vector(15 downto 0)
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
	GENERIC (N : integer:=16); 
	PORT (
		Clock,Reset,Enable,R : IN STD_LOGIC; 
		Q : BUFFER STD_LOGIC_VECTOR(N-1 DOWNTO 0)
		);
END COMPONENT;

COMPONENT  reg_load IS
	GENERIC (N : integer:=16); 
	PORT ( DOUT : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	Clock,Reset,Load,Enable: IN STD_LOGIC; 
	R: OUT STD_lOGIC
	);
END COMPONENT;


SIGNAL cnt : std_logic_vector(3 downto 0);
SIGNAL slq : std_logic_vector(15 downto 0);

BEGIN

shift_register_state : reg GENERIC MAP(8)
	PORT MAP(
		Clock => CK,
		Reset => RST_S,
		Enable => SEC,
		R => MOSI,
		Q => state
		);
		
shift_register_address : reg GENERIC MAP(8)
	PORT MAP(
		Clock => CK,
		Reset => RST_A,
		Enable => SEA,
		R => MOSI,
		Q => A
		);
		
shift_register_din : reg GENERIC MAP(16)
	PORT MAP(
		Clock => CK,
		Reset => RST_DIN,
		Enable => SED,
		R => MOSI,
		Q => din
		);
		
shift_register_load_dout : reg_load GENERIC MAP(16)
	PORT MAP( 
		DOUT => dout,
		Clock => CK,
		Reset => RST_DOUT,
		Load => LE,
		Enable => SE, 
		R => MISO
		);
		
contatore : counter GENERIC MAP (4)
	PORT MAP( 
		Enable => EC,
		Clock => CK,
		Reset => RST_C,
		Q => cnt
		);
		
TC8 <= '1' when (cnt = "1000" ) else '0';	
TC15 <= '1' when (cnt = "1111" ) else '0';

END ARCHITECTURE;


