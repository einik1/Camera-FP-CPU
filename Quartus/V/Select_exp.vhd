library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;

ENTITY Select_exp IS 
  PORT (
	 a:	in std_logic_vector (7 downto 0);
	 b:	in std_logic_vector (7 downto 0);
	 c:	out std_logic_vector (7 downto 0) 
);
END entity Select_exp;


ARCHITECTURE rt OF Select_exp IS

BEGIN


process(a,b)
begin

if a>=b then
  c<= a-"1111111";

else
  
  c<= b-"1111111";
end if;
end process;
 
END rt; 


