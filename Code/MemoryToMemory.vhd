LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity MemoryForwardingUnit is 
	port (	curRdst,MWRdst:	in std_logic_vector (2 downto 0);
		MWwbDst,memWrite:	in std_logic;
		outDst:		out std_logic);
end MemoryForwardingUnit;

architecture forwardingM of MemoryForwardingUnit is
begin

	outDst <= '1' when memWrite = '1' and MWwbDst = '1' and curRdst = MWRdst
	else 	  '0';
end forwardingM;