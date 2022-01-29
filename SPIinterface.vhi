
-- VHDL Instantiation Created from source file SPIinterface.vhd -- 21:38:50 01/28/2022
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT SPIinterface
	PORT(
		clk : IN std_logic;
		dataout : IN std_logic_vector(15 downto 0);
		csPin : IN std_logic;
		MOSIpin : IN std_logic;
		sckPin : IN std_logic;          
		datain : OUT std_logic_vector(15 downto 0);
		dataarrivedtoggle : OUT std_logic;
		MISOpin : OUT std_logic
		);
	END COMPONENT;

	Inst_SPIinterface: SPIinterface PORT MAP(
		clk => ,
		dataout => ,
		datain => ,
		dataarrivedtoggle => ,
		csPin => ,
		MISOpin => ,
		MOSIpin => ,
		sckPin => 
	);


