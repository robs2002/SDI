LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY microrom IS
PORT(
  address : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  data_out : OUT STD_LOGIC_VECTOR(28 DOWNTO 0)
);
END microrom;

ARCHITECTURE Behavioral OF microrom IS

TYPE memory IS ARRAY(0 TO 15) OF STD_LOGIC_VECTOR(28 DOWNTO 0);

constant myrom : memory := (
0 =>  "00001000000000000000000000000" ,
1 =>  "01000000000000000000000000001" ,
2 =>  "00000000000000101010000000000" , 
3 =>  "00000100000000010101000000000" , 
4 =>  "00000101000000000000000000000" , 
5 =>  "00000111000000000000100000000" , 
6 =>  "00000110010000000000100000000" , 
7 =>  "00000000100000000000110000000" , 
8 =>  "00010000000100000000110000000" ,
9 =>  "01010010000000000000001101101" ,
10 => "00000000001000101010011010000" , 
11 => "00000100001010010101000100000" , 
12 => "10100101000001000000000100101" , 
13 => "00000000001000000000011010000" , 
14 => "00000000001010000000000100000" , 
15 => "10100000000001000000000100001" ) ;

BEGIN

data_out <= myrom(TO_INTEGER(UNSIGNED(address)));


END Behavioral;