						--  Idecode module (implements the register file for
LIBRARY IEEE; 			-- the MIPS computer)
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
	  PORT(
			InstructionD 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			WriteRegW 			: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			ResultW				: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			forwarfAD 			: IN 	STD_LOGIC;
			forwarfBD 			: IN 	STD_LOGIC;	
			PC_plus_4D 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			ALU_OUT_M 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWriteW 			: IN 	STD_LOGIC;
			read_data_1D		: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2D		: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extendD 		: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			EqualD 				: OUT	STD_LOGIC;
			PCBranchD 			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			RsD 					: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RtD 					: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RdD 					: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			clock,reset			: IN 	STD_LOGIC );
			--read_dataD 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			--ALU_resultW			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			--MemtoRegD 			: IN 	STD_LOGIC;
			--RegDstD 				: IN 	STD_LOGIC;			
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array					: register_file;
	SIGNAL write_register_address 		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_data							: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	--SIGNAL write_register_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	--SIGNAL write_register_address_0		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL Branch_Add 						: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL muxEqua1 						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL muxEqua2 						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_extend_Sig : 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_1_Sig : 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_Sig : 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );

BEGIN
		read_register_1_address 	<= InstructionD( 25 DOWNTO 21 );
   	read_register_2_address 	<= InstructionD( 20 DOWNTO 16 );
   	write_register_address		<= WriteRegW;
   	Instruction_immediate_value <= InstructionD( 15 DOWNTO 0 );
					-- Read Register 1 Operation
		read_data_1_Sig <= register_array( 
			      CONV_INTEGER( read_register_1_address ) );
					-- Read Register 2 Operation		 
		read_data_2_Sig <= register_array( 
			      CONV_INTEGER( read_register_2_address ) );
					-- Mux to bypass data memory for Rformat instructions
		write_data <= ResultW; 
					-- Sign Extend 16-bits to 32-bits					
    	Sign_extend_Sig <= X"0000" & Instruction_immediate_value
		WHEN Instruction_immediate_value(15) = '0'
		ELSE	X"FFFF" & Instruction_immediate_value;
		-- Adder to compute Branch Address
		Branch_Add	<= PC_plus_4D( 9 DOWNTO 2 ) +  Sign_extend_Sig( 7 DOWNTO 0 ) ;
		PCBranchD 	<= Branch_Add( 7 DOWNTO 0 );		
		-- Generate Zero Flag
		muxEqua1 <= read_data_1_Sig
		WHEN (forwarfAD = '0')
		ELSE ALU_OUT_M;
		muxEqua2 <= read_data_2_Sig
		WHEN (forwarfBD = '0')
		ELSE ALU_OUT_M;  
		EqualD <= '1' 
		WHEN ( muxEqua1 =  muxEqua2 )
		ELSE '0';  

		Sign_extendD <= Sign_extend_Sig;
		read_data_1D<=read_data_1_Sig;
		read_data_2D<=read_data_2_Sig;		
		
		-- for hazard unit
		RsD <= InstructionD( 25 DOWNTO 21 );
		RtD <= InstructionD( 20 DOWNTO 16 );
		RdD <= InstructionD( 15 DOWNTO 11 );

PROCESS
	BEGIN
		WAIT UNTIL clock'EVENT AND clock = '0';
		IF reset = '1' THEN
					-- Initial register values on reset are register = reg#
					-- use loop to automatically generate reset logic 
					-- for all registers
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
 			END LOOP;
					-- Write back to register - don't write to register 0
		ELSIF RegWriteW = '1' AND write_register_address /= 0 THEN
		      register_array( CONV_INTEGER( write_register_address)) <= write_data;				
		END IF;
	END PROCESS;
END behavior;


