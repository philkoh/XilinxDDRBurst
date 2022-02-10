
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.common.all;

entity SlowByEightBus is
     Port ( IOpins : inout  STD_LOGIC_VECTOR (15 downto 0);
           DataToPins : in  burstArr;
           FastClock : in  STD_LOGIC;
           SlowClockEnable : in  STD_LOGIC);
	
end SlowByEightBus;

architecture Behavioral of SlowByEightBus is

	COMPONENT SlowByEight
	PORT(
		DataToPins : IN std_logic_vector(31 downto 0);
		FastClock : IN std_logic;
		SlowClockEnable : IN std_logic;       
		IOpins : INOUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	signal vec1 : std_logic_vector(31 downto 0);
	signal vec2 : std_logic_vector(31 downto 0);
	signal vec3 : std_logic_vector(31 downto 0);
	signal vec4 : std_logic_vector(31 downto 0);

begin

Inst1: SlowByEight PORT MAP(
		IOpins => IOpins(3 downto 0) ,
		DataToPins => vec1,
		FastClock => FastClock ,
		SlowClockEnable => SlowClockEnable
	);

vec1(0) <= DataToPins(0)(0);
vec1(1) <= DataToPins(1)(0);
vec1(2) <= DataToPins(2)(0);
vec1(3) <= DataToPins(3)(0);
vec1(4) <= DataToPins(4)(0);
vec1(5) <= DataToPins(5)(0);
vec1(6) <= DataToPins(6)(0);
vec1(7) <= DataToPins(7)(0);
vec1(8) <= DataToPins(0)(1);
vec1(9) <= DataToPins(1)(1);
vec1(10) <= DataToPins(2)(1);
vec1(11) <= DataToPins(3)(1);
vec1(12) <= DataToPins(4)(1);
vec1(13) <= DataToPins(5)(1);
vec1(14) <= DataToPins(6)(1);
vec1(15) <= DataToPins(7)(1);
vec1(16) <= DataToPins(0)(2);
vec1(17) <= DataToPins(1)(2);
vec1(18) <= DataToPins(2)(2);
vec1(19) <= DataToPins(3)(2);
vec1(20) <= DataToPins(4)(2);
vec1(21) <= DataToPins(5)(2);
vec1(22) <= DataToPins(6)(2);
vec1(23) <= DataToPins(7)(2);
vec1(24) <= DataToPins(0)(3);
vec1(25) <= DataToPins(1)(3);
vec1(26) <= DataToPins(2)(3);
vec1(27) <= DataToPins(3)(3);
vec1(28) <= DataToPins(4)(3);
vec1(29) <= DataToPins(5)(3);
vec1(30) <= DataToPins(6)(3);
vec1(31) <= DataToPins(7)(3);

Inst2: SlowByEight PORT MAP(
		IOpins => IOpins(7 downto 4) ,
		DataToPins => vec2,
		FastClock => FastClock ,
		SlowClockEnable => SlowClockEnable
	);

vec2(0) <= DataToPins(0)(4);
vec2(1) <= DataToPins(1)(4);
vec2(2) <= DataToPins(2)(4);
vec2(3) <= DataToPins(3)(4);
vec2(4) <= DataToPins(4)(4);
vec2(5) <= DataToPins(5)(4);
vec2(6) <= DataToPins(6)(4);
vec2(7) <= DataToPins(7)(4);
vec2(8) <= DataToPins(0)(5);
vec2(9) <= DataToPins(1)(5);
vec2(10) <= DataToPins(2)(5);
vec2(11) <= DataToPins(3)(5);
vec2(12) <= DataToPins(4)(5);
vec2(13) <= DataToPins(5)(5);
vec2(14) <= DataToPins(6)(5);
vec2(15) <= DataToPins(7)(5);
vec2(16) <= DataToPins(0)(6);
vec2(17) <= DataToPins(1)(6);
vec2(18) <= DataToPins(2)(6);
vec2(19) <= DataToPins(3)(6);
vec2(20) <= DataToPins(4)(6);
vec2(21) <= DataToPins(5)(6);
vec2(22) <= DataToPins(6)(6);
vec2(23) <= DataToPins(7)(6);
vec2(24) <= DataToPins(0)(7);
vec2(25) <= DataToPins(1)(7);
vec2(26) <= DataToPins(2)(7);
vec2(27) <= DataToPins(3)(7);
vec2(28) <= DataToPins(4)(7);
vec2(29) <= DataToPins(5)(7);
vec2(30) <= DataToPins(6)(7);
vec2(31) <= DataToPins(7)(7);

Inst3: SlowByEight PORT MAP(
		IOpins => IOpins(11 downto 8) ,
		DataToPins => vec3,
		FastClock => FastClock ,
		SlowClockEnable => SlowClockEnable
	);

vec3(0) <= DataToPins(0)(8);
vec3(1) <= DataToPins(1)(8);
vec3(2) <= DataToPins(2)(8);
vec3(3) <= DataToPins(3)(8);
vec3(4) <= DataToPins(4)(8);
vec3(5) <= DataToPins(5)(8);
vec3(6) <= DataToPins(6)(8);
vec3(7) <= DataToPins(7)(8);
vec3(8) <= DataToPins(0)(9);
vec3(9) <= DataToPins(1)(9);
vec3(10) <= DataToPins(2)(9);
vec3(11) <= DataToPins(3)(9);
vec3(12) <= DataToPins(4)(9);
vec3(13) <= DataToPins(5)(9);
vec3(14) <= DataToPins(6)(9);
vec3(15) <= DataToPins(7)(9);
vec3(16) <= DataToPins(0)(10);
vec3(17) <= DataToPins(1)(10);
vec3(18) <= DataToPins(2)(10);
vec3(19) <= DataToPins(3)(10);
vec3(20) <= DataToPins(4)(10);
vec3(21) <= DataToPins(5)(10);
vec3(22) <= DataToPins(6)(10);
vec3(23) <= DataToPins(7)(10);
vec3(24) <= DataToPins(0)(11);
vec3(25) <= DataToPins(1)(11);
vec3(26) <= DataToPins(2)(11);
vec3(27) <= DataToPins(3)(11);
vec3(28) <= DataToPins(4)(11);
vec3(29) <= DataToPins(5)(11);
vec3(30) <= DataToPins(6)(11);
vec3(31) <= DataToPins(7)(11);

Inst4: SlowByEight PORT MAP(
		IOpins => IOpins(15 downto 12) ,
		DataToPins => vec4,
		FastClock => FastClock ,
		SlowClockEnable => SlowClockEnable
	);

vec4(0) <= DataToPins(0)(12);
vec4(1) <= DataToPins(1)(12);
vec4(2) <= DataToPins(2)(12);
vec4(3) <= DataToPins(3)(12);
vec4(4) <= DataToPins(4)(12);
vec4(5) <= DataToPins(5)(12);
vec4(6) <= DataToPins(6)(12);
vec4(7) <= DataToPins(7)(12);
vec4(8) <= DataToPins(0)(13);
vec4(9) <= DataToPins(1)(13);
vec4(10) <= DataToPins(2)(13);
vec4(11) <= DataToPins(3)(13);
vec4(12) <= DataToPins(4)(13);
vec4(13) <= DataToPins(5)(13);
vec4(14) <= DataToPins(6)(13);
vec4(15) <= DataToPins(7)(13);
vec4(16) <= DataToPins(0)(14);
vec4(17) <= DataToPins(1)(14);
vec4(18) <= DataToPins(2)(14);
vec4(19) <= DataToPins(3)(14);
vec4(20) <= DataToPins(4)(14);
vec4(21) <= DataToPins(5)(14);
vec4(22) <= DataToPins(6)(14);
vec4(23) <= DataToPins(7)(14);
vec4(24) <= DataToPins(0)(15);
vec4(25) <= DataToPins(1)(15);
vec4(26) <= DataToPins(2)(15);
vec4(27) <= DataToPins(3)(15);
vec4(28) <= DataToPins(4)(15);
vec4(29) <= DataToPins(5)(15);
vec4(30) <= DataToPins(6)(15);
vec4(31) <= DataToPins(7)(15);

end Behavioral;
