LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY decodifica IS
	PORT (
		WR, SB : IN std_logic;
		ADDRESS : IN std_logic_vector(7 downto 0);
		EN1, EN2 : OUT std_logic
		);
END ENTITY;

ARCHITECTURE behavior OF decodifica IS

BEGIN

EN1 <= '1' WHEN ADDRESS="00000000" AND WR='1' AND SB='1' ELSE '0';
EN2 <= '1' WHEN ADDRESS="00000010" AND WR='1' AND SB='1' ELSE '0';
	
END ARCHITECTURE;