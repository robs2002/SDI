LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY shift_tb IS
   
end shift_tb;

ARCHITECTURE test OF shift_tb IS

signal a_s: STD_LOGIC_VECTOR(23 downto 0);
signal p_s: STD_LOGIC_VECTOR(24 downto 0);
signal p_sr: STD_LOGIC_VECTOR(23 downto 0);
signal p_ss: STD_LOGIC_VECTOR(46 downto 0);
signal a: SIGNED(24 DOWNTO 0);
signal b: SIGNED(23 DOWNTO 0);

BEGIN

process
begin
a_s <= "010000000000000000000000";
wait for 100 ns;
a_s <= "101010101010101010101010";
wait for 100 ns;
a_s <= "111111111111111111111111";
wait for 50 ns;
a_s <= "000000000000000000000000";
wait;
end process;

a <= SIGNED('0' & a_s);

b <= SIGNED(a_s);

p_s <= STD_LOGIC_VECTOR(a sll 1);

p_sr <= STD_LOGIC_VECTOR(RESIZE(b(23 DOWNTO 1),24));

p_ss <= STD_LOGIC_VECTOR(RESIZE(a sll 1, 47));

END test;
