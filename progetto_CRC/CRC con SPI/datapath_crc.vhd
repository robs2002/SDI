LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY datapath_crc IS
PORT(
	CLK, RST, RST_reg1, RST_CNT, LD, SE, CE, En1, En2_cu, En3, SB_IN, WR, RD, s_mux: IN std_logic;
	TC, RB : OUT std_logic;
	En0 : BUFFER std_logic;
	MOSI : IN std_logic_vector(15 downto 0);
	ADD : IN std_logic_vector(7 downto 0);
	MISO : OUT std_logic_vector(15 downto 0)
	);
END ENTITY;

ARCHITECTURE behavior OF datapath_crc IS

COMPONENT crc_hardware IS
PORT(
	CLK, RST, LD, SE : IN std_logic;
	data_in : IN std_logic_vector(15 downto 0);
	data_out : OUT std_logic_vector(15 downto 0)
	);
END COMPONENT;

COMPONENT counter_crc IS
	PORT (
		CLK, RST, CE : IN std_logic;
		TC : OUT std_logic
	);
END COMPONENT;

COMPONENT reg_crc IS
	PORT (
		CLK, RST, EN : IN std_logic;
		D : IN std_logic_vector(15 downto 0);
		RST_STATE : IN std_logic_vector(15 downto 0);
		Q : OUT std_logic_vector(15 downto 0)
		);
END COMPONENT;

COMPONENT decodifica IS
	PORT (
		WR, SB : IN std_logic;
		ADDRESS : IN std_logic_vector(7 downto 0);
		EN1, EN2 : OUT std_logic
		);
END COMPONENT;

COMPONENT selettore_uscita IS
	PORT (
		CLK, RD : IN std_logic;
		IN0, IN1, IN2, IN3 : IN std_logic_vector(15 downto 0);
		ADDRESS : IN std_logic_vector(7 downto 0);
		DATA_OUT : OUT std_logic_vector(15 downto 0)
		);
END COMPONENT;

SIGNAL SB_dp, En2, En2_dp : std_logic;
SIGNAL data_reg1_in, data_reg2_in, data_reg3_in, data_reg0_out, data_reg1_out, data_reg2_out, data_reg3_out : std_logic_vector(15 downto 0);

BEGIN

decod : decodifica PORT MAP(WR, SB_dp, ADD, En0, En2_dp);

reg0 : reg_crc PORT MAP(CLK, RST, En0, MOSI, (others => '0'), data_reg0_out);	-- data in register

reg1 : reg_crc PORT MAP(CLK, RST_reg1, En1, data_reg1_in, (others => '1'), data_reg1_out);	-- data out register

reg2 : reg_crc PORT MAP(CLK, RST, En2, data_reg2_in, (others => '0'), data_reg2_out);	-- control register (scrivendo '1' nel LSB causa il reset del CRC)

reg3 : reg_crc PORT MAP(CLK, RST, En3, data_reg3_in, "0000000000000001", data_reg3_out);	-- status register ('1' nel LSB significa che il calcolatore di CRC è pronto a ricevere una nuova parola

crc : crc_hardware PORT MAP(CLK, RST, LD, SE, data_reg0_out, data_reg1_in);

mux_uscita : selettore_uscita PORT MAP(CLK, RD, data_reg0_out, data_reg1_out, data_reg2_out, data_reg3_out, ADD, MISO);

contatore : counter_crc PORT MAP(CLK, RST_CNT, CE, TC);


En2 <= En2_cu WHEN s_mux = '1' ELSE En2_dp;
data_reg2_in <=  data_reg2_out(15 downto 1) & '0' WHEN s_mux = '1' ELSE MOSI;
RB <= data_reg2_out(0);		-- reset bit
 
SB_dp <= data_reg3_out(0);	-- control bit
data_reg3_in <= data_reg3_out(15 downto 1) & SB_IN;


END ARCHITECTURE;