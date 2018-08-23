-- ====================================================================
--	File Name:		and_gate.vhd
--	Description:	and gate 
--	Date:			25/03/2018
--	Designer:		Yuval Assayag
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity and_gate is port (
	A,B : in std_logic; 
	C   : out std_logic);
end entity;
-- Architecture Definition
architecture rtl of and_gate is                                        
begin
	C <= A and B;
end rtl;
