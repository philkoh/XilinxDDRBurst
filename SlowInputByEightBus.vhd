
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

Inst_SlowInputByEight1: SlowInputByEight PORT MAP(
	IOpins => IOpins(3 downto 0),
	DataToPins => vec1,
	FastClock => FastClock,
	SlowClock => SlowClock,
	SlowClockEnable =>   SlowClockEnable
);

			DataToPins(7)(0) <= vec1(0);
			DataToPins(6)(0) <= vec1(1);
			DataToPins(5)(0) <= vec1(2);
			DataToPins(4)(0) <= vec1(3);
			DataToPins(3)(0) <= vec1(4);
			DataToPins(2)(0) <= vec1(5);
			DataToPins(1)(0) <= vec1(6);
			DataToPins(0)(0) <= vec1(7);

			DataToPins(7)(1) <= vec1(8);
			DataToPins(6)(1) <= vec1(9);
			DataToPins(5)(1) <= vec1(10);
			DataToPins(4)(1) <= vec1(11);
			DataToPins(3)(1) <= vec1(12);
			DataToPins(2)(1) <= vec1(13);
			DataToPins(1)(1) <= vec1(14);
			DataToPins(0)(1) <= vec1(15);
	
			DataToPins(7)(2) <= vec1(16);
			DataToPins(6)(2) <= vec1(17);
			DataToPins(5)(2) <= vec1(18);
			DataToPins(4)(2) <= vec1(19);
			DataToPins(3)(2) <= vec1(20);
			DataToPins(2)(2) <= vec1(21);
			DataToPins(1)(2) <= vec1(22);
			DataToPins(0)(2) <= vec1(23);

			DataToPins(7)(3) <= vec1(24);
			DataToPins(6)(3) <= vec1(25);
			DataToPins(5)(3) <= vec1(26);
			DataToPins(4)(3) <= vec1(27);
			DataToPins(3)(3) <= vec1(28);
			DataToPins(2)(3) <= vec1(29);
			DataToPins(1)(3) <= vec1(30);
			DataToPins(0)(3) <= vec1(31);
			
			
			
Inst_SlowInputByEight2: SlowInputByEight PORT MAP(
	IOpins => IOpins(7 downto 4),
	DataToPins => vec2,
	FastClock => FastClock,
	SlowClock => SlowClock,
	SlowClockEnable =>   SlowClockEnable
);

			DataToPins(7)(4) <= vec2(0);
			DataToPins(6)(4) <= vec2(1);
			DataToPins(5)(4) <= vec2(2);
			DataToPins(4)(4) <= vec2(3);
			DataToPins(3)(4) <= vec2(4);
			DataToPins(2)(4) <= vec2(5);
			DataToPins(1)(4) <= vec2(6);
			DataToPins(0)(4) <= vec2(7);

			DataToPins(7)(5) <= vec2(8);
			DataToPins(6)(5) <= vec2(9);
			DataToPins(5)(5) <= vec2(10);
			DataToPins(4)(5) <= vec2(11);
			DataToPins(3)(5) <= vec2(12);
			DataToPins(2)(5) <= vec2(13);
			DataToPins(1)(5) <= vec2(14);
			DataToPins(0)(5) <= vec2(15);
	
			DataToPins(7)(6) <= vec2(16);
			DataToPins(6)(6) <= vec2(17);
			DataToPins(5)(6) <= vec2(18);
			DataToPins(4)(6) <= vec2(19);
			DataToPins(3)(6) <= vec2(20);
			DataToPins(2)(6) <= vec2(21);
			DataToPins(1)(6) <= vec2(22);
			DataToPins(0)(6) <= vec2(23);

			DataToPins(7)(7) <= vec2(24);
			DataToPins(6)(7) <= vec2(25);
			DataToPins(5)(7) <= vec2(26);
			DataToPins(4)(7) <= vec2(27);
			DataToPins(3)(7) <= vec2(28);
			DataToPins(2)(7) <= vec2(29);
			DataToPins(1)(7) <= vec2(30);
			DataToPins(0)(7) <= vec2(31);
			
end Behavioral;

