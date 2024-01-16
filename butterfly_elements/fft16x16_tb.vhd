library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;		
use IEEE.std_logic_textio.all;
use ieee.numeric_std.all;
LIBRARY std;

entity fft16x16_tb is			
END  fft16x16_tb;

architecture Behavioral of fft16x16_tb is		

COMPONENT fft IS
PORT(
	X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
	Start, Clock, Reset : IN STD_LOGIC;
	Done : OUT STD_LOGIC;
	X0p, X1p, X2p, X3p, X4p, X5p, X6p, X7p, X8p, X9p, X10p, X11p, X12p, X13p, X14p, X15p: OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
);
END COMPONENT;

SIGNAL X0_tb, X1_tb, X2_tb, X3_tb, X4_tb, X5_tb, X6_tb, X7_tb, X8_tb, X9_tb, X10_tb, X11_tb, X12_tb, X13_tb, X14_tb, X15_tb,
X0p_tb, X1p_tb, X2p_tb, X3p_tb, X4p_tb, X5p_tb, X6p_tb, X7p_tb, X8p_tb, X9p_tb, X10p_tb, X11p_tb, X12p_tb, X13p_tb, X14p_tb, X15p_tb : STD_LOGIC_VECTOR (23 DOWNTO 0); 
SIGNAL Start_tb, Clock_tb, Reset_tb, Done_tb : STD_LOGIC;
FILE xin: TEXT;
FILE xout: TEXT;

BEGIN 			

test_input : PROCESS
	
      variable data_c : STD_LOGIC_VECTOR(23 DOWNTO 0);
      variable l      : LINE;

BEGIN

file_open(xin, "xin.txt",  read_mode);
X0_tb <= (OTHERS=>'0');	
X1_tb <= (OTHERS=>'0');	
X2_tb <= (OTHERS=>'0');	
X3_tb <= (OTHERS=>'0');	
X4_tb <= (OTHERS=>'0');	
X5_tb <= (OTHERS=>'0');	
X6_tb <= (OTHERS=>'0');	
X7_tb <= (OTHERS=>'0');	
X8_tb <= (OTHERS=>'0');	
X9_tb <= (OTHERS=>'0');	
X10_tb <= (OTHERS=>'0');	
X11_tb <= (OTHERS=>'0');	
X12_tb <= (OTHERS=>'0');	
X13_tb <= (OTHERS=>'0');	
X14_tb <= (OTHERS=>'0');	
X15_tb <= (OTHERS=>'0');	
Start_tb <= '0'; 

WHILE not (ENDFILE(xin)) LOOP
  WAIT FOR 50 ns;
	Start_tb <= '1'; 
  WAIT FOR 10 ns;
	Start_tb <= '0'; 
	readline(xin, l);
	read(l, data_c);
	X0_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X1_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X2_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X3_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X4_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X5_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X6_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X7_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X8_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X9_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X10_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X11_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X12_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X13_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X14_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X15_tb <= data_c;
  WAIT FOR 10 ns;
	readline(xin, l);
	read(l, data_c);
	X0_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X1_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X2_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X3_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X4_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X5_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X6_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X7_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X8_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X9_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X10_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X11_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X12_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X13_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X14_tb <= data_c;
	readline(xin, l);
	read(l, data_c);
	X15_tb <= data_c;
 END LOOP;
 
file_close(xin);
WAIT FOR 1 ms;


END PROCESS;

test_output : PROCESS
	
      variable l: LINE;

BEGIN

IF (Done_tb='1') THEN
	file_open(xout, "xout.txt", append_mode);
 WAIT FOR 10 ns;
	write(l, X0p_tb);
	writeline(xout, l);
	write(l, X1p_tb);
     	writeline(xout, l);
	write(l, X2p_tb);
	writeline(xout, l);
	write(l, X3p_tb);
     	writeline(xout, l);
	write(l, X4p_tb);
	writeline(xout, l);
	write(l, X5p_tb);
     	writeline(xout, l);
	write(l, X6p_tb);
	writeline(xout, l);
	write(l, X7p_tb);
     	writeline(xout, l);
	write(l, X8p_tb);
	writeline(xout, l);
	write(l, X9p_tb);
     	writeline(xout, l);
	write(l, X10p_tb);
	writeline(xout, l);
	write(l, X11p_tb);
     	writeline(xout, l);
	write(l, X12p_tb);
	writeline(xout, l);
	write(l, X13p_tb);
     	writeline(xout, l);
	write(l, X14p_tb);
	writeline(xout, l);
	write(l, X15p_tb);
     	writeline(xout, l);
 WAIT FOR 10 ns;
	write(l, X0p_tb);
	writeline(xout, l);
	write(l, X1p_tb);
     	writeline(xout, l);
	write(l, X2p_tb);
	writeline(xout, l);
	write(l, X3p_tb);
     	writeline(xout, l);
	write(l, X4p_tb);
	writeline(xout, l);
	write(l, X5p_tb);
     	writeline(xout, l);
	write(l, X6p_tb);
	writeline(xout, l);
	write(l, X7p_tb);
     	writeline(xout, l);
	write(l, X8p_tb);
	writeline(xout, l);
	write(l, X9p_tb);
     	writeline(xout, l);
	write(l, X10p_tb);
	writeline(xout, l);
	write(l, X11p_tb);
     	writeline(xout, l);
	write(l, X12p_tb);
	writeline(xout, l);
	write(l, X13p_tb);
     	writeline(xout, l);
	write(l, X14p_tb);
	writeline(xout, l);
	write(l, X15p_tb);
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

fft_tb: fft PORT MAP (X0_tb, X1_tb, X2_tb, X3_tb, X4_tb, X5_tb, X6_tb, X7_tb, X8_tb, X9_tb, X10_tb, X11_tb, X12_tb, X13_tb, X14_tb, X15_tb,
		      Start_tb, Clock_tb, Reset_tb, Done_tb, X0p_tb, X1p_tb, X2p_tb, X3p_tb, X4p_tb, X5p_tb, X6p_tb, X7p_tb, X8p_tb, X9p_tb, 
		      X10p_tb, X11p_tb, X12p_tb, X13p_tb, X14p_tb, X15p_tb);

END Behavioral;
