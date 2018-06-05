#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <string>
#include <map>
#include <stdio.h>
#include<string.h>
#include <sstream>
#include <fstream>
#include <vector>
#include <algorithm>
using namespace std;
map<string, string> OpCode;
map<string, string> Reg;
map<string, string> FirstCat;
map<string, string> ALU;
map<string, string>ForthCat;
string IR = "0000000000000000";
string Instraction;
int starAddr;
int interrupAddr;
string Imm;
string instr[1024];
string dataMem[1024];
void decToHexa(int n, ofstream &file)
{
	// char array to store hexadecimal number
	char hexaDeciNum[100];

	// counter for hexadecimal number array
	int i = 0;
	while (n != 0)
	{
		// temporary variable to store remainder
		int temp = 0;

		// storing remainder in temp variable.
		temp = n % 16;

		// check if temp < 10
		if (temp < 10)
		{
			hexaDeciNum[i] = temp + 48;
			i++;
		}
		else
		{
			hexaDeciNum[i] = temp + 55;
			i++;
		}

		n = n / 16;
	}

	// printing hexadecimal number array in reverse order
	bool f = false;
	for (int j = i - 1; j >= 0; j--) {
		if (hexaDeciNum[j] >= 'A'&& hexaDeciNum[j] <= 'F') {
			char ch = tolower(hexaDeciNum[j]);
			file << ch;
		}
		else
			file << hexaDeciNum[j];
		f = true;
	}
	if (!f)file << '0';
}
void convertToMemFile(string fpath, string arr[])
{
	ofstream file;
	file.open(fpath);
	file << "// memory data file (do not edit the following line - required for mem load use)\n";
	file << "// instance=/pu/RAM_LAB/MEMORY\n";
	file << "// format=bin addressradix=h dataradix=b version=1.0 wordsperline=1";
	file << "wordsperline=1" << endl;
	for (int i = 0; i < 1024; i++) {
		if (i <= 0xf) {
			file << "  @";
		}
		else if (i <= 0xff) {
			file << " @";
		}
		else {
			file << "@";
		}
		decToHexa(i, file);
		file << " ";
		file << arr[i] << endl;
	}

}
void MapFill() {
	for (int i = 0; i < 1024; ++i)
		dataMem[i] = "0000000000000000", instr[i] = dataMem[i];
	// 5
	OpCode["MOV "] = "00";
	OpCode["NOP"] = "00";
	OpCode["IN "] = "00";
	OpCode["OUT "] = "00";
	OpCode["LDM "] = "00";
	//14
	OpCode["ADD "] = "01";
	OpCode["MUL "] = "01";
	OpCode["SUB "] = "01";
	OpCode["AND "] = "01";
	OpCode["OR "] = "01";
	OpCode["RLC "] = "01";
	OpCode["RRC "] = "01";
	OpCode["SHL "] = "01";
	OpCode["SHR "] = "01";
	OpCode["SETC"] = "01";
	OpCode["CLRC"] = "01";
	OpCode["NOT "] = "01";
	OpCode["INC "] = "01";
	OpCode["DEC "] = "01";
	//9
	OpCode["PUSH "] = "11";
	OpCode["POP "] = "11";
	OpCode["JZ "] = "11";
	OpCode["JN "] = "11";
	OpCode["JC "] = "11";
	OpCode["JMP "] = "11";
	OpCode["CALL "] = "11";
	OpCode["RET"] = "11";
	OpCode["RTI"] = "11";
	//2
	OpCode["LDD "] = "10";
	OpCode["STD "] = "10";
	////////////////////////////////////////
	Reg["R0"] = "000";
	Reg["R1"] = "001";
	Reg["R2"] = "010";
	Reg["R3"] = "011";
	Reg["R4"] = "100";
	Reg["R5"] = "101";
	Reg["R6"] = "110";
	Reg["R7"] = "111";
	///////////////////////////////////////////	
	ALU["MOV "] = "0000"; //so2al omnia
	ALU["MOVB "] = "0001";
	ALU["ADD "] = "0010";
	ALU["MUL "] = "0011";
	ALU["SUB "] = "0100";
	ALU["AND "] = "0101";
	ALU["OR "] = "0110";
	ALU["RLC "] = "0111";
	ALU["SHL "] = "1000";
	ALU["SHR "] = "1001";
	ALU["RRC "] = "1010";
	ALU["NOT "] = "1011";
	ALU["INC "] = "1100";
	ALU["DEC "] = "1101";
	ALU["SETC"] = "1110";//so2al omnia fel wr2
	ALU["CLRC"] = "1111";
	////////////////////////////////////////////////	
	FirstCat["MOV "] = "10000";
	FirstCat["NOP"] = "01000";
	FirstCat["IN "] = "00100";
	FirstCat["OUT "] = "00010";
	FirstCat["LDM "] = "00001";
	///////////////////////////////////////////
	ForthCat["PUSH "] = "000010110";
	ForthCat["POP"] = "000100110";
	ForthCat["JZ "] = "010000000";
	ForthCat["JN "] = "010000010";
	ForthCat["JC "] = "010000100";
	ForthCat["JMP "] = "010000110";
	ForthCat["CALL "] = "001000110";
	ForthCat["RET"] = "100000110";
	ForthCat["RTI"] = "000000111";

}

string FindReg(string inst) {
	string NumReg = "";
	size_t foundQoma = inst.find(",");
	//if find qoma da m3nah ano 2 oprand
	if (foundQoma != std::string::npos)
	{
		string reg2 = "";
		for (std::map<string, string>::iterator it = Reg.begin(); it != Reg.end(); it++)
		{
			size_t found = Instraction.substr(0, foundQoma).find(it->first);
			if (found != std::string::npos)
			{
				reg2 = it->second;
				break;
			}
		}
		for (std::map<string, string>::iterator it = Reg.begin(); it != Reg.end(); it++)
		{


			size_t found = Instraction.substr(foundQoma).find(it->first);
			if (found != std::string::npos)
			{
				reg2 += it->second;
				break;
			}
		}
		return reg2;
	}
	// da m3nah ano mfe4 8er oprand wa7d bs 
	else {
		for (std::map<string, string>::iterator it = Reg.begin(); it != Reg.end(); it++)
		{
			size_t found = Instraction.find(it->first);
			if (found != std::string::npos)
			{
				return it->second;
				break;
			}
		}
	}
	return NumReg;
}
std::string toBinary(long long n)
{
	std::string r;
	while (n != 0) { r = (n % 2 == 0 ? "0" : "1") + r; n /= 2; }
	return r;
}

string getIMM(string inst)
{// bgeb el IMM bta3 el LDM bs 
	size_t foundQoma = inst.find(",");
	if (foundQoma != std::string::npos)
	{
		string s = inst.substr(foundQoma + 1);
		int f = stoi(s);
		Imm = toBinary(f);
		return Imm;
	}
	return "";
}
void shiftreg(vector <int>locs) {
	//el vector da aly feh el qomat bt3ty 
	//el Rsrc
	for (std::map<string, string>::iterator it = Reg.begin(); it != Reg.end(); it++)
	{


		size_t found = Instraction.substr(0, locs[0]).find(it->first);
		if (found != std::string::npos)
		{
			IR.replace(2, 3, it->second);
			break;

		}
	}
	//Rdes
	string desLDM = "";
	for (std::map<string, string>::iterator it = Reg.begin(); it != Reg.end(); it++)
	{


		size_t found = Instraction.substr(locs[1]).find(it->first);
		if (found != std::string::npos)
		{
			IR.replace(5, 3, it->second);
			desLDM = it->second;
			break;
		}
	}
	string d = "";
	//bgeb el IMM aly ben 2 qoma
	for (int h = locs[0] + 1; h<locs[1]; h++)
	{
		d = d + Instraction[h];
	}
	// if an el imm akbr mn 16 b7wlo l LDM Rdes,0
	int f = stoi(d);
	if (f < 16)
	{
		string z = toBinary(f);
		string zeros = "";
		for (int i = 0; i < 4 - z.length(); i++)
		{
			zeros += "0";
		}
		zeros += z;
		IR.replace(12, 4, zeros);
	}
	// da lw akbr b2a w ba5d nfs el Rdes bta3t el shift
	else {
		IR.replace(0, 13, "00111" + desLDM + "00001");
	}
}

string decBIN(string s) {

	if (s == "")
		return "";
	string sec = "";
	long long num = stoi(s);
	while (num) {
		sec += (num % 2 + '0');
		num /= 2;
	}
	reverse(sec.begin(), sec.end());
	return sec;
}

int main()
{
	//ofstream Wfile("RAM.txt");
	//ifstream myfile("Test1.txt");
	freopen("Test7.txt", "r", stdin);
	//freopen("RAM.txt", "w", stdout);
	MapFill();
	string s;
	getline(cin, s);
	string num = "";
	for (int i = 0; i < s.size(); ++i) {
		if (s[i] >= '0' && s[i] <= '9')
			num += s[i];
		else break;
	}
	starAddr = stoi(num);

	getline(cin, s);
	num = "";
	for (int i = 0; i < s.size(); ++i) {
		if (s[i] >= '0' && s[i] <= '9')
			num += s[i];
		else break;
	}
	interrupAddr = stoi(num);
	int dIdx = 2, iIdx = starAddr;
	dataMem[0] = decBIN(to_string(starAddr));
	dataMem[1] = decBIN(to_string(interrupAddr));
	bool first = true;

	while (getline(cin, Instraction)) {
		int idx = Instraction.find(';');
		if (idx != -1)
			Instraction = Instraction.substr(0, idx);
		if (Instraction == "") continue;
		for (int i = 0; i < Instraction.size(); ++i)
			if (Instraction[i] >= 'a' && Instraction[i] <= 'z')
				Instraction[i] = toupper(Instraction[i]);

		char c = tolower(Instraction[0]);
		if (!((Instraction[0] >= 'a' && Instraction[0] <= 'z') || (Instraction[0] >= 'A' && Instraction[0] <= 'Z')) && first) {
			dataMem[dIdx++] = decBIN(Instraction);
			continue;
		}
		else first = false;
		if (Instraction[0] == '.') {
			iIdx = stoi(Instraction.substr(1));
			continue;
		}
		IR = "XXXXXXXXXXXXXXXX";
		//cout << "Inst:  " << Instraction << endl;
		// b7dd el opcode bs 
		for (std::map<string, string>::iterator it = OpCode.begin(); it != OpCode.end(); it++) {
			size_t found = Instraction.find(it->first);
			if (found != std::string::npos) {
				IR.replace(0, 2, it->second);
				break;
			}
		}
		///////////////////////////////////////////////////////////////
		//da lw first category 
		if (IR.substr(0, 2) == "00") {

			for (std::map<string, string>::iterator it = FirstCat.begin(); it != FirstCat.end(); it++) {


				size_t found = Instraction.find(it->first);
				if (found != std::string::npos) {
					IR.replace(8, 5, it->second);
					break;

				}
			}
			string reg = FindReg(Instraction);
			if (IR.substr(8, 5) == "10000") {
				IR.replace(2, 6, reg);
			}
			else if (IR.substr(8, 5) == "01000") {
				IR.replace(2, 6, "111111");
			}
			else if (IR.substr(8, 5) == "00100") {
				IR.replace(2, 6, "111" + reg);
			}
			else if (IR.substr(8, 5) == "00010") {
				IR.replace(2, 6, reg + "111");
			}
			else if (IR.substr(8, 5) == "00001") {
				IR.replace(2, 6, "111" + reg);
			}
		}
		////////////////////////////////////////////////////////////////
		//second category
		if (IR.substr(0, 2) == "01")
		{

			for (std::map<string, string>::iterator it = ALU.begin(); it != ALU.end(); it++)
			{
				size_t found = Instraction.find(it->first);
				if (found != std::string::npos)
				{
					IR.replace(8, 4, it->second);
					break;
				}
			}
			string reg = FindReg(Instraction);
			if (IR.substr(8, 4) == "0010" || IR.substr(8, 4) == "0011" || IR.substr(8, 4) == "0100" || IR.substr(8, 4) == "0101" || IR.substr(8, 4) == "0110")
			{
				IR.replace(2, 6, reg);
			}
			else if (IR.substr(8, 4) == "0111" || IR.substr(8, 4) == "1010" || IR.substr(8, 4) == "1011" || IR.substr(8, 4) == "1100" || IR.substr(8, 4) == "1101")
			{
				IR.replace(2, 6, "111" + reg);
			}
			else if (IR.substr(8, 4) == "1110" || IR.substr(8, 4) == "1111")
			{
				IR.replace(2, 6, "111111");
			}
			else if (IR.substr(8, 4) == "1000" || IR.substr(8, 4) == "1001")
			{
				vector<int> characterLocations;
				for (int i = 0; i < Instraction.size(); i++)
					if (Instraction[i] == ',')
						characterLocations.push_back(i);
				shiftreg(characterLocations);

			}
		}
		///////////////////////////////////////////////////////////////////////
		//third category 
		if (IR.substr(0, 2) == "10")
		{
			string reg = FindReg(Instraction);
			IR.replace(2, 3, reg);
			//to get EA aly b3d el qoma
			size_t foundQoma = Instraction.find(",");

			if (foundQoma != std::string::npos)
			{
				string EA = Instraction.substr(foundQoma + 1);
				int f = stoi(EA);
				string ea = toBinary(f);
				string zeros = "";
				for (int i = 0; i < 10 - ea.length(); i++)
				{
					zeros += "0";
				}
				zeros += ea;
				IR.replace(5, 10, zeros);
				if (Instraction.substr(0, 3) == "LDD")
				{
					IR.replace(15, 1, "1");
				}
				else IR.replace(15, 1, "0");
			}
		}
		///////////////////////////////////////////////////////////////////////
		//Forth category 
		if (IR.substr(0, 2) == "11")
		{
			for (std::map<string, string>::iterator it = ForthCat.begin(); it != ForthCat.end(); it++)
			{
				size_t found = Instraction.find(it->first);
				if (found != std::string::npos)
				{
					IR.replace(5, 9, it->second);
					break;

				}
			}
			string reg = FindReg(Instraction);
			if (reg == "")
			{
				IR.replace(2, 3, "111");
			}
			else { IR.replace(2, 3, reg); }
		}
		///////////////////////////////////////////////////////////////////////////
		/////////////////////cout el IR
		replace(IR.begin(), IR.end(), 'X', '0');

		instr[iIdx++] = IR;
		if (IR.substr(8, 5) == "00001" && IR.substr(0, 2) == "00" &&Instraction.substr(0, 3) == "LDM")
		{
			string imm = getIMM(Instraction);
			int size = imm.length();
			string zeros = "";
			for (int i = 0; i < 16 - size; i++) {
				zeros += "0";
			}
			zeros += imm;
			instr[iIdx++] = zeros;
			//cout << "IMM:  " << zeros << endl;
		}
		else if (IR.substr(8, 5) == "00001" && IR.substr(0, 2) == "00" && (Instraction.substr(0, 3) == "SHR" || Instraction.substr(0, 3) == "SHL")) {
			// cout el IMM
			//cout << "IMM:  " << "0000000000000000" << endl;
			instr[iIdx++] = "0000000000000000";
		}
	}
	convertToMemFile("instr.mem", instr);
	convertToMemFile("data.mem", dataMem);
	//system("PAUSE");
	return 0;
}