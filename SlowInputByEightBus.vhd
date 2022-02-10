----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:46:58 02/10/2022 
-- Design Name: 
-- Module Name:    SlowInputByEightBus - Behavioral 
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

entity SlowInputByEightBus is
    Port ( IOpins : in  STD_LOGIC_VECTOR (3 downto 0);
           DataToPins : out  STD_LOGIC_VECTOR (31 downto 0);
           FastClock : in  STD_LOGIC;
			  SlowClock : IN std_logic;
           SlowClockEnable : in  STD_LOGIC);
end SlowInputByEightBus;

architecture Behavioral of SlowInputByEightBus is

begin


end Behavioral;

