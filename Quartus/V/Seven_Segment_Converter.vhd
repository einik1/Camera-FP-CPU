
-- ====================================================================
--	File Name:		Seven_Segment_converter.vhd
--  the op codes are:
--	Date:			05/06/2018
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




entity Seven_Segment_converter is 
	port (
	  Bnumber : in STD_LOGIC_VECTOR (3 downto 0);
    Seven_Segment : out STD_LOGIC_VECTOR (6 downto 0)	  
	);
end entity;

-- Architecture Definition
architecture rtl of Seven_Segment_converter is 
	
	BEGIN
	
	process(Bnumber)
		begin
		case Bnumber is
    when "0000" =>
    Seven_Segment <= "1000000"; ---0
    when "0001" =>
    Seven_Segment <= "1111001"; ---1
    when "0010" =>
    Seven_Segment <= "0100100"; ---2
    when "0011" =>
    Seven_Segment <= "0110000"; ---3
    when "0100" =>
    Seven_Segment <= "0011001"; ---4
    when "0101" =>
    Seven_Segment <= "0010010"; ---5
    when "0110" =>
    Seven_Segment <= "0000010"; ---6
    when "0111" =>
    Seven_Segment <= "1111000"; ---7
    when "1000" =>
    Seven_Segment <= "0000000"; ---8
    when "1001" =>
    Seven_Segment <= "0011000"; ---9
    when "1010" =>
    Seven_Segment <= "0001000"; ---A
    when "1011" =>
    Seven_Segment <= "0000011"; ---B
    when "1100" =>
    Seven_Segment <= "1000110"; ---C
    when "1101" =>
    Seven_Segment <= "0100001"; ---D
    when "1110" =>
    Seven_Segment <= "0000110"; ---E
    when "1111" =>
    Seven_Segment <= "0001110"; ---F
    when others =>
    Seven_Segment <= "1111111"; ---null
    end case;
		end process;
		
    end rtl;
	
 

