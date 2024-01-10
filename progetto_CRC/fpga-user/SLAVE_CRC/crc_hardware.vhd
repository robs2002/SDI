LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY crc_hardware IS
PORT(
	CLK, LD, SE, S_CRC : IN std_logic;
	data_in, data_old : IN std_logic_vector(15 downto 0);
	data_out : BUFFER std_logic_vector(15 downto 0)
	);
END ENTITY;

ARCHITECTURE behavior OF crc_hardware IS

SIGNAL shift_reg : std_logic_vector(15 downto 0);
SIGNAL initial_value : std_logic_vector(15 downto 0) := (others => '1');
BEGIN

PROCESS(CLK)
BEGIN
	IF ( CLK'EVENT AND CLK='1' ) THEN
		IF ( LD = '1' ) THEN
			IF ( S_CRC ='0' ) THEN
				data_out <= data_in XOR initial_value;
				shift_reg <= (others => '0');	--registro con tutti i bit a 0
			ELSE
				data_out <= data_old;
				shift_reg <= data_in;
			END IF;
		ELSIF ( SE ='1' ) THEN
			data_out <= data_out(14 downto 12) & (data_out(15) XOR data_out(11)) & data_out(10 downto 5) & (data_out(15) XOR data_out(4)) & data_out(3 downto 0) & (data_out(15) XOR shift_reg(15)); 
			shift_reg <= shift_reg(14 downto 0) & '0';
		END IF;
	END IF;
END PROCESS;

END ARCHITECTURE;