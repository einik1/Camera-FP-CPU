
-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;




entity Second_Swap is 
	port (
	  f1,f2 : in std_logic_vector (25 downto 0);
	  sign,sign_a,sign_b : in std_logic;
	  exit1, exit2 : out std_logic_vector (25 downto 0)	  
	);
end entity;

-- Architecture Definition
architecture rtl of Second_Swap is 

--Signals



signal f1_s, f2_s : std_logic_vector (25 downto 0);
signal should_swap:std_logic;
	  



-- Components
	
	
	BEGIN
	
process(f1,f2,should_swap,sign,sign_a,sign_b,f1_s, f2_s)
begin 
  should_swap<= (sign and sign_b) or ((not sign) and sign_a);
  if (should_swap = '0') then
     f1_s <= f1;
     f2_s <= f2;
  else
    f1_s <= f2;
    f2_s <= f1;
  end if;
exit1 <=  f1_s;
exit2 <=  f2_s;

end process;
  
	
end rtl; 







