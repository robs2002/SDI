library ieee;
USE ieee.std_logic_1164.all;

ENTITY cu IS 
PORT  ( Ck, nSS, SCk, TC0, TC8, TC15, RST_S : IN STD_LOGIC;
	State : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	RD, WR, LE, SE, SEC, SEA, SED, EC, RST, RST_SL, RST_M : OUT STD_LOGIC
 );
END cu;

ARCHITECTURE Behavioral OF cu IS

TYPE State_type IS ( IDLE, WAITSS, WAITSCK, SCKH_C, SCKL0_C, SCKL1_C, SCKH_A, SCKL0_A, SCKL1_A, SCKL0_W,
		     SCKH_DIN, SCKL0_DIN, SCKL1_DIN, S_WRITE, S_READ, LOAD, SCKL_DOUT, SCKH0_DOUT, SCKH1_DOUT ); 

SIGNAL present_state: State_type;
SIGNAL next_state: State_type;

BEGIN

-- processo per gli stati futuri
transitions: PROCESS(present_state, TC0, TC8, TC15, State, SCk)
BEGIN
	CASE present_state IS
	WHEN IDLE => next_state <= WAITSS;
	WHEN WAITSS => IF (SCk='0') THEN next_state <= WAITSCK; ELSE next_state <= WAITSS; END IF;
	WHEN WAITSCK => IF (SCk='1') THEN next_state <= SCKH_C; ELSE next_state <= WAITSCK; END IF;
	WHEN SCKH_C => IF (SCk='0') THEN next_state <= SCKL0_C; ELSE next_state <= SCKH_C; END IF;
	WHEN SCKL0_C => next_state <= SCKL1_C;
	WHEN SCKL1_C => IF (SCk='1' AND TC8='1') THEN next_state <= SCKH_A; ELSIF (SCk='1' AND TC8='0') THEN next_state <= SCKH_C; ELSE next_state <=SCKL1_C ; END IF;
	WHEN SCKH_A => IF (SCk='0') THEN next_state <= SCKL0_A; ELSE next_state <= SCKH_A; END IF;
	WHEN SCKL0_A => IF (State="00100000" AND TC15='1') THEN next_state <= SCKL0_W; ELSIF (State="00100001" AND TC15='1') THEN next_state <= S_READ; ELSE next_state <=SCKL1_A ; END IF;
	WHEN SCKL1_A => IF (SCk='1') THEN next_state <= SCKH_A; ELSE next_state <= SCKL1_A; END IF;
	WHEN SCKL0_W => IF (SCk='1') THEN next_state <= SCKH_DIN; ELSE next_state <= SCKL0_W; END IF;
	WHEN SCKH_DIN => IF (SCk='0') THEN next_state <= SCKL0_DIN; ELSE next_state <= SCKH_DIN; END IF;
	WHEN SCKL0_DIN => IF (TC15='0') THEN next_state <= SCKL1_DIN; ELSE next_state <= S_WRITE; END IF;
	WHEN SCKL1_DIN => IF (SCk='1') THEN next_state <= SCKH_DIN; ELSE next_state <= SCKL1_DIN; END IF;
	WHEN S_WRITE => next_state <= WAITSCK;
	WHEN S_READ => next_state <= LOAD; 
	WHEN LOAD => next_state <= SCKL_DOUT; 
	WHEN SCKL_DOUT => IF (SCk='1') THEN next_state <= SCKH0_DOUT; ELSE next_state <= SCKL_DOUT; END IF;
	WHEN SCKH0_DOUT => next_state <= SCKH1_DOUT; 
	WHEN SCKH1_DOUT => IF (SCk='0' AND TC0='0') THEN next_state <= SCKL_DOUT; ELSIF (SCk='0' AND TC0='1') THEN next_state <= WAITSCK; ELSE next_state <= SCKH1_DOUT; END IF;
	WHEN OTHERS => next_state <= IDLE;
	END CASE;
END PROCESS;

-- processo per la transizione ps, ns
registers: PROCESS(Ck,RST_S)
BEGIN  
	IF (RST_S='1') THEN		-- reset asincrono
		present_state <= IDLE;
	ELSE
		IF (Ck'event and Ck='1') THEN
			IF (nSS='1') THEN
				present_state <= WAITSS;
			ELSE
				present_state <= next_state;
			END IF;	
		END IF;
	END IF;
END PROCESS;

-- processo per gestione dei segnali
output: PROCESS(present_state)
BEGIN

	RD<='0'; WR<='0'; LE<='0'; SE<='0'; SEC<='0'; SEA<='0'; SED<='0'; EC<='0'; RST<='0'; RST_SL<='0'; RST_M<='0';


	CASE present_state IS
	WHEN IDLE => RST<='1'; RST_SL<='1'; RST_M<='1';
	WHEN WAITSS =>
	WHEN WAITSCK => RST<='1';
	WHEN SCKH_C => RST_SL<='1';
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
	WHEN S_READ => RD<='1';
	WHEN LOAD => LE<='1';
	WHEN SCKL_DOUT => 
	WHEN SCKH0_DOUT => SE<='1'; EC<='1';
	WHEN SCKH1_DOUT => 
	WHEN OTHERS => 
	END CASE;

END PROCESS;

END Behavioral;




	

