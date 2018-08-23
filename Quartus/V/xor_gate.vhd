-- ====================================================================
--	File Name:		xor_gate.vhd
--	Description:	xor gate 
--	Date:			25/03/2018
--	Designer:		Yuval Assayag
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity xor_gate is port (
	A,B : in std_logic; 
	C   : out std_logic);
end entity;
-- Architecture Definition
architecture rtl of xor_gate is                                        
begin
	C <= A xor B;
end rtl;
