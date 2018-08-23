--25.5.14
--Boris Braginsky
--==========Library===========
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all; 
--use ieee.std_logic_arith.all;
--use ieee.math_real.all;
--use ieee.std_logic_unsigned.all;


entity RAW2RGB is
port(
	oRed, oGreen, oBlue: out std_logic_vector(11 downto 0); 
	oDVAL: out std_logic; 
	iX_Cont,	iY_Cont: in std_logic_vector(10 downto 0); 
	iDATA: in std_logic_vector(11 downto 0); 
	SW3ENTROPY, SW2HISTOGRAM, SW1GRAY: std_logic;
	iDVAL, iCLK, iRST: in std_logic);
end RAW2RGB; 


architecture behv of RAW2RGB is

component Line_Buffer 
port (clken, clock: in std_logic;
		shiftin: in std_logic_vector(11 downto 0); 
		taps0x, taps1x:	out std_logic_vector(11 downto 0));
end component;

component HISTOGRAM 
port(
  garyscale: in unsigned(11 downto 0); 
	iX,	iY: in integer;--(10 downto 0);
	HISTOUT: out std_logic_vector(11 downto 0);
	iDVAL, iCLK, iRST: in std_logic);
end component; 

component entropy is
port(
  garyscale: in std_logic_vector(11 downto 0); 
	iX,	iY: in integer;--(10 downto 0);
	EntOut: out std_logic_vector(11 downto 0);
	iDVAL, iCLK, iRST: in std_logic);
end component; 





--type 		CArray is array (0 to 15) of integer;-- range 0 to 307200;
--type 		imgArray is array (0 to 11) of integer range 0 to 307200;

signal 	mDATA_0: std_logic_vector(11 downto 0);
signal	mDATA_1: std_logic_vector(11 downto 0);
signal	mDATAd_0: std_logic_vector(11 downto 0);
signal	mDATAd_1: std_logic_vector(11 downto 0);
signal	mCCD_R: std_logic_vector(11 downto 0);
signal	mCCD_G: std_logic_vector(12 downto 0);
signal	mCCD_B: std_logic_vector(11 downto 0);
signal	mDVAL:  std_logic;
signal   temp:   std_logic_vector(1 downto 0);
signal   Switches:   std_logic_vector(2 downto 0);
signal   garyscale:   std_logic_vector(11 downto 0);
--signal 	countArray : CArray;
--signal 	imgArray : CArray;
signal   HistOut : std_logic_vector(11 downto 0);
signal 	EntOutSig : std_logic_vector(11 downto 0);



begin

u0:Line_Buffer
port map (clken=>iDVAL, clock=>iCLK, shiftin=>iDATA, taps0x=>mDATA_1, taps1x=>mDATA_0);

u1: HISTOGRAM port map (garyscale => unsigned(garyscale),	iX => to_integer(unsigned(iX_Cont)) ,iY => to_integer(unsigned(iY_Cont)), HISTOUT => HistOut, iDVAL => iDVAL , iCLK =>iCLK , iRST => iRST);

u2: entropy port map (garyscale=>  garyscale, 	iX => to_integer(unsigned(iX_Cont)) ,iY => to_integer(unsigned(iY_Cont)),	EntOut => EntOutSig, iDVAL => iDVAL , iCLK =>iCLK , iRST => iRST);

Switches <= SW3ENTROPY & SW2HISTOGRAM & SW1GRAY ;
garyscale <= std_logic_vector(shift_right(unsigned(mCCD_R), 2) + shift_right(unsigned(mCCD_R), 5) + shift_right(unsigned(mCCD_G(12 downto 1)), 1) + shift_right(unsigned(mCCD_G(12 downto 1)), 4) + shift_right(unsigned(mCCD_B), 4)+shift_right(unsigned(mCCD_B), 5));


--oRed	<=	mCCD_R;
--oGreen <=	mCCD_G(12 downto 1);
--oBlue	<=	mCCD_B;
oDVAL	<=	mDVAL;
temp <=iY_Cont(0) & iX_Cont(0);

process(iCLK)
begin
case Switches is
	WHEN "000" => oRed <= mCCD_R ;
					  oGreen <= mCCD_G(12 downto 1);
					  oBlue	<= mCCD_B;
	WHEN "001" => oRed <= garyscale ;
					  oGreen <= garyscale ;
					  oBlue	<= garyscale ;
	WHEN "010" => oRed <= HistOut ;
					  oGreen <=HistOut ;
					  oBlue	<= HistOut;
	WHEN "100" => oRed <= EntOutSig ;
					  oGreen <= EntOutSig ;
					  oBlue	<= EntOutSig;	  
	WHEN OTHERS =>oRed <= mCCD_R ;
					  oGreen <= mCCD_G(12 downto 1);
					  oBlue	<= mCCD_B;
end case;
end process;



process(iCLK, iRST)
begin
	if(iRST = '0') then 
		mCCD_R	<=	"000000000000";
		mCCD_G	<=	"0000000000000";
		mCCD_B	<=	"000000000000";
		mDATAd_0<=	"000000000000";
		mDATAd_1<=	"000000000000";
		mDVAL	<=	'0';
	else
		mDATAd_0	<=	mDATA_0;
		mDATAd_1	<=	mDATA_1;
		if (iY_Cont(0) = '1' or iX_Cont(0) = '1') then 
			mDVAL		<=	'0';
		else
			mDVAL    <=	iDVAL;
		end if; 
		if(temp = "10") then
			mCCD_R	<=	mDATA_0;
			mCCD_G	<=	('0' & mDATAd_0) + ('0'&mDATA_1);
			mCCD_B	<=	mDATAd_1; 
		elsif(temp ="11") then
			mCCD_R	<=	mDATAd_0;
			mCCD_G	<=	('0'&mDATA_0)+('0'&mDATAd_1);
			mCCD_B	<=	mDATA_1;
		elsif(temp = "00") then
			mCCD_R	<=	mDATA_1;
			mCCD_G	<=	('0'&mDATA_0)+('0'&mDATAd_1);
			mCCD_B	<=	mDATAd_0;
		elsif(temp = "01") then
			mCCD_R	<=	mDATAd_1;
			mCCD_G	<=	('0'&mDATAd_0)+('0'&mDATA_1);
			mCCD_B	<=	mDATA_0;
		end if;
	end if;
end process;

end behv;








