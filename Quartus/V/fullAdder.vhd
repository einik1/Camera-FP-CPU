-- ====================================================================
--	File Name:		fullAdder.vhd
--	Description:	fullAdder unit
--	Date:			25/03/2018
--	Designer:		Kobi Eini
-- ====================================================================

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



ENTITY full_adder IS PORT (
c, d, carry_in : IN std_logic;
sum, carry_out: OUT std_logic
);
END full_adder; 

ARCHITECTURE structural OF full_adder IS
SIGNAL x1, x2, x3, x4, y1 : std_logic;
COMPONENT and_gate PORT (
A, B : IN std_logic;
C : OUT std_logic );
END COMPONENT and_gate;
COMPONENT or_gate PORT (
A, B : IN std_logic;
C : OUT std_logic );
END COMPONENT or_gate;
COMPONENT xor_gate PORT (
A, B : IN std_logic;
C : OUT std_logic );
END COMPONENT xor_gate; 

BEGIN
and0 : and_gate PORT MAP( c, d, x1 );
and1 : and_gate PORT MAP( c, carry_in, x2 );
and2 : and_gate PORT MAP( d, carry_in, x3 );
or0: or_gate PORT MAP( x1, x2, x4 );
or1: or_gate PORT MAP( x3, x4, carry_out );
xor0: xor_gate PORT MAP( c, d, y1 );
xor1: xor_gate PORT MAP( y1, carry_in, sum );
END structural; -- acurding to the familier FA logic