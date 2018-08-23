-- ====================================================================
--	File Name:		IEEE_Selector.vhd
--	Description:	fullAdder unit
--	Date:			07/05/2018
--	Designer:		Kobi Eini
-- ====================================================================


library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;


Entity IEEE_Selector is 
port (
OP: in std_logic_vector (3 downto 0); -- OP
A,B : in STD_LOGIC_VECTOR (31 downto 0);
C : out STD_LOGIC_VECTOR (31 downto 0)
);
end IEEE_Selector;



architecture behaveural of IEEE_Selector is

begin 
  process (OP,A,B) 
  begin
      case OP is 
    --MUL
        when "1010" => C <= A; 
    -- ADD
        when "1001" => C <= B;
    -- OTHER
			  when others => C <=(others => '0'); -- HIGE Z for undifined OP
      end case;         
 end process;  
  end behaveural;
  
  

