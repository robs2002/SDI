library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY butterfly_element IS
PORT(
	A, B, Wr, Wi : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
	Start, Clock, Reset : IN STD_LOGIC;
	Done : OUT STD_LOGIC;
	A_p, B_p : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
);
END butterfly_element;

ARCHITECTURE Behavior OF butterfly_element IS

COMPONENT datapath IS
    PORT ( A, B, Wr, Wi : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
	   C, Clock, Rst, mux_pa, mux_m2, mux_s1, mux_ra, en1, en2, en3, en4, en5, en6, en7, en8, en9, en10, en11 : IN STD_LOGIC;
	   mux_m1, mux_a, mux_s2: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
           A_p, B_p : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT cu IS
PORT (
           Start, Clock, Reset : IN STD_LOGIC;
	   Done, C, Rst, mux_pa, mux_m2, mux_s1, mux_ra, en1, en2, en3, en4, en5, en6, en7, en8, en9, en10, en11 : OUT STD_LOGIC;
	   mux_m1, mux_a, mux_s2: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
);
END COMPONENT;

SIGNAL C, Rst, mux_pa, mux_m2, mux_s1, mux_ra, en1, en2, en3, en4, en5, en6, en7, en8, en9, en10, en11 : STD_LOGIC;
SIGNAL mux_m1, mux_a, mux_s2: STD_LOGIC_VECTOR(1 DOWNTO 0); 

BEGIN

control: cu PORT MAP ( Start, Clock, Reset, Done, C, Rst, mux_pa, mux_m2, mux_s1, mux_ra, en1, en2, en3, en4, en5, en6, en7, en8, en9, en10, en11, mux_m1, mux_a, mux_s2 );
data: datapath PORT MAP ( A, B, Wr, Wi, C, Clock, Rst, mux_pa, mux_m2, mux_s1, mux_ra, en1, en2, en3, en4, en5, en6, en7, en8, en9, en10, en11, mux_m1, mux_a, mux_s2, A_p, B_p );

END Behavior;




