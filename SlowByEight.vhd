
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
	signal delayedEnable : std_logic_vector (7 downto 0) := "00000000";
begin

process (FastClock, SlowClockEnable)
	begin
	if rising_edge(FastClock) and SlowClockEnable = '1' then
	--	incomingData <= DataToPins;
		dataStrobe <= not dataStrobe;  -- this toggles on every new set of data arriving
	end if;
	
end process;

-------------------------------------- NOTE: The timing is currently a bit weird; the iopins do not present the first bit of the input data group
-------------------------------------- until the next clk32M25Hz pulse PLUS two additional 250MHz period delays.  Perhaps in the future, I will
-------------------------------------- get rid of the two additional 250MHz period delays to align the output with the clk32M25Hz pulse, as would be
-------------------------------------- more intuitive.  However, that will require adjusting a bunch of timings

process (FastClock, delayedEnable)
	begin
	if rising_edge(FastClock) and delayedEnable(6) = '1' then  -- capture the incoming data one cycle BEFORE the clk31M25Hz pulse, to help make the system
																					-- less sensitive to clock skew between the clk250MHz and clk31M25Hz
		incomingData <= DataToPins;
	end if;
	
end process;

process (FastClock)
begin
	if rising_edge(FastClock) then
		lastDataStrobe <= dataStrobe;
		preloadPulse <= nextPreloadPulse;
		shiftRegisters <= nextShiftRegisters;
		delayedEnable(0) <= slowClockEnable;
		delayedEnable(7 downto 1) <= delayedEnable(6 downto 0);
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
end Behavioral;

