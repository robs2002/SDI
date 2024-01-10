library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY round IS
PORT( DATA_IN : IN STD_LOGIC_VECTOR(49 DOWNTO 0);
	Clock : IN STD_LOGIC;
      DATA_OUT : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
);
END round;

ARCHITECTURE Behavior OF round IS

SIGNAL d: STD_LOGIC_VECTOR(49 DOWNTO 0);
SIGNAL dd: STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL t : STD_LOGIC;

BEGIN

d <= STD_LOGIC_VECTOR(RESIZE(SIGNED(DATA_IN(49 DOWNTO 1)),50)); --shift di uno
dd <= d(46 DOWNTO 23);

trova1: PROCESS(d)
BEGIN
FOR i IN 0 TO 22 LOOP
	  IF ( d(i)='1' ) THEN
	    t <= '1';
            EXIT;
	  ELSE
	    t <= '0';
	  END IF;
        END LOOP;
END PROCESS;

PROCESS(Clock)
BEGIN
IF(Clock'EVENT AND Clock='1') THEN
	IF ( d(22)='0' ) THEN --se il bit dopo LSB che tronco è 0 allora il numero approssimato è semplicemente il numero che ho
		DATA_OUT <= d(46 DOWNTO 23);
	ELSE --se il bit dopo LSB che tronco è allora controllo se siamo nella condizione di metà perfetta se non ci sono più 1 dopo quelli
		IF (t='1') THEN
			--devo fare più 1
	   	 DATA_OUT <= STD_LOGIC_VECTOR(SIGNED(dd)+ 1);
		ELSE 
			--vedo se il numero è pari o dispari e di conseguenza approssimo al pari più vicino
   	   	 	IF (dd(0)='1') THEN
				DATA_OUT <= STD_LOGIC_VECTOR(SIGNED(dd)+ 1);
	   	 	ELSE
	    			DATA_OUT <= d(46 DOWNTO 23);
	    		END IF;
		END IF;
	END IF;
END IF;
END PROCESS;

END Behavior;