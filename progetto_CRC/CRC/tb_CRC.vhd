LIBRARY ieee;
USE ieee.std_logic_1164.all;

USE ieee.std_logic_textio.all;
USE STD.textio.all;

ENTITY tb_CRC IS
END ENTITY;

ARCHITECTURE Behavior OF tb_CRC IS

COMPONENT CRC IS
PORT(
	CLK, RST_SW : IN std_logic;
	RD, WR : IN std_logic;
	mosi : IN std_logic_vector(15 downto 0);
	miso : OUT std_logic_vector(15 downto 0);
	add : IN std_logic_vector(7 downto 0)
	);
END COMPONENT;

SIGNAL clk, rst_sw, rd, wr : std_logic;
SIGNAL mosi, miso : std_logic_vector(15 downto 0);
SIGNAL add : std_logic_vector(7 downto 0);

FILE ifile, ofile, testfile : text;

BEGIN

test : CRC PORT MAP(clk, rst_sw, rd, wr, mosi, miso, add);

PROCESS		-- clock=10MHz => T=100 ns
BEGIN
	clk <= '0';
	wait for 50 ns;
	clk <= '1';
	wait for 50 ns;
END PROCESS;

PROCESS

VARIABLE iline, oline, testline : line;
VARIABLE din, dout, vettore_test : std_logic_vector(15 downto 0);

BEGIN

rst_sw<='0'; rd<='0'; wr<='0'; 
wait for 100 ns;
rst_sw<='1';		-- reset attivo
wait for 100 ns;
rst_sw<='0';		-- reset disattivato
wait for 25 ns;

file_open(ifile, "crc_test_input.txt", read_mode);
file_open(ofile, "crc_test_output.txt", read_mode);
file_open(testfile, "crc-result.txt", write_mode);
while not endfile(ifile) loop
	-- immetto nuovo dato
	readline(ifile, iline);
	read(iline, din);
	mosi <= din;
	wr <= '1';
	add <= "00000000";
	wait for 100 ns;	-- aspetta per un periodo di clock
	wr <= '0'; 
	wait for 16 us;	-- aspetto il tempo che ci mette il modulo SPI a richiedere la lettura
	readline(ofile, oline);
	read(oline, dout);
	add <= "00000001";
	rd <= '1';
	vettore_test := dout XOR miso;
	write(testline, vettore_test);
	writeline(testfile, testline);	-- scrivo un file con i risultati del test
	wait for 100 ns;	-- aspetto per un periodo di clock
	rd <= '0';
	
	wait for 1 us; -- dovrei aspettare per 48 us che è il tempo necessaro per leggere i dati tramite SPI e mandare il nuovo dato
		
end loop;

file_close(ifile);
file_close(ofile);
file_close(testfile);

END PROCESS;

END ARCHITECTURE;