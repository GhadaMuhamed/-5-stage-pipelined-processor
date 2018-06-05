LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity memStage is
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
end memStage;
architecture memStageArch of memStage is 
signal memoryFinalValue,memoryDataOut : std_logic_vector(15 downto 0);
signal memoryFinalAddr : std_logic_vector(9 downto 0);
signal spSel,dataSel : std_logic; -- da bta3 forward wla l2
signal memExtend : std_logic_vector(31 downto 0);
signal intReg : std_logic_vector(15 downto 0);
signal enableReg : std_logic;
begin
	enableReg <= EMmemWrite or EMmemRead;
	int1 <= "0000000000";
	int2 <= intReg(9 downto 0);
	memExtend <= "0000000000000000" & memoryDataOut;
	spSel <= spDec or spInc;

	out0: entity work.decrement port map(spOut,spIn);
	MemForward: entity work.MemoryForwardingUnit port map(EMRdst,MWRdst,MWwbDst,EMmemWrite,dataSel);
	datamux: entity work.mux2 generic map (n => 16) port map(memoryIn,MWRdstval,dataSel,memoryFinalValue);
	memory: entity work.mem port map(clk,EMmemWrite,memoryFinalAddr,memoryFinalValue,memoryDataOut);
	addrmux: entity work.mux2 generic map (n => 10) port map(addr(9 downto 0),spOut,spSel,memoryFinalAddr);
	memoryOutMux:entity work.mux2 generic map (n => 32) port map (addr,memExtend,EMmemRead,dataOut);
	intr: entity work.intReg port map (memoryDataOut,clk,enableReg,memoryFinalAddr,intReg);
end memStageArch;