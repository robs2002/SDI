library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;		
use IEEE.std_logic_textio.all;
use ieee.numeric_std.all;
LIBRARY std;

entity butter_tb is			
END  butter_tb;

architecture Behavioral of butter_tb is		

COMPONENT butterfly_element IS
PORT(
	A, B, Wr, Wi : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
	Start, Clock, Reset : IN STD_LOGIC;
	Done : OUT STD_LOGIC;
	A_p, B_p : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
);
END COMPONENT;

SIGNAL A_tb, B_tb, A_p_tb, B_p_tb : STD_LOGIC_VECTOR (23 DOWNTO 0); 
SIGNAL Start_tb, Clock_tb, Reset_tb, Done_tb : STD_LOGIC;
FILE xin: TEXT;
FILE xout: TEXT;

BEGIN 			

test_input : PROCESS
	
      variable data_c : STD_LOGIC_VECTOR(23 DOWNTO 0);
      variable l      : LINE;

BEGIN

file_open(xin, "xin_b.txt",  read_mode);
A_tb <= (OTHERS=>'0');	
B_tb <= (OTHERS=>'0');	
Start_tb <= '0'; 

WHILE not (ENDFILE(xin)) LOOP
  WAIT FOR 60 ns;
	Start_tb <= '1'; 
  WAIT FOR 10 ns;
	Start_tb <= '0'; 
	readline(xin, l);
	read(l, data_c);
	A_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	B_tb <= data_c;
  WAIT FOR 10 ns;
	readline(xin, l);
	read(l, data_c);
	A_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	B_tb <= data_c;
 END LOOP;
 
file_close(xin);
WAIT FOR 1 ms;


END PROCESS;

test_output : PROCESS
	
      variable l: LINE;

BEGIN

IF (Done_tb='1') THEN
	file_open(xout, "xout_b.txt", append_mode);
 WAIT FOR 10 ns;
	write(l, A_p_tb);
	writeline(xout, l);
	write(l, B_p_tb);
     	writeline(xout, l);
 WAIT FOR 10 ns;
	write(l, A_p_tb);
	writeline(xout, l);
	write(l, B_p_tb);
       	writeline(xout, l);
 WAIT FOR 10 ns;
	file_close(xout);
END IF;
WAIT FOR 1 ps;

END PROCESS;


clk_prc: PROCESS
BEGIN
Clock_tb <= '0';
wait for 5 ns;
Clock_tb <= '1';
wait for 5 ns;
END PROCESS;

Reset_tb <= '1', '0' after 10 ns; 

btb: butterfly_element PORT MAP (A_tb, B_tb, "011111111111111111111111", "000000000000000000000000", Start_tb, Clock_tb, Reset_tb, Done_tb, A_p_tb, B_p_tb);

END Behavioral;
