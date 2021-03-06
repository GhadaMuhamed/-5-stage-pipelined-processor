LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
ENTITY mem IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(9 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY mem;

ARCHITECTURE memArch OF mem IS

	TYPE mem_type IS ARRAY(0 TO 1023) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL memoryEntry : mem_type := ( 
  		OTHERS => X"0000" 
		); 
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF we = '1' THEN
			memoryEntry(to_integer(unsigned(address))) <= datain(15 downto 0);
					END IF;
				END IF;
		END PROCESS;
		dataout(15 downto 0) <= memoryEntry(to_integer(unsigned(address)));
END memArch;
