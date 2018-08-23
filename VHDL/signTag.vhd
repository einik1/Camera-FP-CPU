-- ====================================================================
--	File Name:		signTag.vhd 
--	Date:			05/05/2018
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




entity signTag is 
	port (
    A,B : in STD_LOGIC_VECTOR (22 downto 0);
    C : out STD_LOGIC
	);
end entity;

-- Architecture Definition
architecture rtl of signTag is 

--Signals
 signal C1 : std_logic;
	
	BEGIN
	
	process(A,B,C1)
		begin
		  if (A<B) then
		    C1<='1';
		  else
		   C1<='0';
		  end if;
		  C<=C1;	    
		end process;
  
	
end rtl; 







