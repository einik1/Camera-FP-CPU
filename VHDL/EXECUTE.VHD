--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  Execute IS
	PORT(	Read_data_1E 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2E 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extendE 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RtE				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RdE				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			ALUControlE		: IN 	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
			ALUSrcE			: IN 	STD_LOGIC;
			RegDstE			: IN 	STD_LOGIC;
			ForwardAE		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ForwardBE		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ALUOutM 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ResultW		 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_ResultE		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			WriteDataE		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			WriteRegE		: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			Lui				: IN 	STD_LOGIC;
			clock, reset	: IN 	STD_LOGIC );			
			--Function_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			--ALUOp 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			--ALUSrc 			: IN 	STD_LOGIC;
			--Zero 			: OUT	STD_LOGIC;			
			--Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			--PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
END Execute;

ARCHITECTURE behavior OF Execute IS

COMPONENT IEEE_Adder IS 
			PORT (
				a:	in std_logic_vector (31 downto 0);
				b:	in std_logic_vector (31 downto 0);
				sub: in std_logic;
				res:	out std_logic_vector (31 downto 0));
	END COMPONENT;
	
	COMPONENT IEEE_Mult is 
			port (
				A,B : in STD_LOGIC_VECTOR (31 downto 0);
				C : out STD_LOGIC_VECTOR (31 downto 0));
	end COMPONENT;




SIGNAL Ainput, Binput,AIEEEAdder,BIEEEAdder,AIEEEMult,BIEEEMult,res,C : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL sub 						: STD_LOGIC;
SIGNAL WriteDataE_Sig 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL SLT		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );


BEGIN

IEEE_ADD: IEEE_Adder
	port MAP(
	a=>Read_data_1E,
	b=>Read_data_2E,
	sub=>sub,
	res=>res
	);
	
IEEE_MUL: IEEE_Mult
	port MAP(
	A=>Read_data_1E,
	B=>Read_data_2E,
	C=>C
	);
	
	sub <= '1' 
	WHEN ( ALUControlE = "100")
	ELSE '0';

	WriteRegE <= RtE
	WHEN (RegDstE = '0')
	ELSE RdE;
	
	WriteDataE_Sig <= Read_data_2E
	WHEN (ForwardBE = "00")
	ELSE ResultW WHEN (ForwardBE = "01")
	ELSE ALUOutM;
	
	-- ALU input mux
	Ainput <= Read_data_1E
	WHEN (ForwardAE = "00")
	ELSE ResultW WHEN (ForwardAE = "01")
	ELSE ALUOutM;
	
	Binput <= Sign_extendE
	WHEN (ALUSrcE = '1')
	ELSE WriteDataE_Sig;  
	
	-- Select ALU output        
	ALU_ResultE <= SLT WHEN  ALUControlE = "111"
	--X"0000000" & B"000"  & ALU_output_mux( 31 ) WHEN  ALUControlE = "111" 
	ELSE Binput(15 downto 0)& X"0000" WHEN Lui = '1'
	ELSE  ALU_output_mux( 31 DOWNTO 0 );
	
	WriteDataE <= WriteDataE_Sig;

	SLT <= X"00000000" WHEN ( ( Ainput(31) = '0' AND Binput(31) = '1' ) OR ((Ainput(31) = '0' AND Binput(31) = '0' ) AND (Ainput(30 downto 23) > Binput(30 downto 23))) OR ((Ainput(31) = '1' AND Binput(31) = '1' ) AND (Ainput(30 downto 23) < Binput(30 downto 23))) OR ((Ainput(31) = '0' AND Binput(31) = '0') AND (Ainput(30 downto 23) = Binput(30 downto 23)) AND (Ainput(22 downto 0) >= Binput(22 downto 0)) ) OR ((Ainput(31) = '1' AND Binput(31) = '1' ) AND (Ainput(30 downto 23) = Binput(30 downto 23)) AND (Ainput(22 downto 0) <= Binput(22 downto 0)) ))
							 ELSE X"00000001";
PROCESS ( ALUControlE, Ainput, Binput, res, C )
	BEGIN
					-- Select ALU operation
 	CASE ALUControlE IS
						-- ALU performs ALUresult = A_input AND B_input
		WHEN "000" 	=>	ALU_output_mux 	<= Ainput AND Binput; 
						-- ALU performs ALUresult = A_input OR B_input
     	WHEN "001" 	=>	ALU_output_mux 	<= Ainput OR Binput;
						-- ALU performs ALUresult = A_input + B_input
	 	WHEN "010" 	=>	ALU_output_mux 	<= Ainput + Binput;
						-- ALU performs IEEE ADD
 	 	WHEN "011" 	=>	ALU_output_mux <= res;
						-- ALU performs IEEE SUB
 	 	WHEN "100" 	=>	ALU_output_mux 	<= res;
						-- ALU performs IEEE MULT
 	 	WHEN "101" 	=>	ALU_output_mux 	<= C;
						-- ALU performs ALUresult = A_input -B_input
 	 	WHEN "110" 	=>	ALU_output_mux 	<= Ainput - Binput;
						-- ALU performs SLT
  	 	WHEN "111" 	=>	ALU_output_mux 	<= SLT;
		--ALU_output_mux 	<= Ainput - Binput ;
 	 	WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
  	END CASE;
  END PROCESS;
END behavior;

