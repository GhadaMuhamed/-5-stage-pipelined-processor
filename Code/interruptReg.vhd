library ieee;
use ieee.std_logic_1164.all;
entity intReg is
Generic (n : integer :=16);
port (	d : 	in std_logic_vector(n-1 downto 0);
	clk,E:in std_logic;
	addr : in std_logic_vector(9 downto 0);
	q:	out std_logic_vector(n-1 downto 0));
end intReg;

architecture intStore of intReg is 
begin
	process(clk)
	begin
		if 	E='1' and rising_edge(clk) then
				if(addr = "0000000001") then
					q <= d;
				end if;
		end if;
	end process;
 	
end intStore;
