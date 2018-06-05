LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


ENTITY RAM IS

PORT(           CLK  : IN std_logic;
                 WE  : IN std_logic;
	     ADDRESS : IN std_logic_vector(9 DOWNTO 0);
	     DATAOUT : OUT std_logic_vector(15 DOWNTO 0);
             DATAIN  : IN std_logic_vector(15 DOWNTO 0));

               
END RAM;

ARCHITECTURE DATAFLOW  OF RAM IS

TYPE RAM_TYPE IS ARRAY(0 TO 1023) of std_logic_vector(15 DOWNTO 0);
     SIGNAL RAM : RAM_TYPE :=(
  OTHERS => X"0000"
);

BEGIN
PROCESS (CLK)
BEGIN
	IF RISING_EDGE (CLK)THEN
		IF(WE='1')THEN
			RAM(to_integer(unsigned(ADDRESS)))<=DATAIN  ;
		END IF;
	END IF;	
END PROCESS;

DATAOUT <= RAM(to_integer(unsigned(ADDRESS))) ;

END DATAFLOW;