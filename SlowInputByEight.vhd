----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:56:45 02/04/2022 
-- Design Name: 
-- Module Name:    SlowInputByEight - Behavioral 
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

entity SlowInputByEight is
    Port ( IOpins : in  STD_LOGIC_VECTOR (3 downto 0);
           DataToPins : out  STD_LOGIC_VECTOR (31 downto 0);
           FastClock : in  STD_LOGIC;
           SlowClockEnable : in  STD_LOGIC);
end SlowInputByEight;

architecture Behavioral of SlowInputByEight is

--signal outgoingData : std_logic_vector (31 downto 0):= "00000000000000000000000000000000";
signal shiftRegisters : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal nextShiftRegisters : std_logic_vector (31 downto 0);
signal dataStrobe : std_logic := '0';
signal lastDataStrobe : std_logic := '0';
signal preloadPulse : std_logic := '0';
signal nextPreloadPulse : std_logic := '0';
	
begin

process (FastClock, SlowClockEnable)
	begin
	if rising_edge(FastClock) and SlowClockEnable = '1' then
		DataToPins <= shiftRegisters; 
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

process (iopins, preloadPulse, shiftRegisters)
	begin
--	if preloadPulse = '1' then
--		outgoingData <= shiftRegisters;
--	else
		nextShiftRegisters(31 downto 1) <= shiftRegisters(30 downto 0); 
--	end if;


	nextShiftRegisters(7) <= IOpins(0);
	nextShiftRegisters(15) <= IOpins(1);
	nextShiftRegisters(23) <= IOpins(2);
	nextShiftRegisters(31) <= IOpins(3);

	end process;


end Behavioral;

