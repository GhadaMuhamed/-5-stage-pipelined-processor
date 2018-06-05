
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity hazardDetectionUnit is 
	port (	DEWb ,DEMemRead,RsrcSig,RdstSig,ret: in std_logic;
		curPcEnb,curMemRead,DEPcEnb,EMPcEnb,EMMemRead: in std_logic;
		curRdst,curRsrc,DERdst : in std_logic_vector (2 downto 0);
		stall,pcEnb,FDenb,nop : out std_logic
	);
end hazardDetectionUnit;

architecture detection of hazardDetectionUnit is
signal loadCase : std_logic;
signal retCase1,retCase2 : std_logic;
begin
	loadCase <= '1' when DEWb = '1' and DEMemRead = '1' and (( RsrcSig= '1' and DERdst = curRsrc) or ( RdstSig= '1' and DERdst = curRdst)) 
		else '0'; 	
	retCase1 <= '1' when (curPcEnb = '1' and curMemRead = '1') or (DEPcEnb = '1' and DEMemRead = '1')
		else '0';
	retCase2 <= '1' when EMPcEnb = '1' and EMMemRead = '1'
		else '0';
	stall <= '1' when loadCase='1'
		else '0';
	nop <= '1' when retCase1='1' or retCase2='1'
		else '0';
	pcEnb <= '0' when loadCase='1' or retCase1='1'
		else '1';
	FDenb <= '0' when loadCase='1'
		else '1';
end detection;