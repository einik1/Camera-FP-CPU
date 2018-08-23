-- ====================================================================
--	File Name:		mac_register.vhd
--	Description:	register used for the multiply accumulator
--	Date:			11/04/2018
--	Designer:		kobi eini
-- ====================================================================

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;

entity DFF_Register is 
	generic (N : integer);
	port (clock, rst, ld : in std_logic; -- clock reset and load
	d : in STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0'); -- data
	q : out STD_LOGIC_VECTOR(N-1 downto 0):= (others => '0')); -- output
end entity;

-- Architecture Definition
architecture rtl of DFF_Register is                                  
begin
process
		begin
		WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			if(rst = '1') then -- need to be reset
				q <= (others => '0'); -- q = '0'
			elsif(ld ='1') then 
					q <= d;
			end if;
	end process;
end rtl;

