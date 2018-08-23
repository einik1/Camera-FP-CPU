
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;

ENTITY exp_sub IS 
  PORT (
    a:	in std_logic_vector (7 downto 0);
	 b:	in std_logic_vector (7 downto 0);
	 size:	out std_logic_vector (7 downto 0);
	 sign:	out std_logic
);
END exp_sub ;


ARCHITECTURE rt OF exp_sub IS


BEGIN


process(a,b)
begin

if a>=b then
  sign<='0';
  size<= a-b;

else
  sign<='1';
  size<= b-a;
end if;
end process;
 
END rt; 
