LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY sequencer IS
PORT(
  Start, Clock : IN STD_LOGIC;
  Done, C, Rst, mux_m2, mux_s1, mux_ra, en1, en2, en3, en4, en5, en6, en7, en8, en9, en10, en11 : OUT STD_LOGIC;
  mux_m1, mux_a, mux_s2: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
);
END sequencer;

ARCHITECTURE Behavioral OF sequencer IS

COMPONENT microrom IS
PORT(
  address : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  data_out : OUT STD_LOGIC_VECTOR(28 DOWNTO 0)
);
END COMPONENT;

SIGNAL cc1, cc2, sel: STD_LOGIC;
SIGNAL add_c, jump_add, add : STD_LOGIC_VECTOR(3 DOWNTO 0):= (others => '0');
SIGNAL d_out : STD_LOGIC_VECTOR(28 DOWNTO 0);

BEGIN

add_ch: PROCESS (Clock)
	BEGIN
		IF (Clock'EVENT AND Clock='1') THEN
			IF (sel='1') THEN
				add_c <= jump_add;
			ELSE
				add_c <= STD_LOGIC_VECTOR(UNSIGNED(add)+1);
			END IF;
		END IF;
END PROCESS;

add <= add_c;

urom: microrom PORT MAP (add, d_out); 

cc2 <= d_out(28);
cc1 <= d_out(27);
Done <= d_out(26);
C <= d_out(25);
Rst <= d_out(24);
mux_m1 <= d_out(23 DOWNTO 22);
mux_m2 <= d_out(21);
mux_a <= d_out(20 DOWNTO 19);
mux_s1 <= d_out(18);
mux_s2 <= d_out(17 DOWNTO 16);
mux_ra <= d_out(15);
en1 <= d_out(14);
en2 <= d_out(13);
en3 <= d_out(12);
en4 <= d_out(11);
en5 <= d_out(10);
en6 <= d_out(9);
en7 <= d_out(8);
en8 <= d_out(7);
en9 <= d_out(6);
en10 <= d_out(5);
en11 <= d_out(4);
jump_add <= d_out(3 DOWNTO 0);

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
