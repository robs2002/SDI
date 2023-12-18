library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY fft IS
PORT(
	X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15, W0, W1, W2, W3, W4, W5, W6, W7 : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
	Start, Clock, Reset : IN STD_LOGIC;
	Done : OUT STD_LOGIC;
	X0p, X1p, X2p, X3p, X4p, X5p, X6p, X7p, X8p, X9p, X10p, X11p, X12p, X13p, X14p, X15p: OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
);
END fft;

ARCHITECTURE Behavior OF fft IS

COMPONENT butterfly_element IS
PORT(
	A, B, W : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
	Start, Clock, Reset : IN STD_LOGIC;
	Done : OUT STD_LOGIC;
	A_p, B_p : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
);
END COMPONENT;

SIGNAL X01, X01s, X02, X03, X1_1, X11s, X1_2, X1_3, X21, X21s, X22, X23, X31, X31s, X32, X33, X41, X41s, X42, X43, X51, X51s, X52, X53, 
X61, X61s, X62, X63, X71, X71s, X72, X73, X81, X81s, X82, X83, X91, X91s, X92, X93, X101, X101s, X102, X103, X111, X111s, X112, X113, 
X121, X121s, X122, X123, X131, X131s, X132, X133, X141, X141s, X142, X143, X151, X151s, X152, X153: STD_LOGIC_VECTOR(23 DOWNTO 0);

SIGNAL D01, D02, D03, D04, D11, D12, D13, D14, D21, D22, D23, D24, D31, D32, D33, D34, D41, D42, D43, D44, D51, D52, D53, D54,
D61, D62, D63, D64, D71, D72, D73, D74 : STD_LOGIC;

BEGIN

b0: butterfly_element PORT MAP( X0, X8, W0, Start, Clock, Reset, D01, X01, X81 );
b1: butterfly_element PORT MAP( X1, X9, W0, Start, Clock, Reset, D11, X1_1, X91 );
b2: butterfly_element PORT MAP( X2, X10, W0, Start, Clock, Reset, D21, X21, X101 );
b3: butterfly_element PORT MAP( X3, X11, W0, Start, Clock, Reset, D31, X31, X111 );
b4: butterfly_element PORT MAP( X4, X12, W0, Start, Clock, Reset, D41, X41, X121 );
b5: butterfly_element PORT MAP( X5, X13, W0, Start, Clock, Reset, D51, X51, X131 );
b6: butterfly_element PORT MAP( X6, X14, W0, Start, Clock, Reset, D61, X61, X141 );
b7: butterfly_element PORT MAP( X7, X15, W0, Start, Clock, Reset, D71, X71, X151 );

X01s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X01(23 DOWNTO 1)),24));
X11s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X1_1(23 DOWNTO 1)),24));
X21s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X21(23 DOWNTO 1)),24));
X31s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X31(23 DOWNTO 1)),24));
X41s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X41(23 DOWNTO 1)),24));
X51s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X51(23 DOWNTO 1)),24));
X61s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X61(23 DOWNTO 1)),24));
X71s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X71(23 DOWNTO 1)),24));
X81s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X81(23 DOWNTO 1)),24));
X91s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X91(23 DOWNTO 1)),24));
X101s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X101(23 DOWNTO 1)),24));
X111s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X111(23 DOWNTO 1)),24));
X121s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X121(23 DOWNTO 1)),24));
X131s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X131(23 DOWNTO 1)),24));
X141s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X141(23 DOWNTO 1)),24));
X151s <= STD_LOGIC_VECTOR(RESIZE(SIGNED(X151(23 DOWNTO 1)),24));

b01: butterfly_element PORT MAP( X01S, X41S, W0, D01, Clock, Reset, D02, X02, X42 );
b11: butterfly_element PORT MAP( X11S, X51S, W0, D11, Clock, Reset, D12, X1_2, X52 );
b21: butterfly_element PORT MAP( X21S, X61S, W0, D21, Clock, Reset, D22, X22, X62 );
b31: butterfly_element PORT MAP( X31S, X71S, W0, D31, Clock, Reset, D32, X32, X72 );
b41: butterfly_element PORT MAP( X81S, X121S, W4, D41, Clock, Reset, D42, X82, X122 );
b51: butterfly_element PORT MAP( X91S, X131S, W4, D51, Clock, Reset, D52, X92, X132 );
b61: butterfly_element PORT MAP( X101S, X141S, W4, D61, Clock, Reset, D62, X102, X142 );
b71: butterfly_element PORT MAP( X111S, X151S, W4, D71, Clock, Reset, D72, X112, X152 );

b02: butterfly_element PORT MAP( X02, X22, W0, D02, Clock, Reset, D03, X03, X23 );
b12: butterfly_element PORT MAP( X1_2, X32, W0, D12, Clock, Reset, D13, X1_3, X33 );
b22: butterfly_element PORT MAP( X42, X62, W4, D22, Clock, Reset, D23, X43, X63 );
b32: butterfly_element PORT MAP( X52, X72, W4, D32, Clock, Reset, D33, X53, X73 );
b42: butterfly_element PORT MAP( X82, X102, W2, D42, Clock, Reset, D43, X83, X103 );
b52: butterfly_element PORT MAP( X92, X112, W2, D52, Clock, Reset, D53, X93, X113 );
b62: butterfly_element PORT MAP( X122, X142, W6, D62, Clock, Reset, D63, X123, X143 );
b72: butterfly_element PORT MAP( X132, X152, W6, D72, Clock, Reset, D73, X133, X153 );

b03: butterfly_element PORT MAP( X03, X1_3, W0, D03, Clock, Reset, D04, X0p, X1p );
b13: butterfly_element PORT MAP( X23, X33, W4, D13, Clock, Reset, D14, X2p, X3p );
b23: butterfly_element PORT MAP( X43, X53, W2, D23, Clock, Reset, D24, X4p, X5p );
b33: butterfly_element PORT MAP( X63, X73, W6, D33, Clock, Reset, D34, X6p, X7p );
b43: butterfly_element PORT MAP( X83, X93, W1, D43, Clock, Reset, D44, X8p, X9p );
b53: butterfly_element PORT MAP( X103, X113, W5, D53, Clock, Reset, D54, X10p, X11p );
b63: butterfly_element PORT MAP( X123, X133, W3, D63, Clock, Reset, D64, X12p, X13p );
b73: butterfly_element PORT MAP( X143, X153, W7, D73, Clock, Reset, D74, X14p, X15p );

END Behavior;








