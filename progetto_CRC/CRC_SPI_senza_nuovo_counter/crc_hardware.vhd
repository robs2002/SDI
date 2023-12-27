LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY crc_hardware IS
PORT(
	CLK, RST, LD, SE : IN std_logic;
	data_in : IN std_logic_vector(15 downto 0);
	data_out : BUFFER std_logic_vector(15 downto 0)
	);
END ENTITY;

ARCHITECTURE behavior OF crc_hardware IS

BEGIN

PROCESS(CLK, RST)
BEGIN
	IF ( RST = '1' ) THEN
		data_out <= (others => '0');	-- tutti i bit a 0
	ELSIF ( CLK'EVENT AND CLK='1' ) THEN
		IF ( LD = '1' ) THEN
			data_out <= data_in;
		ELSIF ( SE ='1' ) THEN
			data_out <= data_out(14 downto 12) & (data_out(15) XOR data_out(11)) & data_out(10 downto 5) & (data_out(15) XOR data_out(4)) & data_out(3 downto 0) & data_out(15) ; 
		END IF;
	END IF;
END PROCESS;

END ARCHITECTURE;