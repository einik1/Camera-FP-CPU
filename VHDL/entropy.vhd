--12062018
--kobi eini
--==========Library===========

library ieee;
--use IEEE.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
--use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all; 
use IEEE.std_logic_arith.all;
use IEEE.math_real.all;

entity entropy is
port(
  garyscale: in std_logic_vector(11 downto 0); 
	iX,	iY: in integer;--(10 downto 0);
	EntOut: out std_logic_vector(11 downto 0);
	iDVAL, iCLK, iRST: in std_logic);
end entropy; 


architecture behv of entropy is

component kobi_line IS
	PORT
	(
		clken		: IN STD_LOGIC  := '1';
		clock		: IN STD_LOGIC ;
		shiftin		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		shiftout		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		taps0x		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		taps1x		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		taps2x		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		taps3x		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		taps4x		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
END component;


type 	kobi_matrix is array (0 to 4,0 to 4) of integer;--matrix H - buffer
type 	tempAns is array (0 to 24) of unsigned (11 DOWNTO 0);
type LocalHistogram is array  (0 to 24) of integer;

signal Hmatrix : kobi_matrix;
signal TA : tempAns;
signal HM : LocalHistogram;
signal shiftout1		:  STD_LOGIC_VECTOR (11 DOWNTO 0);
signal taps0x1		:  STD_LOGIC_VECTOR (11 DOWNTO 0);
signal taps1x1		:  STD_LOGIC_VECTOR (11 DOWNTO 0);
signal taps2x1		:  STD_LOGIC_VECTOR (11 DOWNTO 0);
signal taps3x1		:  STD_LOGIC_VECTOR (11 DOWNTO 0);
signal taps4x1		:  STD_LOGIC_VECTOR (11 DOWNTO 0);
signal EntOutSig  :  unsigned (11 DOWNTO 0);
signal t0,t1,t2,t3,t4 : integer;

begin
u_line_Buffer: kobi_line port map (iDVAL,iCLK,garyscale, shiftout1, taps0x1,  taps1x1, taps2x1, taps3x1, taps4x1);


process(iCLK, iRST)

variable finalCount : integer;

begin

if (rising_edge(iCLK)) then

		
		if(iDVAL='1') then 

-- LOcal_Histogram
			
			for k in 0 to 24 loop
				if (taps0x1 >= k*140 ) and (taps0x1 < ((k+1)*140) ) then
					t4 <= k;
				end if;
				if (taps1x1 = k*140 ) and (taps1x1 < (k+1)*140 ) then
					t3 <= k;
				end if;
				if (taps2x1 >= k*140 ) and (taps2x1 < (k+1)*140 ) then
					t2 <= k;
				end if;
				if (taps3x1 >= k*140 ) and (taps3x1 < (k+1)*140 ) then
					t1 <= k;
				end if;
				if (taps4x1 >= k*140 ) and (taps4x1 < (k+1)*140 ) then
					t0 <= k;
				end if;
			end loop;	
				
-------------------------------------------------------------------------------
-- updating matrix

for k in 0 to 4 loop
		Hmatrix(4,k) <= Hmatrix(3,k);
		Hmatrix(3,k) <= Hmatrix(2,k);
		Hmatrix(2,k) <= Hmatrix(1,k);
		Hmatrix(1,k) <= Hmatrix(0,k);
	
END LOOP;
	
		Hmatrix(0,0) <= t0;
		Hmatrix(0,1) <= t1;
		Hmatrix(0,2) <= t2;
		Hmatrix(0,3) <= t3;
		Hmatrix(0,4) <= t4;


				
------------------------------------------------------------------------------------

-- conting stars

		if ( iX >= 2 AND  iX < 1278) and (iY >= 2 AND  iY < 958) then
		
			for k in 0 to 24 loop
			finalCount:=0;
			for j in 0 to 4 loop			
			for i in 0 to 4 loop	
			if Hmatrix(j,i)= k then
			finalCount:= 1+finalCount;
			end if;
			end loop;
			end loop;
			HM(k)<=finalCount;
			end loop;
			
		EntOutSig <= (others=> '0');
		

			FOR l IN 0 TO 24 LOOP			
							case (HM(l)) is--Mux -- vtable for p(k)log(p(k)))))
								when 0 => 		TA(l)<=(others=>'0');
								when 1 => 		TA(l)<="000101100010";
								when 2 => 		TA(l)<="001000100100";
								when 3 => 		TA(l)<="001010110100";
								when 4 => 		TA(l)<="001100101000";
								when 5 => 		TA(l)<="001101110010";
								when 6 => 		TA(l)<="001110110000";
								when 7 => 		TA(l)<="001111010100";
								when 8 => 		TA(l)<="001111110010";
								when 9 => 		TA(l)<="001111111100";
								when 10 => 		TA(l)<="001111110010";
								when 11 => 		TA(l)<="001111110010";
								when 12 => 		TA(l)<="001111000100";
								when 13 => 		TA(l)<="001110110000";
								when 14 => 		TA(l)<="001101110010";
								when 15 => 		TA(l)<="001101010000";
								when 16 => 		TA(l)<="001100010010";
								when 17 => 		TA(l)<="001011001000";
								when 18 => 		TA(l)<="001010000100";
								when 19 => 		TA(l)<="001001000001";
								when 20 => 		TA(l)<="000111100001";
								when 21 => 		TA(l)<="000100110010";
								when 22 => 		TA(l)<="000100110010";
								when 23 => 		TA(l)<="000011010001";
								when 24 => 		TA(l)<="000001001000";
								when 25 => 		TA(l)<=(others=>'0');
								when others => TA(l)<=(others=>'0');
							end case;							
			END LOOP;	
					 
			EntOutSig <= TA(0)+ TA(1)+ TA(2) + TA(3) + TA(4)+ TA(5) + TA(6) +TA(7) + TA(8) + TA(9)+TA(10) + TA(11) + TA(12) + TA(13) + TA(14)+TA(15) + TA(16) + TA(17) + TA(18) + TA(19) + TA(20) + TA(21) + TA(22) + TA(23) + TA(24) ;

		else 
			EntOutSig <=(others=> '0');
		end if;
	else 
		EntOutSig <=(others=> '0');
	end if;
	EntOut <= std_logic_vector(EntOutSig);
end if;

END PROCESS;

end behv;







