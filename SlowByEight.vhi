
-- VHDL Instantiation Created from source file SlowByEight.vhd -- 21:01:24 01/14/2022
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT SlowByEight
	PORT(
		DataToPins : IN std_logic_vector(31 downto 0);
		FastClock : IN std_logic;
		SlowClockEnable : IN std_logic;       
		IOpins : INOUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	Inst_SlowByEight: SlowByEight PORT MAP(
		IOpins => ,
		DataToPins => ,
		FastClock => ,
		SlowClockEnable => 
	);


