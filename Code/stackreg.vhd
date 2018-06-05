
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY stackreg IS
GENERIC ( n : integer := 10);
PORT( Clk,Rst        : IN std_logic;
		  EN : IN STD_LOGIC;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END stackreg;

ARCHITECTURE stackregflow OF stackreg IS
BEGIN
PROCESS (Clk,Rst,EN)
BEGIN
IF Rst = '1' THEN
		q <= "1111111111";
ELSIF rising_edge(Clk)AND EN='1' THEN
		q <= d;
END IF;
END PROCESS;

END stackregflow;