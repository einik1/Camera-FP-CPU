library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;

entity Sub_and_bias IS 
  PORT (
   exponent_sel:	in std_logic_vector (7 downto 0);
	 rounding_num:	in std_logic_vector (4 downto 0);
	 exp_result:	out std_logic_vector (7 downto 0) 
);
END entity Sub_and_bias;



ARCHITECTURE rt OF Sub_and_bias IS

BEGIN


process(exponent_sel,rounding_num)
begin

exp_result <= exponent_sel - ("00"&rounding_num) + "1111111"+"0000001";-- +127

end process;
 
END rt; 




