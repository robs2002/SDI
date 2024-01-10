library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


ENTITY adder_tb IS
   
end adder_tb;

ARCHITECTURE test OF adder_tb IS

COMPONENT adder IS
 GENERIC(N: INTEGER:=24);
    PORT ( A : in STD_LOGIC_VECTOR (N-1 downto 0);
           B : in STD_LOGIC_VECTOR (N-1 downto 0);
	   Clock, Reset : IN STD_LOGIC;
           Result : out STD_LOGIC_VECTOR (N-1 downto 0));
END COMPONENT;

signal a_s,b_s: STD_LOGIC_VECTOR(23 downto 0);
SIGNAL clk_tb, rst_tb: STD_LOGIC;
signal p_s: STD_LOGIC_VECTOR(23 downto 0);

BEGIN

PROCESS
BEGIN
clk_tb <= '0';
wait for 5 ns;
clk_tb <= '1';
wait for 5 ns;
END PROCESS;

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
wait for 50 ns;
a_s <= "101000000000010000000000";
b_s <= "100000001010001101010100";
wait;
end process;

rst_tb <= '1', '0' after 10 ns;

dut: adder GENERIC MAP(24) PORT MAP (a_s, b_s, clk_tb, rst_tb, p_s);

END test;
