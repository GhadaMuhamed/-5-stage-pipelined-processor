LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux4 IS  
Generic (n : integer :=16);
PORT (
IN1,IN2,IN3,IN4: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SEl:IN STD_LOGIC_VECTOR(1 DOWNTO 0);
OUT1:OUT  STD_LOGIC_VECTOR(n-1 DOWNTO 0)
);    
END ENTITY mux4;


ARCHITECTURE ArchMux OF mux4 IS
BEGIN
OUT1 <= IN1 WHEN SEl="00"
ELSE IN2 WHEN SEl="01"
ELSE IN3 WHEN SEl="10"
ELSE IN4;
END ArchMux;