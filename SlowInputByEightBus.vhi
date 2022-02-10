
-- VHDL Instantiation Created from source file SlowInputByEightBus.vhd -- 13:02:59 02/10/2022
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT SlowInputByEightBus
	PORT(
		IOpins : IN std_logic_vector(15 downto 0);
		FastClock : IN std_logic;
		SlowClock : IN std_logic;
		SlowClockEnable : IN std_logic;          
		DataToPins : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_SlowInputByEightBus: SlowInputByEightBus PORT MAP(
		IOpins => ,
		DataToPins => ,
		FastClock => ,
		SlowClock => ,
		SlowClockEnable => 
	);


