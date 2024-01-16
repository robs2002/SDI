LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY cu_crc IS
PORT(
	CLK, RST_SW, TC, RB, En0, mode_bit : IN std_logic;
	RST, RST_reg1, RST_reg5, RST_CNT, LD, SE, CE, En1, En2_cu, En3, En4, En5, SB_IN, s_mux, s_crc : OUT std_logic
	);
END ENTITY;

ARCHITECTURE behavior OF cu_crc IS

TYPE state IS (RST_S, IDLE, LOAD_0, REG_DATA, SHIFT_0, CRC_OUT, LOAD_1, SHIFT_1, CRC_RST);

SIGNAL present_state, next_state : state;

BEGIN

transitions: PROCESS(present_state, TC, RB, En0, mode_bit)
BEGIN
	CASE present_state IS
	WHEN RST_S => next_state <= IDLE;
	WHEN IDLE => IF (En0='1' AND mode_bit='0') THEN next_state <= LOAD_0; ELSIF (En0='1' AND mode_bit='1') THEN next_state <= LOAD_1; ELSIF (RB='1') THEN next_state <= CRC_RST; ELSE next_state <= IDLE; END IF;
	WHEN LOAD_0 => next_state <= REG_DATA;
	WHEN REG_DATA => next_state <= SHIFT_0;
	WHEN SHIFT_0 => IF (TC='1') THEN next_state <= CRC_OUT; ELSE next_state <= SHIFT_0; END IF;
	WHEN CRC_OUT => next_state <= IDLE;
	WHEN LOAD_1 => next_state <= SHIFT_1;
	WHEN SHIFT_1 => IF (TC='1') THEN next_state <= REG_DATA; ELSE next_state <= SHIFT_1; END IF;
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
	RST<='0'; RST_reg1<='0'; RST_reg5<='0'; RST_CNT<='0'; LD<='0'; SE<='0'; CE<='0'; En1<='0'; En2_cu<='0'; En3<='0'; En4<='0'; En5<='0'; SB_IN<='0'; s_mux<='0'; s_crc<='0';

	CASE present_state IS
	WHEN RST_S => RST<='1'; RST_reg1<='1'; RST_reg5<='1'; RST_CNT<='1';
	WHEN IDLE =>
	WHEN LOAD_0 => LD<='1'; SB_IN<='0'; En3<='1'; RST_CNT<='1'; En5<='1'; s_crc<='0';
	WHEN REG_DATA => En4<='1';
	WHEN SHIFT_0 => SE<='1'; CE<='1';
	WHEN CRC_OUT => En1<='1'; SB_IN<='1'; En3<='1';
	WHEN LOAD_1 => LD<='1'; SB_IN<='0'; En3<='1'; RST_CNT<='1'; s_crc<='1';
	WHEN SHIFT_1 => SE<='1'; CE<='1';
	WHEN CRC_RST => RST_reg1<='1'; s_mux<='1'; En2_cu<='1'; RST_reg5<='1';
	WHEN OTHERS => 
	END CASE;

END PROCESS;

END ARCHITECTURE;