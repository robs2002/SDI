LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SPI_tb IS
END ENTITY;

ARCHITECTURE behavior OF SPI_tb IS

COMPONENT SPI IS
PORT(CK, MOSI, nSS, SCK : IN std_logic;
     DOUT : IN std_logic_vector(15 downto 0);
     A : OUT std_logic_vector(7 downto 0);
     DIN : OUT std_logic_vector(15 downto 0);
     MISO, RD, WR : OUT std_logic);
END COMPONENT;

SIGNAL ck_tb, mosi_tb, nss_tb, sck_tb, miso_tb, rd_tb, wr_tb : std_logic;
SIGNAL a_tb : std_logic_vector(7 downto 0);
SIGNAL dout_tb, din_tb : std_logic_vector(15 downto 0);

BEGIN

ck_p: PROCESS
BEGIN
ck_tb <= '1';
wait for 50 ns; 
ck_tb <= '0';
wait for 50 ns;
END PROCESS;

sck_p: PROCESS
BEGIN
sck_tb <= '0';
wait for 500 ns; 
sck_tb <= '1';
wait for 500 ns;
END PROCESS;

nss_tb <= '1', '0' after 120 ns, '1' after 32600 ns;

dout_tb <= "0101010101010101"; 

mosi_tb <= '0','1' after 5700 ns, '0' after 6700 ns, '1' after 8700 ns;  --00000100    00100000

test: SPI PORT MAP(ck_tb, mosi_tb, nss_tb, sck_tb, dout_tb, a_tb, din_tb, miso_tb, rd_tb, wr_tb);

END ARCHITECTURE;