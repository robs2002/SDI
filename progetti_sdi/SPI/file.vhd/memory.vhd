LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY memory IS
PORT(
  clk, RD, WRn, RST_M : IN STD_LOGIC;
  address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
  data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END memory;

ARCHITECTURE Behavioral OF memory IS

TYPE arr_type IS ARRAY(0 TO 255) OF STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL mem: arr_type;

BEGIN

PROCESS(clk,RD,RST_M)

BEGIN
    IF RST_M ='1' THEN
		FOR riga IN 0 TO 255 LOOP
			mem(riga) <= (OTHERS => '0');
		END LOOP;
	 ELSE 	
		 IF RD = '1' THEN
				data_out <= mem(TO_INTEGER(UNSIGNED(address)));
		 END IF;
		 IF (clk'EVENT AND clk = '1') THEN
		 IF WRn = '0' THEN
				mem(TO_INTEGER(UNSIGNED(address))) <= data_in;
		 END IF;
		 END IF;
	 END IF;

END PROCESS;

END Behavioral;
