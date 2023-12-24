LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY selettore_uscita IS
	PORT (
		RD : IN std_logic;
		IN0, IN1, IN2, IN3 : IN std_logic_vector(15 downto 0);
		ADDRESS : IN std_logic_vector(7 downto 0);
		DATA_OUT : OUT std_logic_vector(15 downto 0)
		);
END ENTITY;

ARCHITECTURE behavior OF selettore_uscita IS

BEGIN

PROCESS(RD, ADDRESS)
BEGIN

IF ( RD = '1' ) THEN
	cASE ADDRESS IS
		WHEN "00000000" =>	DATA_OUT <= IN0;
		WHEN "00000001" =>	DATA_OUT <= IN1;
		WHEN "00000010" =>	DATA_OUT <= IN2;
		WHEN "00000011" =>	DATA_OUT <= IN3;
		WHEN OTHERS 	 => 	DATA_OUT <= (OTHERS => '-');
	END CASE;
ELSE
	DATA_OUT <= (OTHERS => '-');
END IF;

END PROCESS;

	
END ARCHITECTURE;