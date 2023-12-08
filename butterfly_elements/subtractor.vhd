library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY subtractor IS
GENERIC(N: INTEGER:=47);
    PORT ( A : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
           B : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	   Clock, Reset : IN STD_LOGIC;
           Result : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0));
END subtractor;

ARCHITECTURE Behavioral of subtractor is

BEGIN
     PROCESS (Clock, Reset)
	BEGIN
	IF (Reset = '1') THEN
	Result <= (OTHERS => '0');
	ELSIF (Clock'EVENT AND Clock = '1') THEN
	Result <= STD_LOGIC_VECTOR(TO_SIGNED(TO_INTEGER(SIGNED(A))- TO_INTEGER(SIGNED(B)),N));
	END IF;
     END PROCESS;
   
end Behavioral;
