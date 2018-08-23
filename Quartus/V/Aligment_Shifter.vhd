-- ====================================================================
--	File Name:		Aligment_Shifter.vhd
--	Date:			06/05/2018
--	Designer:		kobi eini
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;

entity Aligment_Shifter is 
	port (
	fmin : in unsigned(23 downto 0);
	Anum : in unsigned(7 downto 0);
	fnew : out unsigned(25 downto 0)	
	);
end entity Aligment_Shifter;

-- Architecture Definition
architecture rtl of Aligment_Shifter is 

signal X : unsigned(25 downto 0);

begin   
process(fmin, Anum, X)
begin 
  X <= "00"&shift_right(fmin, to_integer(Anum));
  fnew <= X;
end process;

end rtl;

