--library IEEE;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;

    
entity adder is

generic(n: positive);
port(a:	in signed (2*n-1 downto 0);
	b:	in signed (2*n-1 downto 0);
	sub: in std_logic;
	carryin:	in std_logic;
	carryout:	out std_logic;
	sum1:	out signed(2*n-1 downto 0));
end entity;


architecture str of adder is 
component full_adder port(
c, d, carry_in :  IN std_logic;
sum, carry_out: OUT std_logic
);
end component;

COMPONENT xor_gate PORT (
A, B : IN std_logic;
C : OUT std_logic );
END COMPONENT xor_gate;


signal w_CARRY : std_logic_vector(2*n downto 0);
signal xor_sig : std_logic_vector(2*n-1 downto 0);

begin
 w_CARRY(0) <= sub; -- for two's comp.
 carryout <= w_CARRY(2*n);
 
 
Array_Of_Xor: for j in 0 to 2*n-1 generate
 xor_gatej: xor_gate port map (sub, b(j), xor_sig(j));
 end generate;-- for two's comp.
Array_Of_FAs: for i in 0 to 2*n-1 generate
  full_adderi: full_adder port map( a(i) ,  xor_sig(i), w_CARRY(i),  sum1(i), w_CARRY(i+1));
end generate;--building the add\sub



end str;


