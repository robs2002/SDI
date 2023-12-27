LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY reg_crc IS
	PORT (
		CLK, RST, EN : IN std_logic;
		D : IN std_logic_vector(15 downto 0);
		RST_STATE : IN std_logic_vector(15 downto 0);
		Q : OUT std_logic_vector(15 downto 0)
		);
END ENTITY;

ARCHITECTURE behavior OF reg_crc IS

BEGIN

PROCESS(CLK, RST)
BEGIN
	IF ( RST = '1' ) THEN
		Q <= RST_STATE;
	ELSIF ( CLK'EVENT AND CLK = '1' ) THEN
		IF ( EN = '1' ) THEN
			Q <= D;
		END IF;
	END IF;
END PROCESS;
	
END ARCHITECTURE;