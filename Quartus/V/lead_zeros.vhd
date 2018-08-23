library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;

entity Lead_zeros_counter IS 
  PORT (
   fraction:	in std_logic_vector (24 downto 0);
	 rounding:	out std_logic_vector (4 downto 0)
);
END entity Lead_zeros_counter;



ARCHITECTURE rt OF Lead_zeros_counter IS

BEGIN


process(fraction)
begin
rounding<="00000";
find_i: for i in 0 to 24 loop
          if fraction(24-i)= '1' then
            rounding<=std_logic_vector(to_unsigned(i,5));
            exit;
          end if;
    end loop ;

 -- rounding<="11001";
end process;
 
END rt; 






