library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY multiplier_behavioral IS
GENERIC(N: INTEGER:=24);
    PORT ( A : in STD_LOGIC_VECTOR (N-1 DOWNTO 0);
           B : in STD_LOGIC_VECTOR (N-1 DOWNTO 0);
           Result : out STD_LOGIC_VECTOR (2*N-2 DOWNTO 0));
END multiplier_behavioral;

ARCHITECTURE Behavioral of multiplier_behavioral is

SIGNAL A_s, B_s: SIGNED (N-1 DOWNTO 0);
SIGNAL rs_p: SIGNED (2*N-1 DOWNTO 0);

BEGIN

	A_s <= SIGNED(A);
	B_s <= SIGNED(B);

	rs_p <= A_s * B_s;

        Result <= STD_LOGIC_VECTOR(RESIZE(rs_p, Result'LENGTH));

end Behavioral;
