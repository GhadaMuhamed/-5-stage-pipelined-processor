LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY ADDER IS  
		PORT (A,B,CIN 	      :  IN   std_logic;
		      COUT,S          :  OUT  STD_LOGIC);    
END ENTITY ADDER;
ARCHITECTURE DATA_FLOW OF ADDER IS 

BEGIN 
	 PROCESS (a,b,cin)
         BEGIN               
         s <= a XOR b XOR cin;               
         cout <= (a AND b) or (cin AND (a XOR b));     
         END PROCESS;

END ARCHITECTURE DATA_FLOW;