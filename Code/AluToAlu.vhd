LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity decodeForwardingUnit is 
	port (	curRdst,curRsrc,DERsrc,DERdst,EMRsrc,EMRdst:	in std_logic_vector (2 downto 0);
		op 	:	in std_logic_vector (1 downto 0);
		curWbDst,curWbSrc,memRead,shift,DEwbSrc,DEwbDst,EMwbSrc,EMwbDst,RsrcSig,RdstSig:	in std_logic;
		outSrc,outDst:		out std_logic_vector(2 downto 0));
end decodeForwardingUnit;

architecture forwarding of decodeForwardingUnit is
signal RsrcForward,RdstForward : std_logic_vector(2 downto 0);
---signal	RsrcSig,RdstSig : std_logic;
begin
	---RsrcSig <= '1' when curRsrc /= "111" and memRead = '0' and op /= "11" and op /= "10"
	---else '0';
	---RdstSig <= '1' when shift = '0' and curRdst /= "111" and memRead='0'and op /= "00"
	---else '0';
	RsrcForward <= 	"000" when RsrcSig = '1' and (curRsrc = DERsrc and DEwbSrc = '1')
		else		"001" when RsrcSig = '1' and (curRsrc = DERdst and DEwbDst = '1') 
		else   		"010" when RsrcSig = '1' and (curRsrc = EMRsrc and EMwbSrc = '1')
		else		"011" when RsrcSig = '1' and (curRsrc = EMRdst and EMwbDst = '1') 
		else 		"100";
	RdstForward <= 	"000" when RdstSig = '1' and (curRdst = DERsrc and DEwbSrc = '1')
		else 		"001" when RdstSig = '1' and (curRdst = DERdst and DEwbDst = '1')
		else 		"010" when RdstSig = '1' and (curRdst = EMRsrc and EMwbSrc = '1')
		else 		"011" when RdstSig = '1' and (curRdst = EMRdst and EMwbDst = '1')
		else 		"100";
	outSrc <= RsrcForward;
	outDst <= RdstForward;
end forwarding;