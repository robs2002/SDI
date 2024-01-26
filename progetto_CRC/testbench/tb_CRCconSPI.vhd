-- tempo di simulazione di almeno 68 us con risoluzione minima di 100ns

LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY tb_CRCconSPI IS
END ENTITY;

ARCHITECTURE Behavior OF tb_CRCconSPI IS

COMPONENT CRCconSPI IS
PORT(
	CK, MOSI, nSS, SCK, RST_SW : IN std_logic;
	MISO : OUT std_logic
	);
END COMPONENT;

SIGNAL clk, rst_sw, mosi, nss, sck, miso: std_logic;


BEGIN

test : CRCconSPI PORT MAP(clk, mosi, nss, sck, rst_sw, miso);

clk_process : PROCESS		-- clock=10MHz => T=100 ns
	BEGIN
	clk <= '1';
	wait for 50 ns;
	clk <= '0';
	wait for 50 ns;
END PROCESS;

sck_process : PROCESS		-- clock=1MHz => T=1 us
	BEGIN
		sck <= '1';
		wait for 500 ns;
		sck <= '0';
		wait for 500 ns;
	END PROCESS;

	PROCESS
	
	VARIABLE stato : std_logic_vector(7 downto 0) := "00100000";		-- definito uguale a 32 che equivale al comando di scrittura
	VARIABLE address : std_logic_vector(7 downto 0) := "00000000";
	VARIABLE data : std_logic_vector(15 downto 0) := "1010101010101010";

	BEGIN

	rst_sw<='0'; 
	nss <= '1';
	mosi<='0';
	wait for 150 ns;
	rst_sw<='1';		-- reset attivo
	wait for 200 ns;
	rst_sw<='0';		-- reset disattivato
	wait for 200 ns;

	nss<='0';			-- attivo slave
	-- ciclo di scrittura
	for i in 7 downto 0 loop	-- invio tutti i bit di stato
		wait until rising_edge(sck);	
		mosi<=stato(i);
	end loop;


	for i in 7 downto 0 loop	-- invio tutti i bit di indirizzo
		wait until rising_edge(sck);
		mosi<=address(i);
	end loop;

	for i in 15 downto 0 loop	-- invio tutti i bit per il dato
		wait until rising_edge(sck);
		mosi<=data(i);	-- ho inviato 0xAAAA => CRC atteso: 0xFB1A
	end loop;
	wait until rising_edge(sck);

	wait for 100 ns;	-- aspetta un pò prima di deselezionare lo slave
	nss<='1';			-- deseleziono slave

	wait for 1 us;

	nss<='0';			-- attivo slave
	-- ciclo di lettura
	stato := "00100001";		-- valore 33 che significa lettura
	for i in 7 downto 0 loop	-- invio tutti i bit di stato
		wait until rising_edge(sck);
		mosi<=stato(i);
	end loop;

	for i in 7 downto 0 loop	-- invio tutti i bit di indirizzo
		wait until rising_edge(sck);
		mosi<=address(i);
	end loop;
	wait until rising_edge(sck);

	wait for 16.1 us;	-- aspetta il tempo di trasmissione dati più un pochino
	nss<='1';			-- deseleziono slave

	wait;

END PROCESS;

END ARCHITECTURE;
