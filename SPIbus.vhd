----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:00:04 01/27/2022 
-- Design Name: 
-- Module Name:    SPIinterface - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPIinterface is
    Port ( clk : in  STD_LOGIC;
           dataout : in  STD_LOGIC_VECTOR (15 downto 0);
           datain : out  STD_LOGIC_VECTOR (15 downto 0);
           dataarrivedtoggle : out  STD_LOGIC;
			  csPin : in  STD_LOGIC;
			  MISOpin : out STD_LOGIC;
			  MOSIpin : in  STD_LOGIC;
			  sckPin : in  STD_LOGIC	
			  );
			  
			  
			  
signal CSvec : std_logic_vector (7 downto 0) := "11111111";
signal MOSIvec : std_logic_vector (7 downto 0) := "00000000";
signal SCKvec : std_logic_vector (7 downto 0) := "00000000";

signal CS : std_logic := '1';
signal MOSI : std_logic := '0';
signal SCK : std_logic := '0';
signal lastSCK : std_logic := '0';
signal lastCS : std_logic := '1';
signal nextCS, nextMOSI, nextSCK : std_logic;
signal SPIdataIn : std_logic_vector (15 downto 0) := "0000000000000000";
signal nextSPIdataIn : std_logic_vector (15 downto 0);

signal SPIdataOut : std_logic_vector (15 downto 0) := "0000000000000000";
signal nextSPIdataOut : std_logic_vector (15 downto 0);

signal newDataToggle : std_logic := '0';
signal nextNewDataToggle : std_logic ;

end SPIinterface;

architecture Behavioral of SPIinterface is

begin
datain <= SPIdataIn;
dataarrivedtoggle <= newDataToggle ;

process (clk)
	begin
	if rising_edge(clk) then
		CSvec(7 downto 1) <= CSvec(6 downto 0);
		MOSIvec(7 downto 1) <= MOSIvec(6 downto 0);
		SCKvec(7 downto 1) <= SCKvec(6 downto 0);
		
		CSvec(0) <= csPin;
		MOSIvec(0) <= MOSIpin;
		SCKvec(0) <= SCKpin;

		CS <= nextCS;
		lastCS <= CS;
		MOSI <= nextMOSI;
		SCK <= nextSCK;
		lastSCK <= SCK;
		
		SPIdataIn <= nextSPIdataIn;
		SPIdataOut <= nextSPIdataOut;
	
		newDataToggle <= nextNewDataToggle;
	end if;
end process;




process (CSvec, MOSIvec, SCKvec, CS, MOSI, SCK, SPIdataIn, lastSCK)
	begin
	nextCS <= CS;
	if CSvec(4) = CSvec(5) and CSvec(5) = CSvec(6) and CSvec(6) = CSvec(7) then  -- if there's any jittering in the input, ignore it
		nextCS <= CSvec(4);
	end if;
	
	nextMOSI <= MOSI;
	if MOSIvec(4) = MOSIvec(5) and MOSIvec(5) = MOSIvec(6) and MOSIvec(6) = MOSIvec(7) then
		nextMOSI <= MOSIvec(4);
	end if;

	nextSCK <= SCK;
	if SCKvec(4) = SCKvec(5) and SCKvec(5) = SCKvec(6) and SCKvec(6) = SCKvec(7) then
		nextSCK <= SCKvec(4);
	end if;
	
	nextSPIdataIn <= SPIdataIn;
	nextSPIdataOut <= SPIdataOut;

	if CS = '0' then
		if lastSCK = '0' and SCK = '1' then  -- rising edge of SCK
			nextSPIdataIn(0) <= MOSI;
			nextSPIdataIn(15 downto 1) <= SPIdataIn(14 downto 0);  -- shift in new data, MSB first
		end if;
		
		MISOpin <= SPIdataOut(15);
		if lastSCK = '0' and SCK = '1' then  -- rising edge of SCK (but we're watching a 8-cycle (Of250MHz) delayed version of the clock)
				nextSPIdataOut(15 downto 1) <= SPIdataOut(14 downto 0);  -- shift out data, MSB first
		end if;
	else
		nextSPIdataOut <= dataout;
		MISOpin <= 'Z';
	end if;
	
	nextNewDataToggle <= newDataToggle;
	if lastCS = '0' and CS = '1' then  --rising edge of CS, means transaction is over
			nextNewDataToggle <= not newDataToggle;  -- so flip the newDataToggle
	end if;

end process;

end Behavioral;

