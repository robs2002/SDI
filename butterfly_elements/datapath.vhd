library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY datapath IS
    PORT ( A, B, D : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
	   C, Clock, Rst, mux_a, mux_s1 : IN STD_LOGIC;
	   mux_s2: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
           A_OUT : OUT STD_LOGIC_VECTOR (48 DOWNTO 0);
	   S_OUT : OUT STD_LOGIC_VECTOR (48 DOWNTO 0)
	);
END datapath;

ARCHITECTURE Behavioral OF datapath IS

COMPONENT subtractor IS
GENERIC( N: INTEGER:=47);
    PORT ( A : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
           B : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	   Clock, Reset : IN STD_LOGIC;
           Result : OUT STD_LOGIC_VECTOR (N DOWNTO 0)
);
END COMPONENT;

COMPONENT multiplier IS
GENERIC( N: INTEGER:=24);
    PORT ( A : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
           B : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	   C, Clock, Rst : IN STD_LOGIC;
           Result_m : OUT STD_LOGIC_VECTOR (2*N-2 DOWNTO 0);
	   Result_s : OUT STD_LOGIC_VECTOR (2*N-2 DOWNTO 0)
);
END COMPONENT;

COMPONENT adder IS
GENERIC( N: INTEGER:=47);
    PORT ( A : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
           B : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	   Clock, Reset : IN STD_LOGIC;
           Result : OUT STD_LOGIC_VECTOR (N DOWNTO 0)
);
END COMPONENT;
     
COMPONENT reg IS
GENERIC( N : INTEGER:=16); 
  PORT ( R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	 Clock,Reset: IN STD_LOGIC; 
	 Q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END COMPONENT;

SIGNAL mm, ms: STD_LOGIC_VECTOR (46 DOWNTO 0);
SIGNAL ad, ad1, dd, ar, s_mm, s_ms, su, su1, su2, r_mm, r_ms, r_ad, r_su : STD_LOGIC_VECTOR (48 DOWNTO 0);

BEGIN

mult: multiplier GENERIC MAP(24) PORT MAP(A, B, C, Clock, Rst, mm, ms);

dd <= STD_LOGIC_VECTOR(RESIZE(SIGNED(D),49));

mux1: PROCESS(mux_a, ad, dd)
      BEGIN
        IF (mux_a='0') THEN
	 ad1 <= ad;
        ELSE
	 ad1 <= dd;
        END IF;
      END PROCESS;

add1: adder GENERIC MAP(49) PORT MAP(ad1, dd, Clock, Rst, ad);

s_mm <= STD_LOGIC_VECTOR(RESIZE(SIGNED(mm),49));
s_ms <= STD_LOGIC_VECTOR(RESIZE(SIGNED(ms),49));

mux2: PROCESS(mux_s1, ad, s_ms)
      BEGIN
	IF (mux_s1='0') THEN
	 su1 <= ad;
        ELSE
	 su1 <= s_ms;
        END IF;
      END PROCESS;

mux3: PROCESS(mux_s2, ad, su, s_mm)
      BEGIN
        IF (mux_s2="00") THEN
	 su2 <= ad;
	ELSIF (mux_s2="01") THEN
	 su2 <=su;
	ELSIF (mux_s2="10") THEN
	 su2 <=s_mm;
        ELSE
	 su2 <= su2; 
        END IF;
      END PROCESS;

sub1: subtractor GENERIC MAP(49) PORT MAP(su1, su2, Clock, Rst, su);

regmm: reg GENERIC MAP(47) PORT MAP( mm, Clock, Rst, r_mm );
regms: reg GENERIC MAP(47) PORT MAP( ms, Clock, Rst, r_ms );
regad: reg GENERIC MAP(49) PORT MAP( ad, Clock, Rst, r_ad );
regsu: reg GENERIC MAP(49) PORT MAP( su, Clock, Rst, r_su );
  
end Behavioral;




