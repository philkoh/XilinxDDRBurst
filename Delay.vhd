----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:37:32 02/02/2022 
-- Design Name: 
-- Module Name:    Delay - Behavioral 
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

library UNISIM;
use UNISIM.VComponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Delay is
    Port (    	IncomingDelayed : out  STD_LOGIC_VECTOR (3 downto 0);
					OutgoingDelayed : out  STD_LOGIC_VECTOR (3 downto 0);
					IncomingUndelayed : in  STD_LOGIC_VECTOR (3 downto 0);
					OutgoingUndelayed : in  STD_LOGIC_VECTOR (3 downto 0);
					Tristate : in STD_LOGIC);
end Delay;

architecture Behavioral of Delay is

begin




IODELAY2_inst0 : IODELAY2
generic map (
COUNTER_WRAPAROUND => "WRAPAROUND", -- "STAY_AT_LIMIT" or "WRAPAROUND"
DATA_RATE => "SDR", -- "SDR" or "DDR"
DELAY_SRC => "IO", -- "IO", "ODATAIN" or "IDATAIN"
IDELAY2_VALUE => 0, -- Delay value when IDELAY_MODE="PCI" (0-255)
IDELAY_MODE => "NORMAL", -- "NORMAL" or "PCI"
IDELAY_TYPE => "FIXED", -- "FIXED", "DEFAULT", "VARIABLE_FROM_ZERO", "VARIABLE_FROM_HALF_MAX"
-- or "DIFF_PHASE_DETECTOR"
IDELAY_VALUE => 40, -- Amount of taps for fixed input delay (0-255)
ODELAY_VALUE => 40, -- Amount of taps fixed output delay (0-255)
--IDELAY:
-- 0 gives no change
-- 60 gives no change
-- 90 gives no change
-- 95 gives no change
-- 100 is flickering borderline 1 bit delay
-- 105 gives 1 bit delay
-- 120 gives 1 bit delay

--ODELAY:
-- 0 gives no change
-- 1 gives 1 bit delay
-- 5 gives 1 bit delay
-- 10 gives 1 bit delay
-- 20 gives 1 bit delay
-- 40 gives  1 bit delay
-- 80  gives  1 bit delay
-- 120 gives 1 bit delay
-- 125 gives 2 bit delay
-- 130 gives 2 bit delay
-- 140 gives 2 bit delay
-- 160 gives 2 bit delay
SERDES_MODE => "NONE", -- "NONE", "MASTER" or "SLAVE"
SIM_TAPDELAY_VALUE => 75) -- Per tap delay used for simulation in ps
port map (
--BUSY => BUSY, -- 1-bit output: Busy output after CAL
DATAOUT => IncomingDelayed(0),-- delayedDataPort(0), -- 1-bit output: Delayed data output to ISERDES/input register
--DATAOUT2 => DATAOUT2, -- 1-bit output: Delayed data output to general FPGA fabric
DOUT => OutgoingDelayed(0), --delayedDataForOutput(0), -- 1-bit output: Delayed data output
--TOUT => TOUT, -- 1-bit output: Delayed 3-state output
CAL => '0', -- 1-bit input: Initiate calibration input
CE => '0', -- 1-bit input: Enable INC input
CLK => '0', -- 1-bit input: Clock input
IDATAIN => IncomingUndelayed(0),--dataPort(0), -- 1-bit input: Data input (connect to top-level port or I/O buffer)
INC => '0', -- 1-bit input: Increment / decrement input
IOCLK0 => '0', -- 1-bit input: Input from the I/O clock network
IOCLK1 => '0', -- 1-bit input: Input from the I/O clock network
ODATAIN => OutgoingUnDelayed(0),--dataAssertedToOutput(0), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => Tristate--slowdqsTristate -- 1-bit input: 3-state input signal
);




IODELAY2_inst1 : IODELAY2
generic map (
COUNTER_WRAPAROUND => "WRAPAROUND", -- "STAY_AT_LIMIT" or "WRAPAROUND"
DATA_RATE => "SDR", -- "SDR" or "DDR"
DELAY_SRC => "IO", -- "IO", "ODATAIN" or "IDATAIN"
IDELAY2_VALUE => 0, -- Delay value when IDELAY_MODE="PCI" (0-255)
IDELAY_MODE => "NORMAL", -- "NORMAL" or "PCI"
IDELAY_TYPE => "FIXED", -- "FIXED", "DEFAULT", "VARIABLE_FROM_ZERO", "VARIABLE_FROM_HALF_MAX"
-- or "DIFF_PHASE_DETECTOR"
IDELAY_VALUE => 40, -- Amount of taps for fixed input delay (0-255)
ODELAY_VALUE => 40, -- Amount of taps fixed output delay (0-255)
--IDELAY:
-- 0 gives no change
-- 60 gives no change
-- 90 gives no change
-- 95 gives no change
-- 100 is flickering borderline 1 bit delay
-- 105 gives 1 bit delay
-- 120 gives 1 bit delay

--ODELAY:
-- 0 gives no change
-- 1 gives 1 bit delay
-- 5 gives 1 bit delay
-- 10 gives 1 bit delay
-- 20 gives 1 bit delay
-- 40 gives  1 bit delay
-- 80  gives  1 bit delay
-- 120 gives 1 bit delay
-- 125 gives 2 bit delay
-- 130 gives 2 bit delay
-- 140 gives 2 bit delay
-- 160 gives 2 bit delay
SERDES_MODE => "NONE", -- "NONE", "MASTER" or "SLAVE"
SIM_TAPDELAY_VALUE => 75) -- Per tap delay used for simulation in ps
port map (
--BUSY => BUSY, -- 1-bit output: Busy output after CAL
DATAOUT => IncomingDelayed(1),-- delayedDataPort(0), -- 1-bit output: Delayed data output to ISERDES/input register
--DATAOUT2 => DATAOUT2, -- 1-bit output: Delayed data output to general FPGA fabric
DOUT => OutgoingDelayed(1), --delayedDataForOutput(0), -- 1-bit output: Delayed data output
--TOUT => TOUT, -- 1-bit output: Delayed 3-state output
CAL => '0', -- 1-bit input: Initiate calibration input
CE => '0', -- 1-bit input: Enable INC input
CLK => '0', -- 1-bit input: Clock input
IDATAIN => IncomingUndelayed(1),--dataPort(0), -- 1-bit input: Data input (connect to top-level port or I/O buffer)
INC => '0', -- 1-bit input: Increment / decrement input
IOCLK0 => '0', -- 1-bit input: Input from the I/O clock network
IOCLK1 => '0', -- 1-bit input: Input from the I/O clock network
ODATAIN => OutgoingUnDelayed(1),--dataAssertedToOutput(0), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => Tristate--slowdqsTristate -- 1-bit input: 3-state input signal
);








IODELAY2_inst2 : IODELAY2
generic map (
COUNTER_WRAPAROUND => "WRAPAROUND", -- "STAY_AT_LIMIT" or "WRAPAROUND"
DATA_RATE => "SDR", -- "SDR" or "DDR"
DELAY_SRC => "IO", -- "IO", "ODATAIN" or "IDATAIN"
IDELAY2_VALUE => 0, -- Delay value when IDELAY_MODE="PCI" (0-255)
IDELAY_MODE => "NORMAL", -- "NORMAL" or "PCI"
IDELAY_TYPE => "FIXED", -- "FIXED", "DEFAULT", "VARIABLE_FROM_ZERO", "VARIABLE_FROM_HALF_MAX"
-- or "DIFF_PHASE_DETECTOR"
IDELAY_VALUE => 40, -- Amount of taps for fixed input delay (0-255)
ODELAY_VALUE => 40, -- Amount of taps fixed output delay (0-255)
--IDELAY:
-- 0 gives no change
-- 60 gives no change
-- 90 gives no change
-- 95 gives no change
-- 100 is flickering borderline 1 bit delay
-- 105 gives 1 bit delay
-- 120 gives 1 bit delay

--ODELAY:
-- 0 gives no change
-- 1 gives 1 bit delay
-- 5 gives 1 bit delay
-- 10 gives 1 bit delay
-- 20 gives 1 bit delay
-- 40 gives  1 bit delay
-- 80  gives  1 bit delay
-- 120 gives 1 bit delay
-- 125 gives 2 bit delay
-- 130 gives 2 bit delay
-- 140 gives 2 bit delay
-- 160 gives 2 bit delay
SERDES_MODE => "NONE", -- "NONE", "MASTER" or "SLAVE"
SIM_TAPDELAY_VALUE => 75) -- Per tap delay used for simulation in ps
port map (
--BUSY => BUSY, -- 1-bit output: Busy output after CAL
DATAOUT => IncomingDelayed(2),-- delayedDataPort(0), -- 1-bit output: Delayed data output to ISERDES/input register
--DATAOUT2 => DATAOUT2, -- 1-bit output: Delayed data output to general FPGA fabric
DOUT => OutgoingDelayed(2), --delayedDataForOutput(0), -- 1-bit output: Delayed data output
--TOUT => TOUT, -- 1-bit output: Delayed 3-state output
CAL => '0', -- 1-bit input: Initiate calibration input
CE => '0', -- 1-bit input: Enable INC input
CLK => '0', -- 1-bit input: Clock input
IDATAIN => IncomingUndelayed(2),--dataPort(0), -- 1-bit input: Data input (connect to top-level port or I/O buffer)
INC => '0', -- 1-bit input: Increment / decrement input
IOCLK0 => '0', -- 1-bit input: Input from the I/O clock network
IOCLK1 => '0', -- 1-bit input: Input from the I/O clock network
ODATAIN => OutgoingUnDelayed(2),--dataAssertedToOutput(0), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => Tristate--slowdqsTristate -- 1-bit input: 3-state input signal
);











IODELAY2_inst3 : IODELAY2
generic map (
COUNTER_WRAPAROUND => "WRAPAROUND", -- "STAY_AT_LIMIT" or "WRAPAROUND"
DATA_RATE => "SDR", -- "SDR" or "DDR"
DELAY_SRC => "IO", -- "IO", "ODATAIN" or "IDATAIN"
IDELAY2_VALUE => 0, -- Delay value when IDELAY_MODE="PCI" (0-255)
IDELAY_MODE => "NORMAL", -- "NORMAL" or "PCI"
IDELAY_TYPE => "FIXED", -- "FIXED", "DEFAULT", "VARIABLE_FROM_ZERO", "VARIABLE_FROM_HALF_MAX"
-- or "DIFF_PHASE_DETECTOR"
IDELAY_VALUE => 40, -- Amount of taps for fixed input delay (0-255)
ODELAY_VALUE => 40, -- Amount of taps fixed output delay (0-255)
--IDELAY:
-- 0 gives no change
-- 60 gives no change
-- 90 gives no change
-- 95 gives no change
-- 100 is flickering borderline 1 bit delay
-- 105 gives 1 bit delay
-- 120 gives 1 bit delay

--ODELAY:
-- 0 gives no change
-- 1 gives 1 bit delay
-- 5 gives 1 bit delay
-- 10 gives 1 bit delay
-- 20 gives 1 bit delay
-- 40 gives  1 bit delay
-- 80  gives  1 bit delay
-- 120 gives 1 bit delay
-- 125 gives 2 bit delay
-- 130 gives 2 bit delay
-- 140 gives 2 bit delay
-- 160 gives 2 bit delay
SERDES_MODE => "NONE", -- "NONE", "MASTER" or "SLAVE"
SIM_TAPDELAY_VALUE => 75) -- Per tap delay used for simulation in ps
port map (
--BUSY => BUSY, -- 1-bit output: Busy output after CAL
DATAOUT => IncomingDelayed(3),-- delayedDataPort(0), -- 1-bit output: Delayed data output to ISERDES/input register
--DATAOUT2 => DATAOUT2, -- 1-bit output: Delayed data output to general FPGA fabric
DOUT => OutgoingDelayed(3), --delayedDataForOutput(0), -- 1-bit output: Delayed data output
--TOUT => TOUT, -- 1-bit output: Delayed 3-state output
CAL => '0', -- 1-bit input: Initiate calibration input
CE => '0', -- 1-bit input: Enable INC input
CLK => '0', -- 1-bit input: Clock input
IDATAIN => IncomingUndelayed(3),--dataPort(0), -- 1-bit input: Data input (connect to top-level port or I/O buffer)
INC => '0', -- 1-bit input: Increment / decrement input
IOCLK0 => '0', -- 1-bit input: Input from the I/O clock network
IOCLK1 => '0', -- 1-bit input: Input from the I/O clock network
ODATAIN => OutgoingUnDelayed(3),--dataAssertedToOutput(0), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => Tristate--slowdqsTristate -- 1-bit input: 3-state input signal
);








end Behavioral;

