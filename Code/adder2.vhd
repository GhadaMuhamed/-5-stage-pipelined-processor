library ieee;
use ieee.std_logic_1164.all;

entity Adder2 is
	port (	a,b,cin	: in std_logic;
		F,cout 	: out std_logic);
end Adder2;

architecture add of Adder2 is
begin 
	process (a,b,cin)
	begin 
		F <= a xor b xor cin;
		cout <= (a and b) or (cin and (a xor b));
	end process;
end add;