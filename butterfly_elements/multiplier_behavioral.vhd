library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY multiplier_behavioral IS
GENERIC(N: INTEGER:=24);
    PORT ( A : in STD_LOGIC_VECTOR (N-1 downto 0);
           B : in STD_LOGIC_VECTOR (N-1 downto 0);
           Result : out STD_LOGIC_VECTOR (2*N-1 downto 0));
END multiplier_behavioral;

ARCHITECTURE Behavioral of multiplier_behavioral is

    SIGNAL a_signed, b_signed : SIGNED (N-1 DOWNTO 0);

BEGIN
        a_signed <= (SIGNED(A));
        b_signed <= (SIGNED(B));

        Result <= STD_LOGIC_VECTOR(a_signed * b_signed);
end Behavioral;
