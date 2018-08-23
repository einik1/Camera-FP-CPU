
---adder

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;

ENTITY IEEE_Adder IS 
  PORT (
    a:	in std_logic_vector (31 downto 0);
	 b:	in std_logic_vector (31 downto 0);
	 sub: in std_logic;
	 res:	out std_logic_vector (31 downto 0)
);
END IEEE_Adder;


ARCHITECTURE rt OF IEEE_Adder IS


signal sign,signt,signsub: std_logic;
signal fraction_a,secSwapOut1,secSwapOut2: std_logic_vector(25 downto 0);
signal fraction_b: std_logic_vector(23 downto 0);
signal AS: unsigned(25 downto 0);
signal ss,selc_exp: std_logic_vector(7 downto 0);
signal sum1,sum2: signed(26 downto 0);
signal numOfRounds: std_logic_vector(4 downto 0);
signal nandr1: unsigned(24 downto 0);





COMPONENT  exp_sub IS 
  PORT (
    a:	in std_logic_vector (7 downto 0);
	 b:	in std_logic_vector (7 downto 0);
	 size:	out std_logic_vector (7 downto 0);
	 sign:	out std_logic
);
END COMPONENT exp_sub;

COMPONENT  swap IS 
  PORT (
    f1,f2 : in std_logic_vector (22 downto 0);
	  swaper : in std_logic;
	  exit1 : out std_logic_vector (25 downto 0);
	  exit2 : out std_logic_vector (23 downto 0)
);
END COMPONENT swap;


COMPONENT Aligment_Shifter is 
	port (
	fmin : in unsigned(23 downto 0);
	Anum : in unsigned(7 downto 0);
	fnew : out unsigned(25 downto 0)	
	);
end COMPONENT Aligment_Shifter;


COMPONENT  Sign_computation IS 
  PORT (
     sign:	in std_logic;
   sign_significand: in std_logic;
	 s1:	in std_logic;
	 s2:	in std_logic;
	 FA_not: in std_logic;
	 sign_substract:out std_logic;
	 Sr:out std_logic
);
END COMPONENT Sign_computation;

COMPONENT  Select_exp IS 
  PORT (
    a:	in std_logic_vector (7 downto 0);
	 b:	in std_logic_vector (7 downto 0);
	 c:	out std_logic_vector (7 downto 0) 
);
END COMPONENT Select_exp;

COMPONENT  Sub_and_bias IS 
  PORT (
    exponent_sel:	in std_logic_vector (7 downto 0);
	 rounding_num:	in std_logic_vector (4 downto 0);
	 exp_result:	out std_logic_vector (7 downto 0)
);
END COMPONENT Sub_and_bias;


COMPONENT Lead_zeros_counter IS 
  PORT (
   fraction:	in std_logic_vector (24 downto 0);
	 rounding:	out std_logic_vector (4 downto 0)
);
END COMPONENT Lead_zeros_counter;

COMPONENT NandR is 
	port (
	fin : in unsigned(24 downto 0);
	Anum : in unsigned(4 downto 0);
	fout : out unsigned(24 downto 0)		
	);
end COMPONENT;

COMPONENT signTag is 
	port (
    A,B : in STD_LOGIC_VECTOR (22 downto 0);
    C : out STD_LOGIC
	);
end COMPONENT;


COMPONENT adder is

generic(n: positive);
port(a:	in signed (2*n-1 downto 0);
	b:	in signed (2*n-1 downto 0);
	sub: in std_logic;
	carryin:	in std_logic;
	carryout:	out std_logic;
	sum1:	out signed(2*n-1 downto 0));
end COMPONENT;

COMPONENT Second_Swap is 
	port (
	  f1,f2 : in std_logic_vector (25 downto 0);
	  sign,sign_a,sign_b : in std_logic;
	  exit1, exit2 : out std_logic_vector (25 downto 0)	  
	);
end COMPONENT;

BEGIN
  
 exp_sub_uu: exp_sub port map(a(30 downto 23),b(30 downto 23),ss,sign);
 swap_uu: swap port map(a(22 downto 0),b(22 downto 0), sign, fraction_a,fraction_b);
 Alignment_shifter_uu: Aligment_Shifter port map(unsigned(fraction_b),unsigned(ss),AS);
 swap2_uu: Second_Swap port map(fraction_a,std_logic_vector(AS),sign,a(31),b(31), secSwapOut1,secSwapOut2);
 Sign_computation_uu: Sign_computation port map(sign, signt, a(31),b(31),sub,signsub, res(31));
 adder_uu: adder generic map (13) port map(signed(secSwapOut1),signed(secSwapOut2),signsub,'0',sum1(26),sum1(25 downto 0));
 adder2_uu: adder generic map (13) port map("00000000000000000000000000",sum1(25 downto 0),sum1(25),'0',sum2(26),sum2(25 downto 0));
 signTag_uu: signTag port map(fraction_a(22 downto 0),std_logic_vector(AS(22 downto 0)),signt);
 Select_exp_uu: Select_exp port map(a(30 downto 23),b(30 downto 23),selc_exp);
 Lead_zeros_counter_uu: Lead_zeros_counter port map(std_logic_vector(sum2(24 downto 0)), numOfRounds);
 NandR_uu: NandR port map(unsigned(sum2(24 downto 0)),unsigned(numOfRounds), nandr1);
 Sub_and_bias_uu: Sub_and_bias port map(selc_exp,numOfRounds,res(30 downto 23));
 res(22 downto 0 ) <= std_logic_vector(nandr1(24 downto 2));       

 
END rt; 


