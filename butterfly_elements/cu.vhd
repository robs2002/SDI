LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY cu IS
PORT (
           Start, Clock, Reset : IN STD_LOGIC;
	   Done, C, Rst, mux_pa, mux_m2, mux_s1, mux_ra, en1, en2, en3, en4, en5, en6, en7, en8, en9, en10, en11 : OUT STD_LOGIC;
	   mux_m1, mux_a, mux_s2: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
);
END cu;

ARCHITECTURE Behavior OF cu IS

TYPE State_type IS (IDLE, SW, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11);

SIGNAL present_state: State_type;
SIGNAL next_state: State_type;

BEGIN

transitions: PROCESS(present_state, Start)
	BEGIN
	CASE present_state IS
		WHEN IDLE => next_state <= SW;
		WHEN SW => IF(Start='1') THEN next_state <= S1; ELSE next_state <= SW; END IF;
		WHEN S1 => next_state <= S2;
		WHEN S2 => next_state <= S3;
		WHEN S3 => next_state <= S4;
		WHEN S4 => next_state <= S5;
		WHEN S5 => next_state <= S6;
		WHEN S6 => next_state <= S7;
		WHEN S7 => next_state <= S8;
		WHEN S8 => next_state <= S9;
		WHEN S9 => next_state <= S10;
		WHEN S10 => next_state <= S11;
		WHEN S11 => next_state <= SW;
		WHEN OTHERS =>  next_state <= IDLE;
	END CASE;
END PROCESS;

registers: PROCESS(Clock, Reset)
		BEGIN
		IF (Reset='1') THEN
			present_state <= IDLE;
		ELSIF (Clock'EVENT AND Clock='1') THEN
			present_state <= next_state;
		END IF;
	   END PROCESS;

output: PROCESS(present_state)
	BEGIN
	Done<='0'; C<='0'; Rst<='0'; mux_pa<='0'; mux_m2<='0'; mux_s1<='0'; mux_ra<='0'; 
	en1<='0'; en2<='0'; en3<='0'; en4<='0'; en5<='0'; en6<='0'; en7<='0'; en8<='0'; en9<='0'; en10<='0'; en11<='0';
	mux_m1<="00"; mux_a<="00"; mux_s2<="00";

	CASE present_state IS
		WHEN IDLE => Rst<='1'; 
		WHEN SW => 
		WHEN S1 => en1<='1'; en3<='1'; en5<='1';
		WHEN S2 => en2<='1'; en4<='1'; en6<='1'; C<='0'; mux_m1<="10"; mux_m2<='0';
		WHEN S3 => C<='0'; mux_m1<="11"; mux_m2<='1';
		WHEN S4 => en7<='1'; C<='0'; mux_m1<="10"; mux_m2<='1';
		WHEN S5 => en7<='1'; C<='0'; mux_m1<="11"; mux_m2<='0'; mux_a<="01";
		WHEN S6 => en7<='1'; en8<='1'; mux_m1<="00"; mux_a<="10"; 
		WHEN S7 => en7<='1'; en8<='1'; mux_s1<='0'; mux_s2<="10"; mux_m1<="01"; C<='1';
		WHEN S8 => en9<='1'; en10<='1'; mux_a<="00"; C<='1';
		WHEN S9 => en8<='1'; en9<='1'; mux_s1<='1'; mux_s2<="00"; en11<='1';
		WHEN S10 => en10<='1'; mux_s1<='1'; mux_s2<="01";
		WHEN S11 => en10<='1'; Done<='1'; mux_ra<='1';
		WHEN OTHERS => 
	END CASE;
	END PROCESS;

END Behavior;









