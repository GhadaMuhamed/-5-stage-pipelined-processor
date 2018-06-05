LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY DFF IS
PORT( 
d:IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
en:IN STD_LOGIC; --enable
clk:IN STD_LOGIC; --clock
clr: IN STD_LOGIC; --async clear
q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0) --output 
);
END DFF;

ARCHITECTURE ArchRegister OF DFF IS
BEGIN
PROCESS(clk,clr,en)
BEGIN
IF(clr = '1') THEN
        q <= (OTHERS=>'0');
ELSIF  rising_edge(clk) AND en='1' THEN     
 	    q <= d;
END IF;
END PROCESS;
END ArchRegister;