
-- VHDL Instantiation Created from source file Delay.vhd -- 01:48:43 02/02/2022
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT Delay
	PORT(
		IncomingUndelayed : IN std_logic_vector(3 downto 0);
		OutgoingUndelayed : IN std_logic_vector(3 downto 0);
		Tristate : IN std_logic;          
		IncomingDelayed : OUT std_logic_vector(3 downto 0);
		OutgoingDelayed : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	Inst_Delay: Delay PORT MAP(
		IncomingDelayed => ,
		OutgoingDelayed => ,
		IncomingUndelayed => ,
		OutgoingUndelayed => ,
		Tristate => 
	);


