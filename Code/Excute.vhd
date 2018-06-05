Library ieee;
Use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY Excute IS  
Generic (n : integer :=16);
PORT (
ALU_SEL: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
Data1:IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
Data2:IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
CLK: IN STD_LOGIC;
RST : IN STD_LOGIC;
aluOut : OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0):=(others=>'0');
outport: IN std_logic;
flages: IN std_logic_vector(3 downto 0);
enFlag : in std_logic;
int: in std_logic;
outflages : out  std_logic_vector (3 downto 0);
spIn : out std_logic_vector(9 downto 0);
spOut : in std_logic_vector(9 downto 0);
outOutport:out std_logic_vector(15 downto 0);
inc : in std_logic;
out_data2: out  std_logic_vector(15 downto 0)
);    
END ENTITY Excute;
ARCHITECTURE ArchEx OF Excute IS


component stackreg IS
GENERIC ( n : integer := 10);
PORT( Clk,Rst        : IN std_logic;
		  EN : IN STD_LOGIC;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END component stackreg;


COMPONENT Alu IS
Generic (n : integer :=16);
PORT 
(
A : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
B : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
S : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
CLK: IN STD_LOGIC;
RST : IN STD_LOGIC;
flages: IN std_logic_vector(3 downto 0);
enFlag : in std_logic;
Flag_out : OUT std_logic_vector(3 DOWNTO 0);
F : OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0):=(others=>'0')
);
END COMPONENT Alu;

component nDFFrising IS
GENERIC ( n : integer := 17);
PORT( Clk,Rst        : IN std_logic;
		  EN : IN STD_LOGIC;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END component nDFFrising;


COMPONENT mux2 IS  
Generic (n : integer :=16);
PORT (
IN1,IN2: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SEl:IN STD_LOGIC;
OUT1:OUT  STD_LOGIC_VECTOR(n-1 DOWNTO 0)
);    
END COMPONENT;

signal Mux_IN1,Mux_IN2,outdata2: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
signal outflag :std_logic_vector(3 downto 0);
signal enablestack :std_logic;
BEGIN
outflages<=outflag;
Mux_IN1<=data2;
Mux_IN2<="00"&outflag&data2(9 downto 0);
ALu_Block: Alu PORT MAP(Data1,Data2,ALU_SEL,CLK,RST,flages,enFlag,outflag,aluOut);
Mux : Mux2 PORT MAP(Mux_IN1,Mux_IN2,int,outdata2);
outPortR:nDFFrising generic map (n=>16) port map(clk,rst,outport,data1,outOutport);
spin<= spout when inc='0'
else spout+'1' ;
out_data2<=outdata2;
---enablestack<=spdec xor spinc;

---stack: nDFFrising generic map (n=>10) port map(clk,rst,enablestack,);
END ArchEx;

