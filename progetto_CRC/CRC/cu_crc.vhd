LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY cu_crc IS
PORT(
	CLK, RST_SW, TC, RB, En0 : IN std_logic;
	RST, RST_reg1, RST_CNT, LD, SE, CE, En1, En2_cu, En3, SB_IN, s_mux : OUT std_logic
	);
END ENTITY;

ARCHITECTURE behavior OF cu_crc IS

TYPE state IS (RST_S, IDLE, LOAD, SHIFT, CRC_OUT, CRC_RST);

SIGNAL present_state, next_state : state;

BEGIN

transitions: PROCESS(present_state, TC, RB, En0)
BEGIN
	CASE present_state IS
	WHEN RST_S => next_state <= IDLE;
	WHEN IDLE => IF (En0='1') THEN next_state <= LOAD; ELSIF (RB='1') THEN next_state <= CRC_RST; ELSE next_state <= IDLE; END IF;
	WHEN LOAD => next_state <= SHIFT;
	WHEN SHIFT => IF (TC='1') THEN next_state <= CRC_OUT; ELSE next_state <= SHIFT; END IF;
	WHEN CRC_OUT => next_state <= IDLE;
	WHEN CRC_RST => next_state <= IDLE;
	WHEN OTHERS => next_state <= IDLE;
	END CASE;
END PROCESS;

registers: PROCESS(CLK,RST_SW)
BEGIN  
	IF (RST_SW='1') THEN
		present_state <= RST_S;
	ELSE
		IF (CLK'event and CLK='1') THEN
			present_state <= next_state;
		END IF;
	END IF;
END PROCESS;

output: PROCESS(present_state)
BEGIN
	RST<='0'; RST_reg1<='0'; RST_CNT<='0'; LD<='0'; SE<='0'; CE<='0'; En1<='0'; En2_cu<='0'; En3<='0'; SB_IN<='0'; s_mux<='0';

	CASE present_state IS
	WHEN RST_S => RST<='1'; RST_reg1<='1'; RST_CNT<='1';
	WHEN IDLE =>
	WHEN LOAD => LD<='1'; SB_IN<='0'; En3<='1'; RST_CNT<='1';
	WHEN SHIFT => SE<='1'; CE<='1';
	WHEN CRC_OUT => En1<='1'; SB_IN<='1'; En3<='1';
	WHEN CRC_RST => RST_reg1<='1'; s_mux<='1'; En2_cu<='1';
	WHEN OTHERS => 
	END CASE;

END PROCESS;

END ARCHITECTURE;