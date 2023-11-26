library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


ENTITY subtractor_tb IS
   
end subtractor_tb;

ARCHITECTURE test OF subtractor_tb IS

COMPONENT subtractor IS
 GENERIC(N: INTEGER:=24);
    PORT ( A : in STD_LOGIC_VECTOR (N-1 downto 0);
           B : in STD_LOGIC_VECTOR (N-1 downto 0);
           Result : out STD_LOGIC_VECTOR (N-1 downto 0));
END COMPONENT;

signal a_s,b_s: STD_LOGIC_VECTOR(23 downto 0);
signal p_s: STD_LOGIC_VECTOR(24 downto 0);

BEGIN

process
begin
a_s <= "010000000000000000000000";
b_s <= "001000000000000000000000";
wait for 50 ns;
a_s <= "101010101010101010101010";
b_s <= "101010101010101010101010";
wait for 50 ns;
a_s <= "111111111111111111111111";
b_s <= "111111111111111111111111";
wait for 50 ns;
a_s <= "000000000000000000000000";
b_s <= "000000000000000000000000";
wait;
end process;

dut: subtractor GENERIC MAP(24) PORT MAP (a_s,b_s,p_s);

END test;
