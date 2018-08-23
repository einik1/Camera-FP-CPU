-- ====================================================================
--	File Name:		NandR.vhd
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

entity NandR is 
	port (
	fin : in unsigned(24 downto 0);
	Anum : in unsigned(4 downto 0);
	fout : out unsigned(24 downto 0)	
	);
end entity;

-- Architecture Definition
architecture rtl of NandR is 

signal X : unsigned(24 downto 0);

begin   
process(fin, Anum, X)
  variable temp : integer range 0 to 26;
begin 
  X <= shift_left(fin, to_integer(Anum + "00001"));
  --temp := 0;
  --if(X(0) = '1') then
    fout <= X;
  --else
   -- for i in 1 to 23 LOOP
   -- if (X(i) = '1') then 
    --  temp := i;
     -- EXIT;
    --end if;
  --end LOOP;
   -- fout <= X + shift_left("000000000000000000000001", temp-1);
  -- fout <= X;
  --end if;
end process;

end rtl;



