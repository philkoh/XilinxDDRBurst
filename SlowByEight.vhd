----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:20:01 01/14/2022 
-- Design Name: 
-- Module Name:    SlowByEight - Behavioral 
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

entity SlowByEight is
    Port ( IOpins : inout  STD_LOGIC_VECTOR (3 downto 0);
           DataToPins : in  STD_LOGIC_VECTOR (31 downto 0);
           FastClock : in  STD_LOGIC;
			  MediumClock : in  STD_LOGIC;
           SlowClockEnable : in  STD_LOGIC);
		end SlowByEight;

architecture Behavioral of SlowByEight is
	signal incomingData : std_logic_vector (31 downto 0):= "00000000000000000000000000000000";
	signal shiftRegisters : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
	signal nextShiftRegisters : std_logic_vector (31 downto 0);
	signal dataStrobe : std_logic := '0';
	signal lastDataStrobe : std_logic := '0';
	signal preloadPulse : std_logic := '0';
	signal nextPreloadPulse : std_logic := '0';
	signal dummy : std_logic;
begin
	

process (FastClock, SlowClockEnable)
	begin
	if rising_edge(FastClock) and SlowClockEnable = '1' then
		incomingData <= DataToPins;
		dataStrobe <= not dataStrobe;  -- this toggles on every new set of data arriving
	end if;
	
end process;

process (FastClock)
begin
	if rising_edge(FastClock) then
		lastDataStrobe <= dataStrobe;
		preloadPulse <= nextPreloadPulse;
		shiftRegisters <= nextShiftRegisters;
	end if;
	
end process;

------------------------------------------COMBINATORIAL:
nextPreloadPulse <= '0' when lastDataStrobe = dataStrobe else '1';  -- a one-cycle pulse is generated after the dataStrobe toggles

process (preloadPulse, incomingData, shiftRegisters)
	begin
	if preloadPulse = '1' then
		nextShiftRegisters <= incomingData;
	else
		nextShiftRegisters(31 downto 1) <= shiftRegisters(30 downto 0); 
	end if;
end process;


IOpins(0) <= shiftRegisters(7);
IOpins(1) <= shiftRegisters(15);
IOpins(2) <= shiftRegisters(23);
IOpins(3) <= shiftRegisters(31);

	
	
dummy <= MediumClock;

end Behavioral;

