library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;

ENTITY Sign_computation IS 
  PORT (
   sign:	in std_logic;
   sign_significand: in std_logic;
	 s1:	in std_logic;
	 s2:	in std_logic;
	 FA_not: in std_logic;
	 sign_substract:out std_logic;
	 Sr:out std_logic
);
END ENTITY Sign_computation;


ARCHITECTURE rt OF Sign_computation IS

signal A,B,C,D,E: std_logic;
signal outsign :std_logic;

BEGIN

A<=s1;
B<=s2;
C<=FA_not;
D<=sign;
E<=sign_significand;



process(sign,sign_significand,s2,s1,FA_not,A,B,C,D,E,outsign)
begin

outsign<= s1 xor s2 xor FA_not;


--y = B'CE + B'CD + BC'E + BC'D + AD'E'

Sr<=((not B)and C and E) or
  ((not B) and C and D) or
   (B and E and (not C)) or
     (B and D and (not C)) or
     (A and (not D) and (not E));



sign_substract<=outsign;

end process;
 
END rt; 




