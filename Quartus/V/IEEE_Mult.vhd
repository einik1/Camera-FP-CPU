-- ====================================================================
--	File Name:		IEEE_Mult.vhd 
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




entity IEEE_Mult is 
	port (
    A,B : in STD_LOGIC_VECTOR (31 downto 0);
    C : out STD_LOGIC_VECTOR (31 downto 0)
	);
end entity;

-- Architecture Definition
architecture rtl of IEEE_Mult is 

--Signals

	BEGIN
	
	process(A,B)
variable exp : STD_LOGIC_VECTOR (8 downto 0);
	  variable mul : STD_LOGIC_VECTOR (47 downto 0);
		begin
		  
	    if(A = "10000000000000000000000000000000" or B = "100000000000000000000000000000000") then
		    C <= "00000000000000000000000000000000";
		  elsif(A = "00000000000000000000000000000000" or B= "00000000000000000000000000000000") then
		    C <= "00000000000000000000000000000000";
		  else 
		    mul := ('1'&A(22 downto 0)) * ('1'&B(22 downto 0));
		    if(mul(47) = '1') then
		      exp := ('0'&A(30 downto 23)) + ('0'&B(30 downto 23)) - "001111110";
		      C <= (A(31) xor B(31)) & exp(7 downto 0) & std_logic_vector(mul(46 downto 24)) ;
		    else 
		      exp := ('0'&A(30 downto 23)) + ('0'&B(30 downto 23)) - "001111111";
		      C <= (A(31) xor B(31)) & exp(7 downto 0) & std_logic_vector(mul(45 downto 23)) ;
		    end if;
		  end if;
		end process;
  
	
end rtl; 





