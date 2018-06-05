LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY DFF_F IS
PORT( 
d:IN STD_LOGIC; 
en:IN STD_LOGIC; --enable
clk:IN STD_LOGIC; --clock
clr: IN STD_LOGIC; --async clear
q : OUT STD_LOGIC  --output 
);
END DFF_F;

ARCHITECTURE ArchRegister OF DFF_F IS
BEGIN
PROCESS(clk,clr,en)
BEGIN
IF(clr = '1') THEN
        q <= '0';
ELSIF  falling_edge(clk) AND en='1' THEN     
 	    q <= d;
END IF;
END PROCESS;
END ArchRegister;
