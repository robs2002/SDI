library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--moltiplicatore 2 registri
--shifter 1 registro
--pipeline

ENTITY multiplier IS
GENERIC(N: INTEGER:=24);
    PORT ( A : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
           B : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	   C, Clock : IN STD_LOGIC;
           Result_m : out STD_LOGIC_VECTOR (2*N-2 DOWNTO 0);
	   Result_s : out STD_LOGIC_VECTOR (2*N-1 DOWNTO 0)
);
END multiplier;

--C=0 moltiplicazione normale
--C=1 moltiplicazione per 2, shifter 

ARCHITECTURE Behavioral of multiplier is

SIGNAL A_s, B_s: SIGNED (N-1 DOWNTO 0);
SIGNAL rs_p: SIGNED (2*N-1 DOWNTO 0);
SIGNAL rs_m, rs_mm:STD_LOGIC_VECTOR (2*N-2 DOWNTO 0);
SIGNAL rs_s:STD_LOGIC_VECTOR (2*N-1 DOWNTO 0);
SIGNAL A_ss,A_sss: SIGNED (N DOWNTO 0);
SIGNAL prs: STD_LOGIC_VECTOR(N DOWNTO 0);

BEGIN
		
	A_s <= SIGNED(A);
	B_s <= SIGNED(B);
	A_ss <= '0' & A_s;

	rs_p <= A_s * B_s;
        rs_m <= STD_LOGIC_VECTOR(RESIZE(rs_p, Result_m'LENGTH));

	A_sss <= A_ss sll 1;

	rs_s <= STD_LOGIC_VECTOR(A_sss) & "00000000000000000000000";

	shift: PROCESS(Clock)
	BEGIN
	IF (Clock'EVENT AND Clock = '1') THEN
		IF (C='1') THEN
		Result_s <= rs_s;
		END IF;
	END IF;
	END PROCESS;

	pipe1: PROCESS(Clock)
	BEGIN
	IF (Clock'EVENT AND Clock = '1') THEN
		IF (C='0') THEN
		rs_mm <= rs_m;
		END IF;
	END IF;
	END PROCESS;

	pipe2: PROCESS(Clock)
	BEGIN	
	IF (Clock'EVENT AND Clock = '1') THEN
		Result_m <= rs_mm;
	END IF;
	END PROCESS;

end Behavioral;



