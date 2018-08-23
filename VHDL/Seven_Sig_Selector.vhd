-- ====================================================================
--	File Name:		Seven_Sig_Selector.vhd
--	Description:	Seven_Sig_Selector 
--  the op codes are:
--  0000 - MUL
--  0001 - MAC
--  0010 - MAX
--  0011 - MIN
--  0100 - RST
-- 	0101-  SUB 
--  0110 - SHL
--  0111 - SHR
--	1000 - ADD
-- 1001 - ADD_FP
-- 1010 = MUL_FP 
--	Date:			05/05/2018
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




entity Seven_Sig_Selector is 
	generic (N : integer);
	port (
	HIGH_alu,LOW_alu : in STD_LOGIC_VECTOR (N-1 downto 0);
	HI_LO_fp: in STD_LOGIC_VECTOR (4*N-1 downto 0); 
	OP : in STD_LOGIC_VECTOR (3 downto 0); 
	SW_8: in STD_LOGIC;
	Digit0, Digit1, Digit2, Digit3 : out STD_LOGIC_VECTOR (6 downto 0)
	);
end entity;

-- Architecture Definition
architecture rtl of Seven_Sig_Selector is 

--Signals

signal ssc0_in : std_logic_vector (3 downto 0);
signal ssc1_in : std_logic_vector (3 downto 0);
signal ssc2_in : std_logic_vector (3 downto 0);
signal ssc3_in : std_logic_vector (3 downto 0);
signal ssc0_out : std_logic_vector (6 downto 0);
signal ssc1_out : std_logic_vector (6 downto 0);
signal ssc2_out : std_logic_vector (6 downto 0);
signal ssc3_out : std_logic_vector (6 downto 0);



-- Components
component Seven_Segment_converter is 
	port (
	  Bnumber : in STD_LOGIC_VECTOR (3 downto 0);
    Seven_Segment : out STD_LOGIC_VECTOR (6 downto 0)	  
	);
end component;
    
  
	
	BEGIN
	ssc0_uu: Seven_Segment_converter port map(ssc0_in, ssc0_out);
	ssc1_uu: Seven_Segment_converter port map(ssc1_in, ssc1_out);
	ssc2_uu: Seven_Segment_converter port map(ssc2_in, ssc2_out);
	ssc3_uu: Seven_Segment_converter port map(ssc3_in, ssc3_out);
	
	process(HIGH_alu,LOW_alu,	HI_LO_fp,	OP,	SW_8,ssc0_out,ssc1_out,ssc2_out,ssc3_out)
		begin
		case OP is
    when "1001" =>
      if (SW_8 = '0') then
       ssc0_in<= HI_LO_fp ((N/2)-1 downto 0);
       ssc1_in<= HI_LO_fp (N-1 downto N/2);
       ssc2_in<= HI_LO_fp ((3*N/2)-1 downto N);
       ssc3_in<= HI_LO_fp ((2*N)-1 downto 3*N/2);
      else 
        ssc0_in<= HI_LO_fp ((5*N/2)-1 downto 2*N);
        ssc1_in<= HI_LO_fp ((3*N)-1 downto 5*N/2);
        ssc2_in<= HI_LO_fp ((7*N/2)-1 downto 3*N);
        ssc3_in<= HI_LO_fp (4*N-1 downto 7*N/2);
      end if;
      Digit0<= ssc0_out;
      Digit1<= ssc1_out;
      Digit2<= ssc2_out;
      Digit3<= ssc3_out;
    when "1010" =>
      if (SW_8 = '0') then
       ssc0_in<= HI_LO_fp ((N/2)-1 downto 0);
       ssc1_in<= HI_LO_fp (N-1 downto N/2);
       ssc2_in<= HI_LO_fp ((3*N/2)-1 downto N);
       ssc3_in<= HI_LO_fp ((2*N)-1 downto 3*N/2);
      else 
        ssc0_in<= HI_LO_fp ((5*N/2)-1 downto 2*N);
        ssc1_in<= HI_LO_fp ((3*N)-1 downto 5*N/2);
        ssc2_in<= HI_LO_fp ((7*N/2)-1 downto 3*N);
        ssc3_in<= HI_LO_fp (4*N-1 downto 7*N/2);
      end if;
      Digit0<= ssc0_out;
      Digit1<= ssc1_out;
      Digit2<= ssc2_out;
      Digit3<= ssc3_out;
    when others =>
      ssc0_in<= LOW_alu ((N/2)-1 downto 0);
      ssc1_in<= LOW_alu (N-1 downto N/2);
      ssc2_in<= HIGH_alu ((N/2)-1 downto 0);
      ssc3_in<= HIGH_alu (N-1 downto N/2);
    
      Digit0<= ssc0_out;
      Digit1<= ssc1_out;
      Digit2<= ssc2_out;
      Digit3<= ssc3_out;
    end case;
		end process;
  
	
end rtl; 

