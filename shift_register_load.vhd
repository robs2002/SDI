LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg IS
GENERIC (N : integer:=16); 
PORT ( DOUT : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
Clock,Reset,Load,Enable: IN STD_LOGIC; 
Q : BUFFER STD_LOGIC_VECTOR(N-1 DOWNTO 0);
R: OUT STD_lOGIC
);
END reg;

ARCHITECTURE Behavior OF reg IS

BEGIN
PROCESS (Clock, Reset)
BEGIN
R <= 'Z';
IF (Reset = '1') THEN
Q <= (OTHERS => '0');
ELSIF (Clock'EVENT AND Clock = '1') THEN
IF (Load='1') THEN
Q <= DOUT;
ELSIF (Enable='1') THEN
R <= Q(0);
Q <= '0' & Q(N-1 DOWNTO 1);
END IF;
END IF;
END PROCESS;

END Behavior;
