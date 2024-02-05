LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY datapath_crc IS
PORT(
	CLK, RST, RST_reg1, RST_reg5, RST_CNT, LD, SE, CE, En1, En2_cu, En3, En4, En5, SB_IN, WR, RD, s_mux, s_crc: IN std_logic;
	TC, RB, mode_bit : OUT std_logic;
	En0 : BUFFER std_logic;
	DIN : IN std_logic_vector(15 downto 0);
	ADDRESS : IN std_logic_vector(7 downto 0);
	DOUT : OUT std_logic_vector(15 downto 0)
	);
END ENTITY;

ARCHITECTURE behavior OF datapath_crc IS

COMPONENT crc_hardware IS	-- modulo in cui viene calcolato il crc
PORT(
	CLK, LD, SE, S_CRC : IN std_logic;
	data_in, data_old : IN std_logic_vector(15 downto 0);
	data_out : BUFFER std_logic_vector(15 downto 0)
	);
END COMPONENT;

COMPONENT counter IS
GENERIC ( N: INTEGER:= 4);
PORT ( Enable, Clock,Reset: IN STD_LOGIC;
       Q: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END COMPONENT;

COMPONENT reg_crc IS	-- registro
	PORT (
		CLK, RST, EN : IN std_logic;
		D : IN std_logic_vector(15 downto 0);
		RST_STATE : IN std_logic_vector(15 downto 0);	-- valore di inizializzazione del reset
		Q : OUT std_logic_vector(15 downto 0)
		);
END COMPONENT;

COMPONENT decodifica IS		-- blocco combinatorio per fare in modo che il blocco SPI possa scrivere nei registri 0 e 2
	PORT (
		WR, SB : IN std_logic;
		ADDRESS : IN std_logic_vector(7 downto 0);
		EN1, EN2 : OUT std_logic
		);
END COMPONENT;

COMPONENT selettore_uscita IS	-- blocco combinatorio per fare in modo che il blocco SPI possa leggere dai registri 0, 1, 2 e 3
	PORT (
		CLK, RD : IN std_logic;
		IN0, IN1, IN2, IN3 : IN std_logic_vector(15 downto 0);
		ADDRESS : IN std_logic_vector(7 downto 0);
		DATA_OUT : OUT std_logic_vector(15 downto 0)
		);
END COMPONENT;

SIGNAL SB_dp, En2, En2_dp : std_logic;
SIGNAL crc_out, data_reg2_in, data_reg3_in, crc_in, data_reg1_out, data_reg2_out, data_reg3_out, data_reg4_out, data_reg5_in, data_reg5_out : std_logic_vector(15 downto 0);
SIGNAL count : std_logic_vector(3 downto 0);

BEGIN

decod : decodifica PORT MAP(WR, SB_dp, ADDRESS, En0, En2_dp);

reg0 : reg_crc PORT MAP(CLK, RST, En0, DIN, (others => '0'), crc_in);	-- data in register

reg1 : reg_crc PORT MAP(CLK, RST_reg1, En1, crc_out, (others => '1'), data_reg1_out);	-- data out register

reg2 : reg_crc PORT MAP(CLK, RST, En2, data_reg2_in, (others => '0'), data_reg2_out);	-- control register (scrivendo '1' nel LSB causa il reset del CRC)

reg3 : reg_crc PORT MAP(CLK, RST, En3, data_reg3_in, "0000000000000001", data_reg3_out);	-- status register ('1' nel LSB significa che il calcolatore di CRC è pronto a ricevere una nuova parola)

reg4 : reg_crc PORT MAP(CLK, RST, En4, crc_out, (others => '0'), data_reg4_out);		-- viene salvato il calcolo parziale del crc

reg5 : reg_crc PORT MAP(CLK, RST_reg5, En5, data_reg5_in, (others => '0'), data_reg5_out);	-- bit_mode ('1' nel LSB significa che il crc sta lavorando con parole consecutive)

crc : crc_hardware PORT MAP(CLK, LD, SE, s_crc, crc_in, data_reg4_out, crc_out);

mux_uscita : selettore_uscita PORT MAP(CLK, RD, crc_in, data_reg1_out, data_reg2_out, data_reg3_out, ADDRESS, DOUT);

contatore : counter GENERIC MAP (4) PORT MAP(CE, CLK, RST_CNT, count);
TC <= '1' WHEN (count = "1111" ) ELSE '0';	


En2 <= En2_cu WHEN s_mux = '1' ELSE En2_dp;		
data_reg2_in <=  data_reg2_out(15 downto 1) & '0' WHEN s_mux = '1' ELSE DIN;
RB <= data_reg2_out(0);		-- reset bit
 
SB_dp <= data_reg3_out(0);	-- control bit
data_reg3_in <= data_reg3_out(15 downto 1) & SB_IN;

data_reg5_in <=  data_reg5_out(15 downto 1) & '1';
mode_bit <= data_reg5_out(0);		-- bit per modalità di esecuzione


END ARCHITECTURE;