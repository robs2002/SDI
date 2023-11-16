library ieee;
USE ieee.std_logic_1164.all;

ENTITY cu IS 
PORT  ( Ck, nSS, SCk, TC8, TC15	 : IN STD_LOGIC;
	State: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	RD, WR, LE, SE, SEC, SEA, SED, EC, RST : OUT STD_LOGIC
 );
END cu;

ARCHITECTURE Behavioral OF cu IS

TYPE State_type IS ( IDLE, WAITSCK, SCKH_C, SCKL0_C, SCKL1_C, SCKH_A, SCKL0_A, SCKL1_A, SCKL0_W,
		     SCKH_DIN, SCKL0_DIN, SCKL1_DIN, S_WRITE, S_READ, LOAD, SCKL_DOUT, SCKH0_DOUT, SCKH1_DOUT, S_WAIT ); 

SIGNAL present_state: State_type;
SIGNAL next_state: State_type;

BEGIN

transitions: PROCESS(present_state, nSS, TC8, TC15, State)
BEGIN
	CASE present_state IS
	WHEN IDLE => IF (nSS='0' AND SCk='0') THEN next_state <= WAITSCK; ELSE next_state <= IDLE; END IF;
	WHEN WAITSCK => IF (SCk='1') THEN next_state <= SCKH_C; ELSE next_state <= WAITSCK; END IF;
	WHEN SCKH_C => IF (SCk='0') THEN next_state <= SCKL0_C; ELSE next_state <= SCKH_C; END IF;
	WHEN SCKL0_C => next_state <= SCKL1_C;
	WHEN SCKL1_C => IF (SCk='1' AND TC8='1') THEN next_state <= SCKH_A; ELSIF (SCk='1' AND TC8='0') THEN next_state <= SCKH_C; ELSE next_state <=SCKL1_C ; END IF;
	WHEN SCKH_A => IF (SCk='0') THEN next_state <= SCKL0_A; ELSE next_state <= SCKH_A; END IF;
	WHEN SCKL0_A => IF (State="00100000" AND TC15='1') THEN next_state <= SCKH_DIN; ELSIF (State="00100001" AND TC15='1') THEN next_state <= S_READ; ELSE next_state <=SCKL1_A ; END IF;
	WHEN SCKL1_A => IF (SCk='1') THEN next_state <= SCKL0_W; ELSE next_state <= SCKL1_A; END IF;
	WHEN SCKL0_W => IF (SCk='1') THEN next_state <= SCKH_DIN; ELSE next_state <= SCKL0_W; END IF;
	WHEN SCKH_DIN => IF (nSS='0' AND SCk='0') THEN next_state <= WAITSCK; ELSE next_state <= IDLE; END IF;
	WHEN SCKL0_DIN => next_state <= SCKL1_DIN; 
	WHEN SCKL1_DIN => IF (SCk='1') THEN next_state <= SCKH_DIN; ELSE next_state <= SCKL0_W; END IF;
	WHEN S_WRITE => next_state <= S_WAIT;
	WHEN S_WAIT => IF (nSS='1') THEN next_state <= IDLE; ELSE next_state <= S_WAIT; END IF;
	WHEN S_READ => next_state <= LOAD; 
	WHEN LOAD => next_state <= SCKL_DOUT; 
	WHEN SCKL_DOUT => IF (SCk='1') THEN next_state <= SCKH0_DOUT; ELSE next_state <= SCKL_DOUT; END IF;
	WHEN SCKH0_DOUT => IF (TC15='1') THEN next_state <= S_WAIT; ELSE next_state <= SCKH1_DOUT; END IF;
	WHEN SCKH1_DOUT => IF (SCk='1') THEN next_state <= SCKH1_DOUT; ELSE next_state <= SCKL_DOUT; END IF;
	WHEN OTHERS => next_state <= IDLE;
	END CASE;
END PROCESS;

registers: PROCESS(Ck)
BEGIN 
	IF (Ck'event and Ck='1') THEN
		IF (nSS='1') THEN
			present_state <= IDLE;
		ELSE
			present_state <= next_state;
		END IF;	
	END IF;
END PROCESS;

output: PROCESS(present_state)
BEGIN

	RD<='0'; WR<='0'; LE<='0'; SE<='0'; SEC<='0'; SEA<='0'; SED<='0'; EC<='0'; RST<='0';

	CASE present_state IS
	WHEN IDLE => RST<='1';
	WHEN WAITSCK => 
	WHEN SCKH_C => 
	WHEN SCKL0_C => SEC<='1'; EC<='1';
	WHEN SCKL1_C => 
	WHEN SCKH_A => 
	WHEN SCKL0_A => SEA<='1'; EC<='1';
	WHEN SCKL1_A => 
	WHEN SCKL0_W => 
	WHEN SCKH_DIN => 
	WHEN SCKL0_DIN => SED<='1'; EC<='1';
	WHEN SCKL1_DIN => 
	WHEN S_WRITE => WR<='1';
	WHEN S_WAIT => 
	WHEN S_READ => RD<='1';
	WHEN LOAD => LE<='1';
	WHEN SCKL_DOUT => 
	WHEN SCKH0_DOUT => SED<='1'; EC<='1';
	WHEN SCKH1_DOUT => 
	WHEN OTHERS => 
	END CASE;

END PROCESS;

END Behavioral;




	

