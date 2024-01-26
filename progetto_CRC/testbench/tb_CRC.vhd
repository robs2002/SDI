-- impostare tempo di simulazione a 16us con risoluzione minima di 100ns

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY tb_CRC IS
END ENTITY;

ARCHITECTURE Behavior OF tb_CRC IS

COMPONENT CRC IS
PORT(
	CLK, RST_SW : IN std_logic;
	RD, WR : IN std_logic;
	DIN : IN std_logic_vector(15 downto 0);
	DOUT : OUT std_logic_vector(15 downto 0);
	ADDRESS : IN std_logic_vector(7 downto 0)
	);
END COMPONENT;

SIGNAL clk, rst_sw, rd, wr : std_logic;
SIGNAL mosi, miso : std_logic_vector(15 downto 0);
SIGNAL add : std_logic_vector(7 downto 0);

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
	BEGIN

	-- reset
	rst_sw<='0'; rd<='0'; wr<='0'; 
	wait for 150 ns;
	rst_sw<='1';		-- reset attivo
	wait for 200 ns;
	rst_sw<='0';		-- reset disattivato
	wait for 200 ns;


	-- leggo nei registri da 0 a 3
	for address in 0 to 3 loop
		add <= std_logic_vector(to_unsigned(address, 8)); -- imposto come indirizzo tutti i numeri da 0 e a 5
		rd <= '1';
		wait for 100 ns;	-- aspetta per un tempo di clk
		rd <= '0';
		wait for 1 us;
		-- i dati vengono mandati in uscita il colpo di clk successivo. 
		-- L'SPI però ci mette molto a richiedere una nuova lettura (32us). 
		-- Metto un tempo minore per maggiore compantezza sulla simulazione
	end loop;

	-- scrittura nel registro 0
	mosi <= "0001001101111111"; -- crc input: 0x137F => crc atteso: C457
	add <= "00000000";
	wr <= '1';
	wait for 100 ns;	-- aspetta per un tempo di clk;
	wr <= '0';
	wait for 3 us;
	-- il circuito per avere i dati pronti in uscita ci mette 1.9 us
	-- Se volessimo richiedere una lettura consegutiva con l'SPI ci vuole 16 us
	-- Metto un tempo di 2us in modo che il circuito possa calcolare correttamente il CRC ma non aspetto a vuoto per una maggiore leggibilità della simulazione
		
	-- scrittura nel registro 0	per test CRC consecutivo
	mosi <= "0001001000110100"; -- input = 0x1234. 
	-- Nel calcolo del CRC precedente ho aggiunto la seguente word perciò:
	-- crc input: 0x137F1234 => crc atteso: E344
	add <= "00000000";
	wr <= '1';
	wait for 100 ns;	-- aspetta per un tempo di clk
	wr <= '0';
	wait for 4 us;	-- sono necessari 3.5us per completare il calcolo del CRC. Ne aspetto poco di più

	-- reset CRC => 1 nel LSB del registro 2
	mosi <= "0000000000000001"; -- input = 0x0001. 
	add <= "00000010";
	wr <= '1';
	wait for 100 ns;	-- aspetta per un tempo di clk
	wr <= '0';
	wait for 1 us;

	-- scrittura nel registro 0
	mosi <= "1010101111001101"; -- crc input: 0xABCD => crc atteso: D46A
	add <= "00000000";
	wr <= '1';
	wait for 100 ns;	-- aspetta per un tempo di clk
	wr <= '0';
	wait;

END PROCESS;

END ARCHITECTURE;