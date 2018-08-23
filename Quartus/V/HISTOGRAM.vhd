--12062018
--kobi eini
--==========Library===========
--library ieee;
--use ieee.std_logic_1164.all;
--use IEEE.numeric_std.all;
--use IEEE.std_logic_signed.all; 
--use ieee.std_logic_arith.all;
--use ieee.math_real.all;
--use ieee.std_logic_unsigned.all;

--package CarrayType is
--type	CArray is array (0 to 15) of integer range 0 to 307200;
--end package CarrayType;

library ieee;
use ieee.std_logic_1164.all;
--use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all; 
use ieee.std_logic_arith.all;
--use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
--use work.CarrayType.all;

entity HISTOGRAM is
port(
  garyscale: in unsigned(11 downto 0); 
	iX,	iY: in integer;--(10 downto 0);
	HISTOUT: out std_logic_vector(11 downto 0);
	iDVAL, iCLK, iRST: in std_logic);
end HISTOGRAM; 


architecture behv of HISTOGRAM is



type 		CArray is array (0 to 15) of integer;-- range 0 to 307200;
--type 		imgArray is array (0 to 11) of integer range 0 to 307200;
signal 	mDATA_0: std_logic_vector(11 downto 0);
signal 	countArray : CArray;
signal 	imgArray : CArray;
signal 	Y2: integer;

begin

process(iCLK)
begin
Y2 <= 960 - iY;
IF(rising_edge(iCLK)) THEN
	
	IF (iDVAL = '1') THEN
		 FOR i in 0 to 15 LOOP
			IF(garyscale >= i*(240)) and (garyscale < (i+1)*(240)) THEN countArray(i) <= countArray(i) + 1;
			END IF;
			END LOOP;
	--END IF;	
		 IF ((iX = 0) and (iY = 0)) THEN --imgArray <= countArray;
			FOR j in 0 to 15 LOOP
				imgArray(j) <= countArray(j);
			END LOOP;
	--END IF;	
		 ELSIF ((iX = 1) and (iY = 0)) THEN 
			FOR s in 0 to 15 LOOP
				countArray(s) <= 0;
			END LOOP;		
		 END IF;
	
	-- creating histogram display
	
		FOR k in 0 to 15 LOOP
			IF((iX >= k*80) and (iX < (k+1)*80) ) THEN
				
				IF (Y2*1260 <= imgArray(k)) THEN
					HISTOUT <= "000000000000";
				ELSE
					HISTOUT <= "111111111111";
				END IF;
			END IF;
		END LOOP;	
	END IF;
END IF;	
end process;



end behv;








