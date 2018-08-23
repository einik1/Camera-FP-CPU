-- ====================================================================
--	File Name:		swap.vhd 
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




entity swap is 
	port (
	  f1,f2 : in std_logic_vector (22 downto 0);
	  swaper : in std_logic;
	  exit1 : out std_logic_vector (25 downto 0);
	  exit2 : out std_logic_vector (23 downto 0)
	);
end entity;

-- Architecture Definition
architecture rtl of swap is 

--Signals



signal f1_s, f2_s : std_logic_vector (22 downto 0);




-- Components
	
	
	BEGIN
	
process(f1,f2,swaper,f1_s, f2_s)
begin 
if (swaper = '0') then
  f1_s <= f1;
  f2_s <= f2;
else
  f1_s <= f2;
  f2_s <= f1;
end if;
exit1 <= "001" & f1_s;
exit2 <= '1' & f2_s;
end process;
  
	
end rtl; 





