LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY crc_hardware IS	-- modulo che si occupa del calcolo del CRC
PORT(
	CLK, LD, SE, S_CRC : IN std_logic;
	data_in, data_old : IN std_logic_vector(15 downto 0);	-- data_in = dato nel REGISTRO 0 del blocco crc		data_old = dato nel REGISTRO 4 del blocco crc
	data_out : BUFFER std_logic_vector(15 downto 0)		-- coincide con shift register 1
	);
END ENTITY;

ARCHITECTURE behavior OF crc_hardware IS

SIGNAL shift_reg : std_logic_vector(15 downto 0);	-- shift register 2
SIGNAL initial_value : std_logic_vector(15 downto 0) := (others => '1');	-- valore di inizializzazione dello standard crc-16-ccitt
BEGIN

PROCESS(CLK)
BEGIN
	IF ( CLK'EVENT AND CLK='1' ) THEN	-- ogni operazione è sincrona con il clk
		IF ( LD = '1' ) THEN	-- se abilito il caricamento in parallelo di entrmabi gli shift register
			IF ( S_CRC ='0' ) THEN	-- prima calcolo del crc (mux=0)
				data_out <= data_in XOR initial_value;	-- shift register 1 = data_in xor 0x1111
				shift_reg <= (others => '0');			-- shift register 2 = registro con tutti i bit a 0
			ELSE					-- calcolo concutivo del crc (mux=1)
				data_out <= data_old;		-- shift register 1 = dato contnuto nel REGISTRO 4 del blocco CRC
				shift_reg <= data_in;		-- shift register 2 = dato_in
			END IF;
		ELSIF ( SE ='1' ) THEN	-- se abilito lo shift di entrmabi gli shift register
			data_out <= data_out(14 downto 12) & (data_out(15) XOR data_out(11)) & data_out(10 downto 5) & (data_out(15) XOR data_out(4)) & data_out(3 downto 0) & (data_out(15) XOR shift_reg(15));
			shift_reg <= shift_reg(14 downto 0) & '0';	-- shift a sinistra e carico uno 0 nel LSB
		END IF;
	END IF;
END PROCESS;

END ARCHITECTURE;