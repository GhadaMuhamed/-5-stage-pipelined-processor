LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity decrement is
port ( 
	dataIn	: in std_logic_vector(9 downto 0);
	dataOut	: out std_logic_vector(9 downto 0));
end decrement;

Architecture decArch of decrement is 
signal cout:std_logic;
begin
	out0: entity work.fullAdder2 generic map (n => 10) port map(dataIn,"1111111111",'0',cout,dataOut);
	
END decArch;