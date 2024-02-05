LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY CRC IS
PORT(
	CLK, RST_SW : IN std_logic;
	RD, WR : IN std_logic;
	DIN : IN std_logic_vector(15 downto 0);
	DOUT : OUT std_logic_vector(15 downto 0);
	ADDRESS : IN std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE behavior OF CRC IS

COMPONENT datapath_crc IS
PORT(
	CLK, RST, RST_reg1, RST_reg5, RST_CNT, LD, SE, CE, En1, En2_cu, En3, En4, En5, SB_IN, WR, RD, s_mux, s_crc: IN std_logic;
	TC, RB, mode_bit : OUT std_logic;
	En0 : BUFFER std_logic;
	DIN : IN std_logic_vector(15 downto 0);
	ADDRESS : IN std_logic_vector(7 downto 0);
	DOUT : OUT std_logic_vector(15 downto 0)
	);
END COMPONENT;

COMPONENT cu_crc IS
PORT(
	CLK, RST_SW, TC, RB, En0, mode_bit : IN std_logic;
	RST, RST_reg1, RST_reg5, RST_CNT, LD, SE, CE, En1, En2_cu, En3, En4, En5, SB_IN, s_mux, s_crc : OUT std_logic
	);
END COMPONENT;


SIGNAL RST, RST_reg1, RST_reg5, RST_CNT, LD, SE, CE, En1, En2_cu, En3, En4, En5, SB_IN, s_mux, s_crc, TC, RB, mode_bit, En0 : std_logic;

BEGIN

dp : datapath_crc PORT MAP(CLK, RST, RST_reg1, RST_reg5, RST_CNT, LD, SE, CE, En1, En2_cu, En3, En4, En5, SB_IN, WR, RD, s_mux, s_crc, TC, RB, mode_bit, En0, DIN, ADDRESS, DOUT);

control_unit : cu_crc PORT MAP(CLK, RST_SW, TC, RB, En0, mode_bit, RST, RST_reg1, RST_reg5, RST_CNT, LD, SE, CE, En1, En2_cu, En3, En4, En5, SB_IN, s_mux, s_crc);


END ARCHITECTURE;