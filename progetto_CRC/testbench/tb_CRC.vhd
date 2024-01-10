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

FILE ifile, ofile : text;

BEGIN

test : CRC PORT MAP(clk, rst_sw, rd, wr, mosi, miso, add);

PROCESS		-- clock=10MHz => T=100 ns
BEGIN
	clk <= '1';
	wait for 50 ns;
	clk <= '0';
	wait for 50 ns;
END PROCESS;

PROCESS

VARIABLE iline, oline : line;
VARIABLE din : std_logic_vector(15 downto 0);

BEGIN

rst_sw<='0'; rd<='0'; wr<='0'; 
wait for 150 ns;
rst_sw<='1';		-- reset attivo
wait for 200 ns;
rst_sw<='0';		-- reset disattivato
wait for 200 ns;


file_open(ifile, "crc_test_input.txt", read_mode);
file_open(ofile, "crc_result.txt", write_mode);

while not endfile(ifile) loop	-- per testare tutti i dati bisogna impostare il tempo della simulazione ad almeno 407 ms con risuluzione di 10 ns
	-- scrittura registro 0
	readline(ifile, iline);
	read(iline, din);
	mosi <= din;
	wr <= '1';
	add <= "00000000";
	wait for 100 ns;	-- aspetta per un periodo di clock
	wr <= '0'; 

	-- attendo il tempo equivalente a richiedere la lettura del dato dal registro 1, ovvero 16 us
	wait for 5 us;	-- per accorciare la simulazione metto 5us tanto i dati sono già pronti
	
	-- comando di lettura sul registro 1
	add <= "00000001";
	rd <= '1';
	wait for 100 ns;	-- aspetto per un periodo di clock
	write(oline, miso);
	writeline(ofile, oline);	-- scrivo un file con i risultati del test
	rd <= '0';
	
	-- attendo il tempo equivalente a ricevere il dato appena letto e di scrivere un nuovo dato sul registro 0, ovvero 48 us
	wait for 1 us; -- per accorciare la simulazione metto 1us tanto i dati sono già pronti
		
end loop;

file_close(ifile);
file_close(ofile);
wait;


END PROCESS;

END ARCHITECTURE;