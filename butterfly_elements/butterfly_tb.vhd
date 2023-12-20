library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY butterfly_tb IS
   
end butterfly_tb;

ARCHITECTURE test OF butterfly_tb IS

COMPONENT butterfly_element IS
PORT(
	A, B, Wr, Wi : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
	Start, Clock, Reset : IN STD_LOGIC;
	Done : OUT STD_LOGIC;
	A_p, B_p : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
);
END COMPONENT;

SIGNAL A_tb, B_tb, Wr_tb, Wi_tb, A_p_tb, B_p_tb : STD_LOGIC_VECTOR (23 DOWNTO 0); 
SIGNAL Start_tb, Clock_tb, Reset_tb, Done_tb : STD_LOGIC;

BEGIN

PROCESS
BEGIN
Clock_tb <= '0';
wait for 5 ns;
Clock_tb <= '1';
wait for 5 ns;
END PROCESS;

Reset_tb <= '1', '0' after 10 ns; 
A_tb <= "UUUUUUUUUUUUUUUUUUUUUUUU" , "011111111111111111111111" after 55 ns, "000000000000000000000000" after 65 ns;
B_tb <= "UUUUUUUUUUUUUUUUUUUUUUUU" , "000000000000000000000000" after 55 ns, "000000000000000000000000" after 65 ns; 
Start_tb <= '0', '1' after 40 ns, '0' after 50 ns; 

btb: butterfly_element PORT MAP (A_tb, B_tb, "011111111111111111111111", "000000000000000000000000", Start_tb, Clock_tb, Reset_tb, Done_tb, A_p_tb, B_p_tb);

END test;

