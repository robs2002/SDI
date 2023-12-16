LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY datapath IS
PORT(
	CLK, RST, LD, SE, CE, En0, En1, En2, En3, sr, out_select: IN std_logic;
	TC, cr : OUT std_logic;
	DIN : IN std_logic_vector(15 downto 0);
	DOUT : OUT std_logic_vector(15 downto 0)
	);
END ENTITY;

ARCHITECTURE behavior OF datapath IS

COMPONENT crc_hardware IS
PORT(
	CLK, RST, LD, SE : IN std_logic;
	data_in : IN std_logic_vector(15 downto 0);
	data_out : OUT std_logic_vector(15 downto 0)
	);
END COMPONENT;

COMPONENT counter IS
	PORT (
		CLK, RST, CE : IN std_logic;
		TC : OUT std_logic
	);
END COMPONENT;

COMPONENT reg IS
	PORT (
		CLK, RST, EN : IN std_logic;
		D : IN std_logic_vector(15 downto 0);
		Q : OUT std_logic_vector(15 downto 0)
		);
END COMPONENT;

SIGNAL data_in, data_out, reg2_out, reg3_in, reg1_out, reg3_out : std_logic_vector(15 downto 0);

BEGIN

crc : crc_hardware PORT MAP(CLK, RST, LD, SE, data_in, data_out);

contatore : counter PORT MAP(CLK, RST, CE, TC);

reg0 : reg PORT MAP(CLK, RST, En0, DIN, data_in);	-- data in register

reg1 : reg PORT MAP(CLK, RST, En1, data_out, reg1_out);	-- data out register

reg2 : reg PORT MAP(CLK, RST, En2, DIN, reg2_out);	-- control register (scrivendo '1' nel LSB causa il reset del CRC)

reg3 : reg PORT MAP(CLK, RST, En3, reg3_in, reg3_out);	-- status register ('1' nel LSB significa che il calcolatore di CRC è pronto a ricevere una nuova parola

cr <= reg2_out(0);
reg3_in <= "000000000000000" & sr;
DOUT <= reg1_out when (out_select = '0') else reg3_out;	-- mux

END ARCHITECTURE;