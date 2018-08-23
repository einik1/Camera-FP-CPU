-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.math_real.all;
use ieee.numeric_std.all; --Need for the shif
use ieee.std_logic_signed;
use ieee.std_logic_unsigned.all;

entity TopEntity_Test is
end TopEntity_Test;
 architecture rtl of TopEntity_Test is
 

COMPONENT TopEntity is 
	port (
	clk, reset,SW8   : IN     STD_LOGIC;
  SevenSeg     : OUT    STD_LOGIC_VECTOR (8 downto 0)   
	);
end COMPONENT;
 
--Inputs
signal clock, reset,SW8 : std_logic;
 SIGNAL mw_U_0clk : std_logic;
   SIGNAL mw_U_0disable_clk : boolean := FALSE;
--Outputs
signal SevenSeg : std_logic_vector(8 downto 0);
SIGNAL mw_U_1pulse : std_logic :='0'; 
BEGIN
 
-- Instantiate the Unit Under Test (UUT)
uut: TopEntity PORT MAP (	clock, reset,SW8, SevenSeg );
 
 u_0clk_proc: PROCESS
   BEGIN
      WHILE NOT mw_U_0disable_clk LOOP
         mw_U_0clk <= '0', '1' AFTER 50 ns;
         WAIT FOR 100 ns;
      END LOOP;
      WAIT;
   END PROCESS u_0clk_proc;
   mw_U_0disable_clk <= TRUE AFTER 500000000 ns;
   clock <= mw_U_0clk;

   -- ModuleWare code(v1.9) for instance 'U_1' of 'pulse'
   reset <= mw_U_1pulse;
   u_1pulse_proc: PROCESS
   BEGIN
      mw_U_1pulse <= 
         '0',
         '1' AFTER 20 ns,
         '0' AFTER 120 ns;
      WAIT;
    END PROCESS u_1pulse_proc;

 

end rtl;

