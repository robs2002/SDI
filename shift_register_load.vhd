LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg_laod IS
GENERIC (N : integer:=16); 
PORT ( 
	DOUT : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	Clock,Reset,Load,Enable: IN STD_LOGIC; 
	R: OUT STD_lOGIC
	);
END reg_load;

ARCHITECTURE Behavior OF reg_load IS

SIGNAL Q : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

BEGIN
PROCESS (Clock, Reset)
BEGIN
R <= 'Z';	-- uscita in alta impedenza
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
