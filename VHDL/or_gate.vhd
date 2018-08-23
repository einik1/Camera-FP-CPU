-- ====================================================================
--	File Name:		or_gate.vhd
--	Description:	or gate 
--	Date:			25/03/2018
--	Designer:		Yuval Assayag
-- ====================================================================

-- libraries decleration
--library ieee;
--use ieee.std_logic_1164.all;

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;

entity or_gate is port (
	A,B : in std_logic; 
	C   : out std_logic);
end entity;
-- Architecture Definition
architecture rtl of or_gate is                                        
begin
	C <= A or B;
end rtl;
