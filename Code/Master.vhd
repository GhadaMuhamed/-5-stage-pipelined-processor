LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY Master IS
PORT( Clk,Rst,interuupt       : IN std_logic;
regreset,regint : in std_logic_vector (9 downto 0)
); 
END Master;

architecture  FlowMaster of Master is 
component Excute IS  
Generic (n : integer :=16);
PORT (
ALU_SEL: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
Data1:INOUT  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
Data2:INOUT  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
CLK: IN STD_LOGIC;
RST : IN STD_LOGIC;
aluOut : OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0):=(others=>'0');
outport: IN std_logic;
flages: IN std_logic_vector(3 downto 0);
enFlag : in std_logic;
int: in std_logic;
outflages : out std_logic_vector (3 downto 0);
spIn : out std_logic_vector(9 downto 0);
spOut : in std_logic_vector(9 downto 0);
outOutport:out std_logic_vector(15 downto 0);
inc : in std_logic;
out_data2: out  std_logic_vector(15 downto 0)
);    
END component Excute;

component mux2 IS  
Generic (n : integer :=16);
PORT (
IN1,IN2: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SEl:IN STD_LOGIC;
OUT1:OUT  STD_LOGIC_VECTOR(n-1 DOWNTO 0)
);    
END component mux2;


component decodeForwardingUnit is 
	port (	curRdst,curRsrc,DERsrc,DERdst,EMRsrc,EMRdst:	in std_logic_vector (2 downto 0);
		op 	:	in std_logic_vector (1 downto 0);
		curWbDst,curWbSrc,memRead,shift,DEwbSrc,DEwbDst,EMwbSrc,EMwbDst,RsrcSig,RdstSig:	in std_logic;
		outSrc,outDst:		out std_logic_vector(2 downto 0));
end component decodeForwardingUnit;

component fetch is

port(Clk,Rst,reset,Taken,pcmem_wb,PC_en,LDM,Stalling,Interpt,ACK : in std_logic;
Reg0,Reg1,Rdes,Outmem_wb : in std_logic_vector(9 downto 0);
pc_out: out std_logic_vector(9 downto 0);
int :out std_logic;
ramout : out std_logic_vector(15 downto 0);
inst :out std_logic_vector(15 downto 0)
);
end  component fetch;


component decode IS
PORT( Clk,Rst,flagC,flagN,flagZ,stall,wB1,wb2,rst1,rst2        : IN std_logic;
	FEDE         : in std_logic_vector ( 27 downto 0);
	writeadd1,writeadd2 : in std_logic_vector (2 downto 0);
	outSignal    : out std_logic_vector(17 downto 0);
	aluoperation :out std_logic_vector (3 downto 0);
	data1,data2         : out std_logic_vector (15 downto 0);
	outadd1,outadd2     : out std_logic_vector (2 downto 0);
	inportdata,indata1,indata2 : in std_logic_vector (15 downto 0);
	immforldm : in std_logic_vector (15 downto 0);
	ackint :out std_logic;
	selRsrc,selRdst : in std_logic_vector (2 downto 0);
	RSRCalu,RDSTalu,memRSRC,memRDST : in  std_logic_vector (15  downto 0);

	outrdstfor : out std_logic_vector(2 downto 0);
	outmnfowr : out std_logic_vector(9 downto 0)

--seldata1,seldata2  : std_logic_vector (1 dowtn to 0);
	--EMval,MWval        : std_logic_vector (15 dowtn to 0)
); 
END component  decode;


component memStage is
port ( 	memoryIn: in std_logic_vector(15 downto 0); --- eli gay mn el buffer 
	MWRdstval: in std_logic_vector(15 downto 0);
	spDec,spInc	: in std_logic;
	spIn	: out std_logic_vector(9 downto 0); -- eli da6el 3la stack
	spOut	: in std_logic_vector(9 downto 0); -- eli 5areg mn stack 
	addr 	: in std_logic_vector(31 downto 0); -- el addr eli mb3otli fl buffer
	int1,int2:out std_logic_vector(9 downto 0); -- eli 5areg mn el mem
	dataOut : out std_logic_vector(31 downto 0); -- eli ryee7 3laa wb buffer el data eli httktb
	EMRdst,MWRdst:	in std_logic_vector (2 downto 0); 
	MWwbDst,EMmemWrite,EMmemRead,clk: in std_logic);

end component memStage;

component hazardDetectionUnit is 
	port (	DEWb ,DEMemRead,RsrcSig,RdstSig,ret: in std_logic;
		curPcEnb,curMemRead,DEPcEnb,EMPcEnb,EMMemRead: in std_logic;
		curRdst,curRsrc,DERdst : in std_logic_vector (2 downto 0);
		stall,pcEnb,FDenb,nop : out std_logic
	);
end component  hazardDetectionUnit;
component regHazard is 
	port (	curRdst,curRsrc:	in std_logic_vector (2 downto 0);
		op			:	in std_logic_vector (1 downto 0);
		memRead,shift:	in std_logic;
		RsrcHazard,RdstHazard : out std_logic
		);
end component regHazard;

component my_nDFFfalling IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst        : IN std_logic;
		  EN : IN STD_LOGIC;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0);
			num: in std_logic);
END component my_nDFFfalling;



signal pcmem_wb,Stalling,ACK,int,hazStalling,rstStalling--
,flagC,flagN,flagZ,stall,wB1,wb2,pcEnb,FDenb ,enablefede,enableforpc  : std_logic;--
signal Reg0,Reg1,outmnfowr,Outmem_wb,pc_out :  std_logic_vector(9 downto 0);--
signal inst,data1,data2,inportdata,indata1,indata2,immforldm :std_logic_vector(15 downto 0);--
signal inputFEDE,outFEDE : std_logic_vector(27 downto 0);
signal writeadd1,writeadd2,outadd1,outadd2 :  std_logic_vector (2 downto 0);--
signal outsignal :std_logic_vector( 17 downto 0);
signal aluoperation : std_logic_vector (3 downto 0);--1
signal inputDEEX,outDEEX : std_logic_vector(52 downto 0);
signal signalDEEX :std_logic_vector(9 downto 0);
signal op :std_logic_vector(1 downto 0);
signal RsrcHazard,RdstHazard :std_logic;
signal EMPcEnb,EMMemRead,EMwbSrc,EMwbDst:std_logic ;
signal DERdst,DERsrc,EMRsrc,EMRdst : std_logic_vector(2 downto 0);---
signal selSrcforFWU,seldstforFWU : std_logic_vector(2 downto 0);
signal selaluforexcute,outflages : std_logic_vector(3 downto 0);

signal RSRCalu,RDSTalu,memRSRC,memRDST : std_logic_vector (15  downto 0);--
signal aluout : std_logic_vector (31 downto 0);
signal memflages : std_logic_vector (3 downto 0);--
signal memenFlag,enablestack:std_logic;--lsa

signal outstack,instack :std_logic_vector (9 downto 0);--
signal spInEX ,spINmem : std_logic_vector(9  downto 0);--
signal out_data2 : std_logic_vector(15 downto 0);
signal outEXMEM,inputEXMEM : std_logic_vector (72 downto 0);
signal dataoutMEM : std_logic_vector (31 downto 0);
signal MWRdstval: std_logic_vector(15 downto 0);
signal inputMEMWB,outputMEMWB: std_logic_vector(41 downto 0);
signal outaddfor : std_logic_vector (2 downto 0);
begin
flagC<=outflages(3);
flagN<=outflages(2);
flagZ<=outflages(1);
enablestack<=outEXMEM(5) xor outEXMEM(6);
selaluforexcute<=outDEEX(13)&outDEEX(12)&outDEEX(11)&outDEEX(10);

excuteStage : excute port map (
selaluforexcute,
outDEEX(29 downto 14),OUTDEEX(45 downto 30),clk,rst,aluOut, OUTDEEX(0),memflages,memenFlag, outDEEX(6),outflages,spInEX,
outstack,inportdata,outDEEX(3),out_data2
);


sampledecodeForwardingUnit :decodeForwardingUnit port map (outaddfor,outadd1,DERsrc,DERdst,EMRsrc,EMRdst,
op,outsignal(14),outsignal(15),outsignal(9),outsignal(4),outDEEX(9),outDEEX(8),EMwbSrc,EMwbDst,RsrcHazard,RdstHazard
,selSrcforFWU,seldstforFWU
);
EMwbSrc<=outEXMEM(2);
EMwbDst<=outEXMEM(1);
EMRsrc<=outEXMEM(36 downto 34) ;
EMRdst<=outEXMEM(39 downto 37);
samplehazardDetectionUnit :hazardDetectionUnit port map(outDEEX(8),outDEEX(2),RsrcHazard,RdstHazard,outsignal(17)
,outsignal(13),outsignal(9),outDEEX(7),EMPcEnb,EMMemRead,outadd2,outadd1,DERdst,stall,pcenb,FDenb,hazStalling
);
EMPcEnb<=outEXMEM(0);

EMMemRead<=outEXMEM(4);

op<=outFEDE(15)&outFEDE(14);
enablefede<=FDenb;
enableforpc<=pcenb;
DERdst<=outDEEX(51 downto 49);
DERsrc<=outDEEX(48 downto 46);

regHazardunit :regHazard port map(outaddfor,outadd1,op,outsignal(9),outsignal(4), RsrcHazard,RdstHazard );
signalDEEX<=outsignal(15)&outsignal(14)&outsignal(13)&outsignal(2)&outsignal(12)&outsignal(11)&outsignal(10)&outsignal(9)&outsignal(8)&outsignal(7);
inputDEEX <= outFEDE(27) & "1111110000000000000000000000000000000100000000000100"  when rst = '0' and   outDEEX(52)='1' 
else outFEDE(27) & "1111110000000000000000000000000000000000000010000100" when rst = '0' and outFEDE(27)='1' 
else outFEDE(27) & outadd2&outadd1&data2&data1&aluoperation&signalDEEX;

rstStalling <= outDEEX(52) or outEXMEM(72);

RSRCalu<=aluout(31 downto 16);
RDSTalu<=aluout(15 downto 0);
stalling <= hazStalling or rstStalling;
fetchstage : fetch port map (Clk,rst,'0',outsignal(0),pcmem_wb,enableforpc,outsignal(5),stalling,interuupt,
ACK,"0000000000",reg1,outmnfowr,dataoutMEM(9 downto 0),pc_out,int,immforldm,inst);
inputFEDE<= '0' & int&pc_out&inst;
FEDE: my_nDFFfalling generic map (n=> 28) port map (Clk,rst,enablefede,inputFEDE,outFEDE,'1');

decodeStage: decode port map(clk,rst,flagC,flagN,flagZ,stall,wB1,wb2,outFEDE(27),outDEEX(52),outFEDE,writeadd1,writeadd2 ,
outsignal,aluoperation ,data1,data2 ,outadd1,outadd2 ,inportdata,indata1,indata2 ,immforldm ,ACK,
selSrcforFWU,seldstforFWU,RSRCalu,RDSTalu,memRSRC,memRDST,outaddfor,outmnfowr);

DEEX :my_nDFFfalling generic map (n=> 53) port map (Clk,rst,'1',inputDEEX,outDEEX,'0');
EXMEM :my_nDFFfalling generic map (n=> 73) port map (Clk,rst,'1',inputEXMEM,outEXMEM,'0');
inputEXMEM<= outDEEX(52) & aluout&outDEEX(51 downto 49)&outDEEX(48 downto 46)&spInEX&out_data2&OUTDEEX(5 downto 1)&OUTDEEX(9 downto 7);






stagememStage : memStage port map (outEXMEM(23 downto 8),
	MWRdstval,outEXMEM(6),outEXMEM(5),spInMEM,outstack,outEXMEM(71 downto 40) 	
	,reg0,reg1,dataoutMEM , 
	outEXMEM(39 downto 37),outEXMEM(36 downto 34) ,outEXMEM(1),outEXMEM(3),outEXMEM(4),clk);

stackPointer: entity work.stackreg generic map (n=> 10 )port map (clk,rst,enablestack,instack,outstack);
muxforstack : mux2 generic map (n=> 10 ) port map (outexmem(33 downto 24),spInMEM,outEXMEM(6),instack);--dec
MEMWB :my_nDFFfalling generic map (n=> 42) port map (Clk,rst,'1',inputMEMWB,outputMEMWB,'0');
inputMEMWB<=outEXMEM(7)&outEXMEM(0)&dataoutMEM&outEXMEM( 39 downto 37 )&outEXMEM(36 downto 34)&outEXMEM(1)&outEXMEM(2);
indata1<=outputMEMWB(23 downto 8);--rdst
indata2<=outputMEMWB(39 downto 24);--rsrc
writeadd1<=outputMEMWB(7 downto 5);
writeadd2<=outputMEMWB(4 downto 2);
WB1<=outputMEMWB(1);
pcmem_wb<=outEXMEM(0);
WB2<=outputMEMWB(0);
memRSRC<=dataoutMEM(31 downto 16);
memRDST<=dataoutMEM(15 downto 0);
MWRdstval<=outputMEMWB(23 downto 8);
outmem_wb<=outputMEMWB(17 downto 8);
memenFlag<=outputMEMWB(41);
memflages<=outputMEMWB(21 downto 18);
end flowMaster;