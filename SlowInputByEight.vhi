
-- VHDL Instantiation Created from source file SlowInputByEight.vhd -- 03:16:12 02/04/2022
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT SlowInputByEight
	PORT(
		IOpins : IN std_logic_vector(3 downto 0);
		FastClock : IN std_logic;
		SlowClockEnable : IN std_logic;          
		DataToPins : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	Inst_SlowInputByEight: SlowInputByEight PORT MAP(
		IOpins => ,
		DataToPins => ,
		FastClock => ,
		SlowClockEnable => 
	);


