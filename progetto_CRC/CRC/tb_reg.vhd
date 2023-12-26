LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY tb_reg IS
END ENTITY;

ARCHITECTURE Behavior OF tb_reg IS

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

rst_sw<='0'; rd<='0'; wr<='0'; 
wait for 150 ns;
rst_sw<='1';		-- reset attivo
wait for 200 ns;
rst_sw<='0';		-- reset disattivato
wait for 200 ns;

-- test di lettura e scrittura in tutti i registri in cui è permesso

-- scrivo un dato nel registro 0
mosi <= "1000000000000000";
wr <= '1';
add <= "00000000";
wait for 100 ns;	-- aspetta per un periodo di clock
wr <= '0'; 

-- attendo il tempo equivalente a richiedere la lettura del dato dal registro 1, ovvero 16 us
wait for 5 us;	-- per accorciare la simulazione metto 5us tanto i dati sono già pronti

-- leggo dato nel registro 1 (risultato CRC)
add <= "00000001";
rd <= '1';
wait for 100 ns;	-- aspetto per un periodo di clock
rd <= '0';

-- aspetto un pò di tempo
wait for 1 us;

-- LSB=1 nel registro 2 per provocare il RST del CRC
mosi <= "1100000000000001";
wr <= '1';
add <= "00000010";
wait for 100 ns;	-- aspetta per un periodo di clock
wr <= '0'; 

-- attendo il tempo equivalente a richiedere la lettura del dato dal registro 1, ovvero 16 us
wait for 5 us;	-- per accorciare la simulazione metto 5us tanto i dati sono già pronti

-- leggo dato nel registro 1 (risultato CRC)
add <= "00000001";
rd <= '1';
wait for 100 ns;	-- aspetto per un periodo di clock
rd <= '0';

-- aspetto un pò di tempo
wait for 1 us;

-- leggo dato nel registro 0
add <= "00000000";
rd <= '1';
wait for 100 ns;	-- aspetto per un periodo di clock
rd <= '0';

-- aspetto un pò di tempo
wait for 1 us;

-- leggo dato nel registro 2
add <= "00000010";
rd <= '1';
wait for 100 ns;	-- aspetto per un periodo di clock
rd <= '0';

-- aspetto un pò di tempo
wait for 1 us;

-- leggo dato nel registro 3
add <= "00000011";
rd <= '1';
wait for 100 ns;	-- aspetto per un periodo di clock
rd <= '0';

-- aspetto un pò di tempo
wait for 1 us;

-- leggo dato nel registro 4 (non dovrei leggere nulla)
add <= "00000100";
rd <= '1';
wait for 100 ns;	-- aspetto per un periodo di clock
rd <= '0';

-- aspetto un pò di tempo
wait for 1 us;

wait;

END PROCESS;

END ARCHITECTURE;
