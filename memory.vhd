LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY memory is
port(
  clk, RD, WRn : in std_logic;
  address : in std_logic_vector(7 downto 0);
  data_in : in std_logic_vector(15 downto 0);
  data_out : out std_logic_vector(15 downto 0)
);
end memory;

ARCHITECTURE Behavioral OF memory IS

type arr_type is array(0 to 255) of std_logic_vector(15 downto 0);

signal mem: arr_type;

BEGIN

PROCESS(clk)

BEGIN

    IF RD = '1' THEN
         data_out <= mem(to_integer(unsigned(address)));
    END IF;
    IF RISING_EDGE(clk) THEN
    IF WRn = '0' THEN
         mem(to_integer(unsigned(address))) <= data_in;
    END IF;
    END IF;

END PROCESS;

END Behavioral;
