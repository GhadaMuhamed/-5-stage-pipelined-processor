Library ieee;
Use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

Entity fetch is

port(Clk,Rst,reset,Taken,pcmem_wb,PC_en,LDM,Stalling,Interpt,ACK : in std_logic;
Reg0,Reg1,Rdes,Outmem_wb : in std_logic_vector(9 downto 0);
pc_out: out std_logic_vector(9 downto 0);
int :out std_logic;
ramout : out std_logic_vector(15 downto 0);
inst :out std_logic_vector(15 downto 0)
);
end fetch;
----------------------------------------------------------------
Architecture Data_fetch of fetch is

component RegPC is
port( Clk,Rst : in std_logic;
e : in std_logic;
d : in std_logic_vector(9 downto 0);
q : out std_logic_vector(9 downto 0));
end component;
--------------------------------------------------
component ram  is 
PORT(           CLK  : IN std_logic;
                 WE  : IN std_logic;
	     ADDRESS : IN std_logic_vector(9 DOWNTO 0);
	     DATAOUT : OUT std_logic_vector(15 DOWNTO 0);
             DATAIN  : IN std_logic_vector(15 DOWNTO 0));
end component;
------------------------------------------------------

component mux2 IS  
Generic (n : integer :=16);
PORT (
IN1,IN2: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SEl:IN STD_LOGIC;
OUT1:OUT  STD_LOGIC_VECTOR(n-1 DOWNTO 0)
);    
END component mux2;
----------------------------------------
component mux4 IS  
Generic (n : integer :=16);
PORT (
IN1,IN2,IN3,IN4: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SEl:IN STD_LOGIC_VECTOR(1 DOWNTO 0);
OUT1:OUT  STD_LOGIC_VECTOR(n-1 DOWNTO 0)
);    
END component mux4;
---------------------------------------------------------
signal Mux1_out : std_logic_vector(9 downto 0);
signal Mux2_out : std_logic_vector(9 downto 0);
signal Mux3_out : std_logic_vector(9 downto 0);
signal PCOut_sig,NewPc : std_logic_vector(9 downto 0);
signal inst_sig : std_logic_vector(15 downto 0);
signal S0,int_sig : std_logic;
signal IntAck:std_logic;
signal selMuxForPC,selMuxForInst :std_logic_vector(1 downto 0);
signal NOP_inst,int_inst,Ram_out : std_logic_vector(15 downto 0); 
begin  
IntAck<=(not(ACK)) and Interpt;
NOP_inst<="0011111101000000";
int_inst<="1111100000111000";
selMuxForPC<=taken&pcmem_wb;
selMuxForInst<=S0&IntAck;
int_sig<=inst_sig(15) and inst_sig(14) and inst_sig(5);
S0<= Taken or LDM or Stalling;
mux1: mux4 generic map (n=>16 ) port map(Ram_out,int_inst,NOP_inst,NOP_inst,selMuxForInst,inst_sig);
inst<=inst_sig;
NewPc<= PCOut_sig+'1';
muxforPC: mux4 generic map (n=>10 ) port map(NewPc,Outmem_wb,Rdes,Rdes,selMuxForPC,Mux1_out);
mux3: mux2 generic map (n=>10 ) port map(Mux1_out,Reg1,int_sig,Mux2_out);
int<=int_sig;
muxreset: mux2 generic map (n=>10 ) port map(Mux2_out,Reg0,reset,Mux3_out);
r0: RegPC port map(Clk,Rst,PC_en,Mux3_out,PCOut_sig);
pc_out <= PCOut_sig;
ram0: ram port map(Clk,'0',PCOut_sig,Ram_out,"0000000000000000");
ramout<=ram_out;

end Data_fetch;