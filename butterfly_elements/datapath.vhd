library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY datapath IS
    PORT ( A, B, Wr, Wi : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
	   C, Clock, Rst, mux_pa, mux_m2, mux_s1, mux_ra, en1, en2, en3, en4, en5, en6, en7, en8, en9, en10, en11 : IN STD_LOGIC;
	   mux_m1, mux_a, mux_s2: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
           A_p, B_p : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	);
END datapath;

-- mux_pa da togliere

ARCHITECTURE Behavioral OF datapath IS

COMPONENT subtractor IS
GENERIC( N: INTEGER:=47);
    PORT ( A : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
           B : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	   Clock, Reset : IN STD_LOGIC;
           Result : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)
);
END COMPONENT;

COMPONENT multiplier IS
GENERIC( N: INTEGER:=24);
    PORT ( A : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
           B : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	   C, Clock, Rst : IN STD_LOGIC;
           Result_m : OUT STD_LOGIC_VECTOR (2*N-2 DOWNTO 0);
	   Result_s : OUT STD_LOGIC_VECTOR (2*N-1 DOWNTO 0)
);
END COMPONENT;

COMPONENT adder IS
GENERIC( N: INTEGER:=47);
    PORT ( A : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
           B : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	   Clock, Reset : IN STD_LOGIC;
           Result : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)
);
END COMPONENT;
     
COMPONENT reg IS
GENERIC( N : INTEGER:=16); 
   PORT (R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   Enable,Clock,Reset : IN STD_LOGIC; 
   Q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END COMPONENT;

COMPONENT round IS
PORT( DATA_IN : IN STD_LOGIC_VECTOR(49 DOWNTO 0);
	Clock, Reset : IN STD_LOGIC;
      DATA_OUT : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
);
END COMPONENT;

SIGNAL r_Ar, r_Ai, r_Br, r_Bi, r_Wr, r_Wi, M1, M2: STD_LOGIC_VECTOR (23 DOWNTO 0);
SIGNAL mm, r_mm, Ar_47, Ai_47: STD_LOGIC_VECTOR (46 DOWNTO 0);
SIGNAL ms, r_ms: STD_LOGIC_VECTOR (47 DOWNTO 0);
SIGNAL ad, AD1, s_mm, s_ms, su, SU1, SU2, r_ad, r_su, r_Around, r_Ain: STD_LOGIC_VECTOR (49 DOWNTO 0);

BEGIN

--mux_Aport: PROCESS(mux_pa, A, round_a)
 --     BEGIN
 --       IF (mux_pa='0') THEN
--	 reg_ar <= A;
 --       ELSE
--	 reg_ar <= round_a;
 --       END IF;
 --     END PROCESS;

--regAr: reg GENERIC MAP(24) PORT MAP( reg_ar, en1, Clock, Rst, r_Ar );

regAr: reg GENERIC MAP(24) PORT MAP( A, en1, Clock, Rst, r_Ar );
regAi: reg GENERIC MAP(24) PORT MAP( A, en2, Clock, Rst, r_Ai );
regBr: reg GENERIC MAP(24) PORT MAP( B, en3, Clock, Rst, r_Br );
regBi: reg GENERIC MAP(24) PORT MAP( B, en4, Clock, Rst, r_Bi );
regWr: reg GENERIC MAP(24) PORT MAP( Wr, en5, Clock, Rst, r_Wr );
regWi: reg GENERIC MAP(24) PORT MAP( Wi, en6, Clock, Rst, r_Wi );

muxM1: PROCESS(mux_m1, r_Ar, r_Ai, r_Br, r_Bi)
	BEGIN
	IF (mux_m1="00") THEN
		M1 <= r_Ar;
	ELSIF (mux_m1="01") THEN
		M1 <= r_Ai;
	ELSIF (mux_m1="10") THEN
		M1 <= r_Br;
        ELSE
		M1 <= r_Bi;
	END IF;
	END PROCESS;

muxM2: PROCESS(mux_m2, r_Wr, r_Wi)
	BEGIN
	IF (mux_m2='0') THEN
		M2 <= r_Wr;
	ELSE 
		M2 <= r_Wi;
	END IF;
	END PROCESS;

mult: multiplier GENERIC MAP(24) PORT MAP(M1, M2, C, Clock, Rst, mm, ms);
regmm: reg GENERIC MAP(47) PORT MAP( mm, en7, Clock, Rst, r_mm );
regms: reg GENERIC MAP(48) PORT MAP( ms, en9, Clock, Rst, r_ms );

Ai_47 <= r_Ai & "00000000000000000000000";
Ar_47 <= r_Ar & "00000000000000000000000";

mux_add: PROCESS(mux_a, r_ad, Ar_47, Ai_47)
      BEGIN
        IF (mux_a="00") THEN
	 AD1 <= r_ad;
	ELSIF (mux_a="01") THEN
	 AD1 <= Ar_47(46) & Ar_47(46) & Ar_47(46) & Ar_47;
	ELSIF (mux_a="10") THEN
	 AD1 <= Ai_47(46) & Ai_47(46) & Ai_47(46) & Ai_47;
        ELSE
	 AD1 <= (OTHERS => '0');
        END IF;
      END PROCESS;

s_mm <= r_mm(46) & r_mm(46) & r_mm(46) & r_mm;
s_ms <= r_ms(47) & r_ms(47) & r_ms;

add1: adder GENERIC MAP(50) PORT MAP(AD1, s_mm, Clock, Rst, ad);
regad: reg GENERIC MAP(50) PORT MAP( ad, en8, Clock, Rst, r_ad );

mux_sub1: PROCESS(mux_s1, r_ad, s_ms)
      BEGIN
	IF (mux_s1='0') THEN
	 SU1 <= r_ad;
        ELSE
	 SU1 <= s_ms;
        END IF;
      END PROCESS;

mux_sub2: PROCESS(mux_s2, r_ad, r_su, s_mm)
      BEGIN
        IF (mux_s2="00") THEN
	 SU2 <= r_su;
	ELSIF (mux_s2="01") THEN
	 SU2 <= r_ad;
	ELSIF (mux_s2="10") THEN
	 SU2 <= s_mm;
        ELSE
	 SU2 <= (OTHERS => '0'); 
        END IF;
      END PROCESS;

sub1: subtractor GENERIC MAP(50) PORT MAP(SU1, SU2, Clock, Rst, su);
regsu: reg GENERIC MAP(50) PORT MAP( su, en10, Clock, Rst, r_su );

regAround: reg GENERIC MAP(50) PORT MAP( r_su, en11, Clock, Rst, r_Ain );

mux_roundA: PROCESS(mux_ra, r_Ain, r_ad)
	     BEGIN
	      IF (mux_ra='1') THEN
	       r_Around <= r_Ain;
              ELSE
	       r_Around <= r_ad;
              END IF;
         END PROCESS;

roundA: round PORT MAP (r_Around, Clock, Rst, A_p);
roundB: round PORT MAP (r_su, Clock, Rst, B_p);
  
end Behavioral;




