LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY counter IS
	PORT (
		CLK, RST, CE : IN std_logic;
		TC : OUT std_logic
	);
END ENTITY;

ARCHITECTURE behavior OF counter IS

SIGNAL count : unsigned(3 downto 0);	-- valore del contatore

BEGIN

TC <= '1' when (count = "0000"  ) else '0';	

PROCESs(CLK)
BEGIN
	IF ( CLK'EVENT AND CLK = '1' ) THEN
		IF ( RST = '1' ) THEN
			count <= (others => '0');
		ELSIF ( CE = '1' ) THEN
			count <= count + 1;
		END IF;
	END IF;
END PROCESS;
	
END ARCHITECTURE;