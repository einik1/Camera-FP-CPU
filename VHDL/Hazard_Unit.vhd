library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all; -------- STOP HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ENTITY Hazard_Unit IS

	PORT( 
	StallF, StallD, ForwardAD, ForwardBD, FlushE : OUT  	STD_LOGIC; 
	ForwardAE, ForwardBE : OUT  STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	clock, BranchD, MemToRegE,MemToRegM, RegWriteE, RegWriteM, RegWriteW : IN  	STD_LOGIC;  -- MemtoRegM ???
	RsD,RtD,RsE,RtE, WriteRegE, WriteRegM,WriteRegW : IN  STD_LOGIC_VECTOR( 4 DOWNTO 0 ));
	 
END 	Hazard_Unit;

ARCHITECTURE BEHAVIORAL OF Hazard_Unit IS
  
  SIGNAL Lws : STD_LOGIC;
  SIGNAL Brs : STD_LOGIC;
  
BEGIN
    Lws <= '1' WHEN ((RsD = RtE OR RtD = RtE) AND (MemToRegE = '1'))  
         ELSE '0';
  
  Brs <= '1' WHEN (BranchD = '1' AND  RegWriteE = '1' AND (WriteRegE = RsD OR WriteRegE = RtD)) 
         OR ( BranchD = '1' AND MemToRegM = '1' AND (WriteRegM = RsD OR WriteRegM = RtD))
       ELSE '0';
         
   StallF		<= Lws or Brs;
   StallD		<= Lws or Brs;
   
   ForwardAD <= '1' WHEN (RsD /= "00000" AND RsD = WriteRegM AND RegWriteM = '1')
                ELSE '0';
   
   
   ForwardBD 	<= '1' WHEN ( RtD /= "00000" AND RtD = WriteRegM AND RegWriteM = '1' )
             	ELSE	'0';	
        
   FlushE		<= Lws or Brs; 
   
   
	 ForwardAE 	<=	"10" 	WHEN (RsE /= "00000" AND RsE = WriteRegM AND RegWriteM = '1')
	            ELSE	"01" 	WHEN (RsE /= "00000" AND RsE = WriteRegW AND RegWriteW = '1')
	            ELSE	"00";
	 ForwardBE 	<= "10" 	WHEN (RtE /= "00000" AND RtE = WriteRegM AND RegWriteM = '1')
	            ELSE	"01" 	WHEN (RtE /= "00000" AND RtE = WriteRegW AND RegWriteW = '1')
	            ELSE	"00";
END BEHAVIORAL;


							
		
		
   		
							
		
							
		