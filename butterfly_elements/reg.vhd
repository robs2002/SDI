LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg IS
GENERIC (N : integer:=16); 
PORT (R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
Enable,Clock : IN STD_LOGIC; 
Q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END reg;

ARCHITECTURE Behavior OF reg IS

BEGIN
PROCESS (Clock)
BEGIN

IF (Clock'EVENT AND Clock = '1') THEN
     IF (Enable='1') THEN
        Q <= R;
     END IF;
END IF;
END PROCESS;

END Behavior;
