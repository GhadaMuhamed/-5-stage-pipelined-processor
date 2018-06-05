LIBRARY ieee;
Use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;



ENTITY Alu IS
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
END ENTITY Alu;

ARCHITECTURE ArchAlu OF Alu IS


COMPONENT FUlladder IS 
		GENERIC (N            : INTEGER :=16    ); 
		PORT (A,B 	      :  IN   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		      CIN             :  IN   STD_LOGIC;
			S             :  OUT   STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		      COUT            :  OUT  STD_LOGIC);    
END COMPONENT FUlladder;

COMPONENT DFF IS
PORT( 
d:IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
en:IN STD_LOGIC; --enable
clk:IN STD_LOGIC; --clock
clr: IN STD_LOGIC; --async clear
q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0) --output 
);
END COMPONENT;
COMPONENT DFF_F IS
PORT( 
d:IN STD_LOGIC; 
en:IN STD_LOGIC; --enable
clk:IN STD_LOGIC; --clock
clr: IN STD_LOGIC; --async clear
q : OUT STD_LOGIC  --output 
);
END COMPONENT DFF_F;

signal Result : std_logic_vector(n-1 downto 0);   --l sum w l sub
signal D_CNZV,Q_CNZV : std_logic_vector(3 DOWNTO 0):=(others=>'0');
signal output:  std_logic_vector(2*n-1 DOWNTO 0);
signal zeros: std_logic_vector(n-1 DOWNTO 0):=(others=>'0');
signal bb1,bb2 : std_logic_vector (15 downto 0);
signal carryV,enableflag,carry ,outc,inp,nooperand: std_logic;

BEGIN

extraflag: DFF_F generic map (n=>1) port map(Q_CNZV(3),enableflag,clk,rst,outc);
enableflag<='0' when s="0000" or s="0001"
else '1' ;
Flags: DFF PORT MAP(D_CNZV,enableflag,CLK,RST,Q_CNZV);

bb1<=a when s="0010" or s="0100"
else b ;

bb2<= b when s="0010" 
else not b when s="0100"
else "1111111111111110" when s="1101"
else "0000000000000001";
inp<= '1' when s="0100" or s="1101"
else '0';

add :  FullAdder PORT MAP(BB1,bb2,inp,Result,carry);


output<= EXT(A,2*n) WHEN S="0000"  --mov A
else EXT(B,2*n) WHEN S="0001"  --move B
else EXT(Result,2*n) WHEN S="0010" --Add or Sub
else EXT(Result,2*n) when s="0100"
else (A * B) WHEN S="0011"     --mult
else EXT((A AND B),2*n) WHEN S="0101"   -- And
else EXT((A OR B),2*n) WHEN S="0110"  --or
else EXT((B(n-2 DOWNTO 0)& outc),2*n) WHEN S="0111"  --Rotate left 
else EXT((A(n-1-(to_integer(IEEE.numeric_std.unsigned( B))) DOWNTO 0) & zeros( to_integer(IEEE.numeric_std.unsigned( B))-1 downto 0)),2*n) WHEN S="1000"  --shift left


else EXT((zeros( to_integer(IEEE.numeric_std.unsigned( B))-1 downto 0) & A(n-1 DOWNTO (to_integer(IEEE.numeric_std.unsigned( B ))))),2*n) WHEN S="1001"  -- Shift right
else EXT( (outc & B(n-1 DOWNTO 1)),2*n) WHEN S="1010"  --Rotate right 
else EXT((Not B),2*n) WHEN S="1011"
else EXT(Result,2*n) WHEN S="1100" or S="1101"
else EXT(b,2*n);
nooperand<=s(3) and s(2) and s(1);

D_CNZV(2)<=output(n-1)when enFlag='0' and nooperand='0'
else flages(2) when enflag='1'
else '0';



D_CNZV(1)<= '1' WHEN (output="00000000000000000000000000000000"and enFlag='0') and nooperand='0'
else '0' when enflag='0'
else flages(1);

carryv<=  b(15) xnor a(15);

D_CNZV(0)<=b(15) XOR output(15) when (S="1011" or s="1100" or s="1101" or s="0111" or s="1010")  and enflag='0'
else carryv and (b(15) xor output(31)) when ( s="0011" and enflag='0')
else carryv and (b(15) xor output(15)) when ( enflag='0')
else flages(0) when enflag='1';

D_CNZV(3)<= carry WHEN  (s="0010" or s="0100" or s="1101" or s="1100")and enflag='0' --add or sub or inc or dec
else '1' WHEN  (S="1110" and enflag='0') --set 
else '0' WHEN  (S="1111" and enflag='0') --clr
else b(15)   when (S="0111" and enflag='0') --rl
else b(0)  when (S="1010" and enflag='0')--rr
else '0' when   enflag='0'
else flages(3) when enflag='1';

F<=output;
Flag_out<=Q_CNZV;

END ArchAlu;