LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity regHazard is 
	port (	curRdst,curRsrc:	in std_logic_vector (2 downto 0);
		op			:	in std_logic_vector (1 downto 0);
		memRead,shift:	in std_logic;
		RsrcHazard,RdstHazard : out std_logic
		);
end regHazard;

architecture hazard of regHazard is
begin
	RsrcHazard <= '1' when curRsrc /= "111" and memRead = '0' and op /= "11" and op /= "10"
	else '0';
	RdstHazard <= '1' when shift = '0' and curRdst /= "111" and memRead='0'and op /= "00"
	else '0';

end hazard;