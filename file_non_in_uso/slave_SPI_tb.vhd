LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY slave_SPI_tb IS
END ENTITY;

ARCHITECTURE behavior OF slave_SPI_tb IS

COMPONENT slave_SPI IS
PORT(CK, MOSI, nSS, SCK, RST_S : IN std_logic;
     MISO : OUT std_logic);
END COMPONENT;

SIGNAL ck_tb, mosi_tb, nss_tb, sck_tb, miso_tb, rst_s_tb : std_logic;

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

nss_tb <= '1', '0' after 120 ns,'1' after 35000 ns;
rst_s_tb <= '1','0' after 50 ns,'1' after 34000 ns;

mosi_tb <= '0','1' after 2700 ns, '0' after 3700 ns, '1' after 7700 ns; --lettura 00100001
--mosi_tb <= '0','1' after 2700 ns, '0' after 3700 ns, '1' after 8700 ns; --scrittura 00100000

test: slave_SPI PORT MAP(ck_tb, mosi_tb, nss_tb, sck_tb, rst_s_tb, miso_tb);

END behavior;
