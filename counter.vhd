LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY counter IS
GENERIC ( N: INTEGER:= 10);
PORT ( Enable, Clock,Reset: IN STD_LOGIC;
       Q: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END counter;

ARCHITECTURE Behavioral OF counter IS

SIGNAL T: STD_LOGIC_VECTOR(N-1 DOWNTO 0);

BEGIN

PROCESS (Clock,Reset) IS
BEGIN

IF (Reset='1') THEN
	T<=(OTHERS => '0');
ELSIF (Clock'EVENT AND Clock='1') THEN
   IF (Enable='1') THEN
         T<=T+1;
   END IF;  
END IF;
END PROCESS;

Q<=T;

END Behavioral;
