		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	
	Opcode 			: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	Funct				: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	EqualD         : IN 	STD_LOGIC;
	RegWriteD 		: OUT 	STD_LOGIC;
	MemtoRegD 		: OUT 	STD_LOGIC;
	MemWriteD 		: OUT 	STD_LOGIC;
	ALUControlID 	: OUT 	STD_LOGIC_VECTOR( 2 DOWNTO 0 );--ALUopD
	ALUSrcD 			: OUT 	STD_LOGIC;
	RegDstD 			: OUT 	STD_LOGIC;
	BranchD 			: OUT 	STD_LOGIC;
	PCSrcD			: OUT 	STD_LOGIC;
	--MemReadD 		: OUT 	STD_LOGIC;	
	Lui				: OUT 	STD_LOGIC;
	clock, reset	: IN 	STD_LOGIC );
END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, Sw, Lw, Beq, Branch,Im_c 	: STD_LOGIC;
	SIGNAL  ALUOp 							: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	
BEGIN           
	-- Code to generate control signals using opcode bits
	R_format 				<=  '1'  WHEN  Opcode = "000000"  ELSE '0';
	Lw          			<=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw          			<=  '1'  WHEN  Opcode = "101011"  ELSE '0';
   Beq         			<=  '1'  WHEN  Opcode = "000100"  ELSE '0';
	Im_c                 <=  '1' WHEN ((Opcode = "001000") OR (Opcode = "001101") OR(Opcode = "001110") OR (Opcode = "001111") OR (Opcode = "001001")) ELSE '0';
	Lui						<=	 '1'  WHEN  Opcode = "001111"  ELSE '0';
  	RegDstD    				<=  R_format;
 	ALUSrcD  				<=  Lw OR Sw OR Im_c;
	MemtoRegD 				<=  Lw;
  	RegWriteD 				<=  R_format OR Lw OR Im_c;
			--MemReadD 				<=  Lw;
   MemWriteD 				<=  Sw; 
 	Branch      			<=  Beq;
	BranchD              <=  Branch;
	PCSrcD               <=  EqualD and Branch;
	-- Generate ALUOp bits
	ALUOp( 1 ) 				<=  R_format;
	ALUOp( 0 ) 				<=  Beq; 
	-- Generate ALU control bits
	ALUControlID( 0 ) 	<= ( Funct( 0 ) OR Funct( 3 ) ) AND ALUOp(1 );
	ALUControlID( 1 )		<= ( NOT Funct( 2 ) ) OR (NOT ALUOp( 1 ) );
	ALUControlID( 2 ) 	<= ( Funct( 1 ) AND ALUOp( 1 )) OR ALUOp( 0 );

   END behavior;


