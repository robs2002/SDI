LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg_load IS
GENERIC (N : INTEGER:=16); 
PORT ( DOUT : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
Clock,Reset,Load,Enable: IN STD_LOGIC; 
R: OUT STD_lOGIC
);
END reg_load;

ARCHITECTURE Behavior OF reg_load IS

SIGNAL Q : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

BEGIN

PROCESS (Clock, Reset)
BEGIN
IF (Reset = '1') THEN
	Q <= (OTHERS => '0');
	R <= 'Z';	-- uscita in alta impedenza quando viene effettuato il reset
ELSIF (Clock'EVENT AND Clock = '1') THEN
	IF (Enable='1') THEN
		R <= Q(N-1);	-- uscita = MSB
		Q <= Q(N-2 DOWNTO 0) & '0';
	END IF;
	IF (Load='1') THEN
		Q <= DOUT;
	END IF;
END IF;
END PROCESS;

END Behavior;
