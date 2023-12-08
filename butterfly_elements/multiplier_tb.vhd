library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY multiplier_tb IS

END multiplier_tb;

ARCHITECTURE Behavioral of multiplier_tb is

COMPONENT multiplier IS
    GENERIC(N: INTEGER:=24);
    PORT ( A : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
           B : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	   C, Clock, Rst : IN STD_LOGIC;
           Result_m : out STD_LOGIC_VECTOR (2*N-2 DOWNTO 0);
	   Result_s : out STD_LOGIC_VECTOR (2*N-2 DOWNTO 0)
	 );
END COMPONENT;

SIGNAL clk_tb, rst_tb, c_s: STD_LOGIC;
SIGNAL a_s, b_s: STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL rm_tb, rs_tb: STD_LOGIC_VECTOR(46 DOWNTO 0);

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
wait for 55 ns;
a_s <= "101010101010101010101010";
b_s <= "101010101010101010101010";
wait for 55 ns;
a_s <= "111111111111111111111111";
b_s <= "111111111111111111111111";
wait for 55 ns;
a_s <= "000000000000000000000000";
b_s <= "000000000000000000000000";
wait;
end process;

rst_tb <= '1', '0' after 10 ns;

c_s <= '1', '0' after 25 ns, '1' after 45 ns;

m: multiplier PORT MAP(a_s, b_s, c_s, clk_tb, rst_tb, rm_tb, rs_tb);

END Behavioral;
