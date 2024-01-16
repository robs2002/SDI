LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY sequencer IS
PORT(
  Start, Clock, Rst_e : IN STD_LOGIC;
  Done, C, mux_m2, mux_s1, mux_ra, en1, en2, en3, en4, en5, en6, en7, en8, en9, en10, en11 : OUT STD_LOGIC;
  mux_m1, mux_a, mux_s2: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
);
END sequencer;

ARCHITECTURE Behavioral OF sequencer IS

COMPONENT microrom IS
PORT(
  address : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  data_out : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)
);
END COMPONENT;

SIGNAL cc1, cc2, sel: STD_LOGIC;
SIGNAL jump_add, add : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL d_out, instructions : STD_LOGIC_VECTOR(27 DOWNTO 0);

BEGIN

uar: PROCESS (Clock, Rst_e)
	BEGIN
		IF (Rst_e='1') THEN
			add <= (others => '0');
		ELSIF (Clock'EVENT AND Clock='1') THEN
			IF (sel='1') THEN
				add <= jump_add;
			ELSE
				add <= STD_LOGIC_VECTOR(UNSIGNED(add)+1);
			END IF;
		END IF;
END PROCESS;

urom: microrom PORT MAP (add, d_out); 

uir: PROCESS (Clock)
	BEGIN
		IF (Clock'EVENT AND Clock='0') THEN
			instructions <= d_out;
		END IF;
END PROCESS;

cc2 <= instructions(27);
cc1 <= instructions(26);
Done <= instructions(25);
C <= instructions(24);
mux_m1 <= instructions(23 DOWNTO 22);
mux_m2 <= instructions(21);
mux_a <= instructions(20 DOWNTO 19);
mux_s1 <= instructions(18);
mux_s2 <= instructions(17 DOWNTO 16);
mux_ra <= instructions(15);
en1 <= instructions(14);
en2 <= instructions(13);
en3 <= instructions(12);
en4 <= instructions(11);
en5 <= instructions(10);
en6 <= instructions(9);
en7 <= instructions(8);
en8 <= instructions(7);
en9 <= instructions(6);
en10 <= instructions(5);
en11 <= instructions(4);
jump_add <= instructions(3 DOWNTO 0);

status_pla: PROCESS (cc1, cc2, Start)
	BEGIN
		IF (cc1='1') THEN
			IF (Start ='0') THEN
				sel <='1';
			ELSE
				sel <='0';
			END IF;
		ELSIF (cc2='1') THEN 
			sel <='1';
		ELSE
			sel <='0';
		END IF;
END PROCESS;

END Behavioral;
