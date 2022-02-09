
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SlowInputByEight is
    Port ( IOpins : in  STD_LOGIC_VECTOR (3 downto 0);
           DataToPins : out  STD_LOGIC_VECTOR (31 downto 0);
           FastClock : in  STD_LOGIC;
			  MediumClock : in  STD_LOGIC;
			  SlowClock : IN std_logic;
		--	  originalSlowClockEnable : in STD_LOGIC;
           SlowClockEnable : in  STD_LOGIC);
end SlowInputByEight;

architecture Behavioral of SlowInputByEight is

signal shiftRegisters : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal nextShiftRegisters : std_logic_vector (31 downto 0);
--signal dataStrobe : std_logic := '0';
--signal lastDataStrobe : std_logic := '0';
	
begin

process (FastClock, MediumClock, slowClockEnable)
	begin
	if rising_edge(MediumClock)  and slowClockEnable = '1' then
		DataToPins <= shiftRegisters; 
	--	dataStrobe <= not dataStrobe;  -- this toggles on every new set of data arriving
	end if;
	
end process;

process (FastClock)
begin
	if rising_edge(FastClock) then
	--	lastDataStrobe <= dataStrobe;
		shiftRegisters <= nextShiftRegisters;
	end if;
	
end process;

------------------------------------------COMBINATORIAL:
process (iopins,  shiftRegisters)
	begin
	nextShiftRegisters(31 downto 1) <= shiftRegisters(30 downto 0); 

	nextShiftRegisters(0) <= IOpins(0);
	nextShiftRegisters(8) <= IOpins(1);
	nextShiftRegisters(16) <= IOpins(2);
	nextShiftRegisters(24) <= IOpins(3);

	end process;

end Behavioral;

