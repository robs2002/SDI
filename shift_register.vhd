LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg IS
GENERIC (N : integer:=16); 
PORT (
Clock,Reset,Enable,R : IN STD_LOGIC; 
Q : BUFFER STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END reg;

ARCHITECTURE Behavior OF reg IS

BEGIN
PROCESS (Clock, Reset)
BEGIN

IF (Reset = '1') THEN
Q <= (OTHERS => '0');
ELSIF (Clock'EVENT AND Clock = '1') THEN
IF (Enable='1') THEN
Q <= R & Q(N-1 DOWNTO 1);
END IF;
END IF;
END PROCESS;

END Behavior;
