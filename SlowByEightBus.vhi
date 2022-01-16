
-- VHDL Instantiation Created from source file SlowByEightBus.vhd -- 00:34:10 01/16/2022
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT SlowByEightBus
	PORT(
		DataToPins : IN std_logic_vector(7 downto 0);
		FastClock : IN std_logic;
		SlowClockEnable : IN std_logic;       
		IOpins : INOUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	Inst_SlowByEightBus: SlowByEightBus PORT MAP(
		IOpins => ,
		DataToPins => ,
		FastClock => ,
		SlowClockEnable => 
	);


