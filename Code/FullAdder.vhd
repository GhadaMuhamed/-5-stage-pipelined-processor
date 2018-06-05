LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY FUlladder IS 
		GENERIC (N            : INTEGER :=16    ); 
		PORT (A,B 	      :  IN   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		      CIN             :  IN   STD_LOGIC;
			S             :  OUT   STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		      COUT            :  OUT  STD_LOGIC);    
END ENTITY FUlladder;
ARCHITECTURE DATA_FLOW OF FUlladder IS 
COMPONENT adder IS  
		PORT (A,B,CIN 	      :  IN   std_logic;
		      COUT,S          :  OUT  STD_LOGIC);    
END COMPONENT adder;
SIGNAL TEMP : STD_LOGIC_VECTOR (N-1 DOWNTO 0);
BEGIN 
	ADD1:adder PORT MAP(A(0),B(0),CIN,TEMP(0),S(0));
	loop1: FOR I IN 1 TO N-1 GENERATE
		ADD:adder PORT MAP(A(I),B(I),TEMP(I-1),TEMP(I),S(I));
	   END GENERATE ;
	COUT<= TEMP(N-1);	
END ARCHITECTURE DATA_FLOW;