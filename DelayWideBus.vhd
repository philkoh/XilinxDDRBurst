----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:17:58 02/04/2022 
-- Design Name: 
-- Module Name:    DelayWideBus - Behavioral 
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

entity DelayWideBus is
    Port ( 	IncomingDelayed : out  STD_LOGIC_VECTOR (15 downto 0);
				OutgoingDelayed : out  STD_LOGIC_VECTOR (15 downto 0);
				IncomingUndelayed : in  STD_LOGIC_VECTOR (15 downto 0);
				OutgoingUndelayed : in  STD_LOGIC_VECTOR (15 downto 0);
				Tristate : in  STD_LOGIC);
end DelayWideBus;

architecture Behavioral of DelayWideBus is

	COMPONENT Delay
	PORT(
		IncomingUndelayed : IN std_logic_vector(3 downto 0);
		OutgoingUndelayed : IN std_logic_vector(3 downto 0);
		Tristate : IN std_logic;          
		IncomingDelayed : OUT std_logic_vector(3 downto 0);
		OutgoingDelayed : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
begin


Inst_Delay0: Delay PORT MAP(
		IncomingDelayed => IncomingDelayed(3 downto 0),
		OutgoingDelayed => OutgoingDelayed(3 downto 0),
		IncomingUndelayed => IncomingUndelayed(3 downto 0),
		OutgoingUndelayed => OutgoingUndelayed(3 downto 0),
		Tristate => Tristate
	);


Inst_Delay1: Delay PORT MAP(
		IncomingDelayed => IncomingDelayed(7 downto 4),
		OutgoingDelayed => OutgoingDelayed(7 downto 4),
		IncomingUndelayed => IncomingUndelayed(7 downto 4),
		OutgoingUndelayed => OutgoingUndelayed(7 downto 4),
		Tristate => Tristate
	);


Inst_Delay2: Delay PORT MAP(
		IncomingDelayed => IncomingDelayed(11 downto 8),
		OutgoingDelayed => OutgoingDelayed(11 downto 8),
		IncomingUndelayed => IncomingUndelayed(11 downto 8),
		OutgoingUndelayed => OutgoingUndelayed(11 downto 8),
		Tristate => Tristate
	);


Inst_Delay3: Delay PORT MAP(
		IncomingDelayed => IncomingDelayed(15 downto 12),
		OutgoingDelayed => OutgoingDelayed(15 downto 12),
		IncomingUndelayed => IncomingUndelayed(15 downto 12),
		OutgoingUndelayed => OutgoingUndelayed(15 downto 12),
		Tristate => Tristate
	);

end Behavioral;

