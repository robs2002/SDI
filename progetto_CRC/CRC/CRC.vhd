LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY CRC IS
PORT(
	CLK, RST_SW : IN std_logic;
	RD, WR : IN std_logic;
	mosi : IN std_logic_vector(15 downto 0);
	miso : OUT std_logic_vector(15 downto 0);
	add : IN std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE behavior OF CRC IS

COMPONENT datapath IS
PORT(
	CLK, RST, RST_reg1, RST_CNT, LD, SE, CE, En1, En2_cu, En3, SB_IN, WR, RD, s_mux: IN std_logic;
	TC, RB : OUT std_logic;
	En0 : BUFFER std_logic;
	MOSI : IN std_logic_vector(15 downto 0);
	ADD : IN std_logic_vector(7 downto 0);
	MISO : OUT std_logic_vector(15 downto 0)
	);
END COMPONENT;

COMPONENT cu IS
PORT(
	CLK, RST_SW, TC, RB, En0 : IN std_logic;
	RST, RST_reg1, RST_CNT, LD, SE, CE, En1, En2_cu, En3, SB_IN, s_mux : OUT std_logic
	);
END COMPONENT;


SIGNAL RST, RST_reg1, RST_CNT, LD, SE, CE, En1, En2_cu, En3, SB_IN, s_mux, TC, RB, En0 : std_logic;

BEGIN

dp : datapath PORT MAP(CLK, RST, RST_reg1, RST_CNT, LD, SE, CE, En1, En2_cu, En3, SB_IN, WR, RD, s_mux, TC, RB, En0, mosi, add, miso);

control_unit : cu PORT MAP(CLK, RST_SW, TC, RB, En0, RST, RST_reg1, RST_CNT, LD, SE, CE, En1, En2_cu, En3, SB_IN, s_mux);


END ARCHITECTURE;