
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.common.all;

entity SlowInputByEightBus is
    Port ( IOpins : in  STD_LOGIC_VECTOR (15 downto 0);
           DataToPins : out  burstArr;
           FastClock : in  STD_LOGIC;
			  SlowClock : IN std_logic;
           SlowClockEnable : in  STD_LOGIC);
end SlowInputByEightBus;

architecture Behavioral of SlowInputByEightBus is
COMPONENT SlowInputByEight
	PORT(
		IOpins : IN std_logic_vector(3 downto 0);
		FastClock : IN std_logic;
		SlowClockEnable : IN std_logic;   
		SlowClock : IN std_logic;
		DataToPins : OUT std_logic_vector(31 downto 0)
	);
END COMPONENT;

	signal vec1 : std_logic_vector(31 downto 0);
	signal vec2 : std_logic_vector(31 downto 0);
	signal vec3 : std_logic_vector(31 downto 0);
	signal vec4 : std_logic_vector(31 downto 0);

begin

Inst_SlowInputByEight: SlowInputByEight PORT MAP(
	IOpins => IOpins(3 downto 0),
	DataToPins => vec1,
	FastClock => FastClock,
	SlowClock => SlowClock,
	SlowClockEnable =>   SlowClockEnable
);

end Behavioral;

