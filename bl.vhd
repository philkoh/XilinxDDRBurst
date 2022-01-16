----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:25:50 02/28/2019 
-- Design Name: 
-- Module Name:    bl - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;
use work.common.all;

entity bl is
    Port ( 
			blinkerPORT : out  STD_LOGIC;
			clk : in  STD_LOGIC;
			LED0 : out STD_LOGIC;
			LED1 : out STD_LOGIC;
			LED2 : out STD_LOGIC;
			LED3 : out STD_LOGIC;
			baPORT : out std_logic_vector(2 downto 0);
			addrPORT : out std_logic_vector(14 downto 0);
		   dataPORT : inout std_logic_vector(15 downto 0);

			casPORT : out std_logic;
			rasPORT : out std_logic;
			wePORT : out std_logic;
			resetPort : out std_logic;
			ckePort : out std_logic;


			

			ck_pPORT : inout std_logic; 
			ck_nPORT : inout std_logic;

   		dqs0_pPORT : inout std_logic;
--			dqs0_pPORT : inout std_logic; 
			dqs0_nPORT : inout std_logic;
			dqs1_pPORT : inout std_logic; 
			dqs1_nPORT : inout std_logic;

			dqm0PORT : out std_logic; 
			dqm1PORT : out std_logic; 
			odtPORT : out std_logic; 
			

			
			switch2PORT : in std_logic;
			switch3PORT : in std_logic;
			


			dummyOut : out std_logic  -- just used to eliminate annoying warning


			  );
end bl;





architecture Behavioral of bl is
component PhilClock
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic
  
 );
end component;



	COMPONENT SlowByEightBus
	PORT(
		DataToPins : in  burstArr;
		FastClock : IN std_logic;
		SlowClockEnable : IN std_logic;       
		IOpins : INOUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;







------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT FIFOphil2
  PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(143 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(143 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------





	COMPONENT SlowByEight
	PORT(
		DataToPins : IN std_logic_vector(31 downto 0);
		FastClock : IN std_logic;
		SlowClockEnable : IN std_logic;       
		IOpins : INOUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	







	signal clk250MHz : std_logic := '0';
	signal clk125MHz : std_logic := '0';
	signal clk125MHz_n : std_logic := '0';
	signal nextClk125MHz : std_logic := '0';
	signal nextClk125MHz_n : std_logic := '0';

--	signal clk250MHz_n : std_logic := '0';
	
	signal ck_p : std_logic := '0';


	signal blinker  : std_logic := '0';
	signal nextBlinker  : std_logic := '0';
	signal clockEnableBeginning : std_logic := '0';
	signal clockEnableCommand : std_logic := '0';
--	signal clockEnableLoadWriteData : std_logic := '0';
	signal clockEnableRefillWriteData : std_logic := '0';
--	signal writeAndRefillThisCycle : std_logic := '0';
--	signal nextwriteAndRefillThisCycle : std_logic := '0';
	signal clockEnableRead : std_logic := '0';
	signal clockEnableWrite : std_logic := '0';
	signal nextClockEnableBeginning : std_logic := '0';
	signal nextClockEnableCommand : std_logic := '0';
--	signal nextClockEnableLoadWriteData : std_logic := '0';
	signal nextClockEnableRefillWriteData : std_logic := '0';
	signal nextClockEnableRead : std_logic := '0';
	signal nextClockEnableWrite : std_logic := '0';
	
	signal writeThisCycle : std_logic := '0';
	signal nextWriteThisCycle : std_logic ;
	
	signal advanceTheShiftRegister : std_logic := '0';
	signal nextAdvanceTheShiftRegister : std_logic;

	signal refillTheShiftRegister : std_logic := '0';
	signal nextRefillTheShiftRegister : std_logic;


	
   signal count2 : unsigned (5 downto 0) := "000000";
   signal count : unsigned (17 downto 0) := "000000000000000000";
   signal nextCount2 : unsigned (5 downto 0);
   signal nextCount : unsigned (17 downto 0);
--	signal dqszero : std_logic := '0';
--	signal dqsone : std_logic := '1';
	signal dqs0 : std_logic := '0'; 
--	signal dqs0T : std_logic := '0'; 
	signal dqs1 : std_logic := '0'; 
--	signal dqs1T : std_logic := '0'; 
	signal dqs0Incoming : std_logic := '0';
	signal dqs1Incoming : std_logic := '0';

	signal dqsTristate : std_logic := '1'; 
	signal nextDqsTristate : std_logic := '1'; 
	
	signal odt : std_logic := '1';
	signal nextOdt : std_logic := '1';
	signal ba :   std_logic_vector(2 downto 0);
	signal nextBa :   std_logic_vector(2 downto 0);
	signal addrOut :   std_logic_vector(14 downto 0);
	signal nextAddrOut :   std_logic_vector(14 downto 0);
	signal addrRequest :   std_logic_vector(14 downto 0);
	signal nextAddrRequest :   std_logic_vector(14 downto 0);
	signal dataCount :   unsigned (3 downto 0)  := "1111";
	signal nextDataCount :   unsigned (3 downto 0):= "1111";
	signal data :   std_logic_vector(15 downto 0) := "1111111111111111";
	signal nextData :   std_logic_vector(15 downto 0):= "1111111111111111";
	signal inData :   std_logic_vector(15 downto 0);
	signal inDataB :   std_logic_vector(15 downto 0);
	
	type philArr is array (20 downto 0) of std_logic_vector(15 downto 0);
	signal requestedDataToWrite : philArr;
	signal nextRequestedDataToWrite : philArr;
	
	signal writeRefill :  philArr;
	signal nextWriteRefill :  philArr;
	
	 
	signal capturedData :   philArr;
	signal nextCapturedData :   philArr;
	
	signal shiftRegister : philArr;
	signal nextShiftRegister : philArr;
	
	
	signal writePulseTrain :    std_logic_vector(15 downto 1) := "000000000000000";
	signal nextWritePulseTrain :    std_logic_vector(15 downto 1) ;
	
	
	signal dataAssertedToOutput : std_logic_vector(15 downto 0);
	signal nextdataAssertedToOutput : std_logic_vector(15 downto 0);
	signal delayedDataForOutput : std_logic_vector(15 downto 0);
	
	signal delayedDataPort : std_logic_vector(15 downto 0);

	

	signal reset : std_logic := '1';
	signal nextReset : std_logic := '1';
	signal cke : std_logic := '1';
	signal nextCke : std_logic := '1';

	signal cas : std_logic := '1';
	signal nextCas : std_logic := '1';
	signal casRequest : std_logic := '1';
	signal nextCasRequest : std_logic := '1';

	signal ras : std_logic := '1';
	signal nextRas : std_logic := '1';
	signal rasRequest : std_logic := '1';
	signal nextRasRequest : std_logic := '1';

	signal we : std_logic := '1';
	signal nextWe : std_logic := '1';
	signal weRequest : std_logic := '1';
	signal nextWeRequest : std_logic := '1';

	
	signal writeRequest : std_logic := '0';
	signal nextWriteRequest : std_logic := '0';
	
	signal saveRequest : std_logic := '0';
	signal nextSaveRequest : std_logic := '0';
	signal saveRequest2 : std_logic := '0';
	signal nextSaveRequest2 : std_logic := '0';
	signal saveRequest3 : std_logic := '0';
	signal nextSaveRequest3 : std_logic := '0';
	signal saveRequest4 : std_logic := '0';
	signal nextSaveRequest4 : std_logic := '0';
	
	

	signal switchRegister : std_logic := '0';
	signal nextSwitchRegister : std_logic := '0';
   signal lastSwitchRegister : std_logic := '0';

   signal switchCount : unsigned (3 downto 0) := "0000";
   signal nextSwitchCount : unsigned (3 downto 0) := "0000";
   
	
	signal din : std_logic_vector(143 downto 0);
	signal nextdin : std_logic_vector(143 downto 0);
	signal dout : std_logic_vector(143 downto 0);
	signal doutWaiting : std_logic_vector(143 downto 0);
	signal nextDoutWaiting : std_logic_vector(143 downto 0);
	signal rst : std_logic ;
	signal empty : std_logic;
	
	signal sharpenFIFOpushEnable : std_logic_vector (5 downto 0) := "000000";
	signal sharpenFIFOpullEnable : std_logic_vector (5 downto 0) := "000000";
	
	signal dinLSBs: std_logic_vector(3 downto 0);
	signal nextDinLSBs : std_logic_vector(3 downto 0);
	signal doutLSBs: std_logic_vector(3 downto 0);
	signal doutWaitingLSBs: std_logic_vector(3 downto 0);
	
	
	signal IOpinsA : std_logic_vector(3 downto 0);
	signal IOpinsB : std_logic_vector(3 downto 0);
 
	signal dataToPinsA : std_logic_vector(31 downto 0);
	signal dataToPinsB : std_logic_vector(31 downto 0);
	
	signal slowClockEnable : std_logic;
	signal slowClockVector : std_logic_vector(7 downto 0) := "00100000";


	type stateTypes IS (slowReset, ckeLOW, startWriting,   stopWriting, idle, activate, writeMRS);
	signal currentState : stateTypes := slowReset;
	signal nextState : stateTypes;

	signal csFast, rasFast, casFast, weFast : std_logic;
	signal csSlow, rasSlow, casSlow, weSlow : std_logic_vector(7 downto 0);

	signal clkOutFast, dqsFast : std_logic;
	signal clkOutSlow, dqsSlow : std_logic_vector(7 downto 0);


	signal slowCount : unsigned (17 downto 0) := "000000000000000000";
	signal nextSlowCount : unsigned (17 downto 0) ;
	signal burstCount : unsigned (7 downto 0) := "00000000";
	signal nextBurstCount : unsigned (7 downto 0) ;

	signal slowWritingPulseTrain : std_logic_vector (3 downto 0)  := "0000";
	signal nextSlowWritingPulseTrain : std_logic_vector  (3 downto 0);
	
	signal slowWriteData, slowWriteAddress : burstArr;
	signal fastWriteData, fastWriteAddress : std_logic_vector(15 downto 0);
	signal addr : std_logic_vector(15 downto 0) := "0000000011000000";
	signal   nextAddr: std_logic_vector(15 downto 0);
	
	signal slowBA : std_logic_vector(2 downto 0) := "000";
	signal nextSlowBA : std_logic_vector(2 downto 0)  ;
	signal slowResetPort, slowCKEPort, slowFIFOrst : std_logic;
	
	
begin


MainControlOutputsA: SlowByEight PORT MAP(
		IOpins => IOpinsA ,
		DataToPins => dataToPinsA,
		FastClock => clk250MHz ,
		SlowClockEnable => slowClockEnable
	);
	
csFast <= IOpinsA(0);
rasFast <= IOpinsA(1);
casFast <= IOpinsA(2);
weFast <= IOpinsA(3);

dataToPinsA(7 downto 0) <= csSlow;
dataToPinsA(15 downto 8) <= rasSlow ;
dataToPinsA(23 downto 16) <= casSlow;
dataToPinsA(31 downto 24) <= weSlow ;





ClockAndDQSB: SlowByEight PORT MAP(
		IOpins => IOpinsB ,
		DataToPins => dataToPinsB,
		FastClock => clk250MHz ,
		SlowClockEnable => slowClockEnable
	);
	
clkOutFast <= IOpinsB(0);
dqsFast <= IOpinsB(1);
 

dataToPinsB(7 downto 0) <= clkOutSlow;
dataToPinsB(15 downto 8) <= dqsSlow ;



DataBus: SlowByEightBus PORT MAP(
	IOpins => fastWriteData ,
	DataToPins => slowWriteData,
	FastClock => clk250MHz ,
	SlowClockEnable =>  slowClockEnable
);


AddressBus: SlowByEightBus PORT MAP(
	IOpins => fastWriteAddress ,
	DataToPins => slowWriteAddress,
	FastClock => clk250MHz ,
	SlowClockEnable =>  slowClockEnable
);




-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
fifoInstance : FIFOphil2
  PORT MAP (
    rst => rst,
     wr_clk => clk250MHz,
    rd_clk => clk250MHz,
    din => din,
    wr_en => sharpenFIFOpushEnable(5) ,
    rd_en => sharpenFIFOpullEnable(5) ,
    dout => dout,
--    full => full,
  empty => empty
  );
-- INST_TAG_END ------ End INSTANTIATION Template ------------




	process (clk250MHz)  -- FIFOenable sharpener; it will turn any rising edge into a two cycle-pulse, then further sharpen to a one-cycle pulse at 250 MHz.
		begin
	------------------------------------------SEQUENTIAL :	
		if rising_edge(clk250MHz) then
			sharpenFIFOpushEnable(4) <= sharpenFIFOpushEnable(3) and (not sharpenFIFOpushEnable(4));  -- only on rising edge of sharpenFIFOpushEnable(2) 
			sharpenFIFOpushEnable(5) <= sharpenFIFOpushEnable(4);

			sharpenFIFOpullEnable(4) <= sharpenFIFOpullEnable(3) and (not sharpenFIFOpullEnable(4));  -- only on rising edge of sharpenFIFOpushEnable(2) 
			sharpenFIFOpullEnable(5) <= sharpenFIFOpullEnable(4);

	
		end if;
	end process;

	process (clk250MHz, clk125MHz)  -- FIFO enable sharpener; it will turn any rising edge into a two cycle-pulse, then further sharpen to a one-cycle pulse at 250 MHz.
		begin
	------------------------------------------SEQUENTIAL :	
		if rising_edge(clk250MHz) and clk125MHz = '1' then
			sharpenFIFOpushEnable(1) <= sharpenFIFOpushEnable(0);
			sharpenFIFOpushEnable(2) <= sharpenFIFOpushEnable(1);
			sharpenFIFOpushEnable(3) <= sharpenFIFOpushEnable(1) and (not sharpenFIFOpushEnable(2)); -- only on rising edge of sharpenFIFOpushEnable(1) 
 
	--		sharpenFIFOpullEnable(1) <= sharpenFIFOpullEnable(0);
			sharpenFIFOpullEnable(2) <= sharpenFIFOpullEnable(1);
			sharpenFIFOpullEnable(3) <= sharpenFIFOpullEnable(1) and (not sharpenFIFOpullEnable(2)); -- only on rising edge of sharpenFIFOpushEnable(1) 
 end if;
  end process;


	------------------------------------------COMBINATORIAL:
 
dinLSBs <= din(3 downto 0); -- for easier inspection of simulations:
nextDinLSBs <= nextDin(3 downto 0);
doutLSBs <= dout(3 downto 0);
doutWaitingLSBs <= doutWaiting(3 downto 0);

 






















------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : PhilClock
  port map
   (-- Clock in ports
    CLK_IN1 => clk,
    -- Clock out ports
    CLK_OUT1 => clk250MHz);
-- INST_TAG_END ------ End INSTANTIATION Template ------------




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
DATAOUT => delayedDataPort(0), -- 1-bit output: Delayed data output to ISERDES/input register
--DATAOUT2 => DATAOUT2, -- 1-bit output: Delayed data output to general FPGA fabric
DOUT => delayedDataForOutput(0), -- 1-bit output: Delayed data output
--TOUT => TOUT, -- 1-bit output: Delayed 3-state output
CAL => '0', -- 1-bit input: Initiate calibration input
CE => '0', -- 1-bit input: Enable INC input
CLK => '0', -- 1-bit input: Clock input
IDATAIN => dataPort(0), -- 1-bit input: Data input (connect to top-level port or I/O buffer)
INC => '0', -- 1-bit input: Increment / decrement input
IOCLK0 => '0', -- 1-bit input: Input from the I/O clock network
IOCLK1 => '0', -- 1-bit input: Input from the I/O clock network
ODATAIN => dataAssertedToOutput(0), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => dqsTristate -- 1-bit input: 3-state input signal
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
DATAOUT => delayedDataPort(1), -- 1-bit output: Delayed data output to ISERDES/input register
--DATAOUT2 => DATAOUT2, -- 1-bit output: Delayed data output to general FPGA fabric
DOUT => delayedDataForOutput(1), -- 1-bit output: Delayed data output
--TOUT => TOUT, -- 1-bit output: Delayed 3-state output
CAL => '0', -- 1-bit input: Initiate calibration input
CE => '0', -- 1-bit input: Enable INC input
CLK => '0', -- 1-bit input: Clock input
IDATAIN => dataPort(1), -- 1-bit input: Data input (connect to top-level port or I/O buffer)
INC => '0', -- 1-bit input: Increment / decrement input
IOCLK0 => '0', -- 1-bit input: Input from the I/O clock network
IOCLK1 => '0', -- 1-bit input: Input from the I/O clock network
ODATAIN => dataAssertedToOutput(1), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => dqsTristate -- 1-bit input: 3-state input signal
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
DATAOUT => delayedDataPort(2), -- 1-bit output: Delayed data output to ISERDES/input register
--DATAOUT2 => DATAOUT2, -- 1-bit output: Delayed data output to general FPGA fabric
DOUT => delayedDataForOutput(2), -- 1-bit output: Delayed data output
--TOUT => TOUT, -- 1-bit output: Delayed 3-state output
CAL => '0', -- 1-bit input: Initiate calibration input
CE => '0', -- 1-bit input: Enable INC input
CLK => '0', -- 1-bit input: Clock input
IDATAIN => dataPort(2), -- 1-bit input: Data input (connect to top-level port or I/O buffer)
INC => '0', -- 1-bit input: Increment / decrement input
IOCLK0 => '0', -- 1-bit input: Input from the I/O clock network
IOCLK1 => '0', -- 1-bit input: Input from the I/O clock network
ODATAIN => dataAssertedToOutput(2), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => dqsTristate -- 1-bit input: 3-state input signal
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
DATAOUT => delayedDataPort(3), -- 1-bit output: Delayed data output to ISERDES/input register
--DATAOUT2 => DATAOUT2, -- 1-bit output: Delayed data output to general FPGA fabric
DOUT => delayedDataForOutput(3), -- 1-bit output: Delayed data output
--TOUT => TOUT, -- 1-bit output: Delayed 3-state output
CAL => '0', -- 1-bit input: Initiate calibration input
CE => '0', -- 1-bit input: Enable INC input
CLK => '0', -- 1-bit input: Clock input
IDATAIN => dataPort(3), -- 1-bit input: Data input (connect to top-level port or I/O buffer)
INC => '0', -- 1-bit input: Increment / decrement input
IOCLK0 => '0', -- 1-bit input: Input from the I/O clock network
IOCLK1 => '0', -- 1-bit input: Input from the I/O clock network
ODATAIN => dataAssertedToOutput(3), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => dqsTristate -- 1-bit input: 3-state input signal
);





IOBUFDS_dqs0 : IOBUFDS
generic map (
IOSTANDARD => "DIFF_SSTL15_II")
port map (
O => dqs0Incoming, -- received dqs from DRAM
IO => dqs0_pPORT, -- Diff_p inout (connect directly to top-level port)
IOB => dqs0_nPORT, -- Diff_n inout (connect directly to top-level port)
I => clk125MHz, -- outgoing dqs is just always the 125MHz clock
T => dqsTristate -- 3-state enable input, high=input, low=output
);




-- IOBUFDS: Differential Bi-directional Buffer
-- Spartan-3/3E/3A
-- Xilinx HDL Libraries Guide, version 14.7
IOBUFDS_dqs1 : IOBUFDS
generic map (
IOSTANDARD => "DIFF_SSTL15_II")
port map (
O => dqs1Incoming, -- Buffer output
IO => dqs1_pPORT, -- Diff_p inout (connect directly to top-level port)
IOB => dqs1_nPORT, -- Diff_n inout (connect directly to top-level port)
I => clk125MHz, -- Buffer input
T => dqsTristate -- 3-state enable input, high=input, low=output
);
-- End of IOBUFDS_inst instantiation




-- OBUFDS: Differential Output Buffer
-- Spartan-3/3E/3A
-- Xilinx HDL Libraries Guide, version 11.2
OBUFDS_clock : OBUFDS
generic map (
IOSTANDARD => "DIFF_SSTL15_II")
port map (
O => ck_pPORT, -- Diff_p output (connect directly to top-level port)
OB => ck_nPORT, -- Diff_n output (connect directly to top-level port)
I => clk125MHz -- Buffer input
);
-- End of OBUFDS_inst instantiation










	process (clk250MHz)
	
	
		begin
	
------------------------------------------SEQUENTIAL :	
		if falling_edge(clk250MHz) then
			dataCount <= nextDataCount;

		end if;
  end process;


	------------------------------------------COMBINATORIAL:
	process (dataCount)
		begin
		
		nextDataCount <= dataCount + 1;


	end process;





process (clk250MHz, advanceTheShiftRegister)
		begin
------------------------------------------SEQUENTIAL :			
		if rising_edge(clk250MHz) and advanceTheShiftRegister = '1' then  
			shiftRegister <= nextShiftRegister;
		end if;
   end process;
	
------------------------------------------COMBINATORIAL:
	process (refillTheShiftRegister, writeRefill, shiftRegister)
		begin
		if refillTheShiftRegister = '1' then
			nextdataAssertedToOutput <= writeRefill(0);
			nextShiftRegister(6 downto 0) <= writeRefill(7 downto 1);
		else
			nextdataAssertedToOutput <= shiftRegister(0);
			nextShiftRegister(5 downto 0) <= shiftRegister(6 downto 1);
			nextShiftRegister(6) <= (15 downTo 0 => '0');
		end if;
		
	end process;

		





	process (clk250MHz)
	
	
		begin
	
------------------------------------------SEQUENTIAL :	
		if rising_edge(clk250MHz) then
			clk125MHz <=  nextClk125MHz  ;  --clk125MHz changes on rising edge of 250MHz clock; this is sent out as external clock *and* as dqs
			inData (15 downTo 4) <= dataPort (15 downTo 4);  -- data uses the 250 MHz clock
			inData (3 downto 0) <= delayedDataPort (3 downto 0);  -- data uses the 250 MHz clock


			capturedData(11 downto 1) <= nextCapturedData(11 downto 1);
			
			dataAssertedToOutput <= nextdataAssertedToOutput;
			
			  
			advanceTheShiftRegister <= nextAdvanceTheShiftRegister  ;
			refillTheShiftRegister <= nextRefillTheShiftRegister  ;
			

		 		
		
		 	 
		 
			
		end if;
	end process;

		------------------------------------------COMBINATORIAL:
	 

	process (clk125MHz,count2,cas,casRequest,ras,rasRequest,we,weRequest,saveRequest,inData,  clockEnableRead, capturedData, dqsTristate, delayedDataForOutput, dataAssertedToOutput, clockEnableWrite, clockEnableRefillWriteData, refillTheShiftRegister)
	
	
		begin
		

		nextClk125MHz <= not clk125MHz;
		
		nextCapturedData(11 downto 1) <= capturedData(11 downto 1); --unless overridden below, hold and remember the captured values
			
		
		------------------------------------ NOTE: every clockEnable runs twice, on a rising then falling edge of the 125MHz clock, on two consecutive rising 250MHz edges
		------------------------------------ NOTE: every clockEnable runs twice, on a rising then falling edge of the 125MHz clock, on two consecutive rising 250MHz edges
		------------------------------------ NOTE: every clockEnable runs twice, on a rising then falling edge of the 125MHz clock, on two consecutive rising 250MHz edges
		------------------------------------ NOTE: every clockEnable runs twice, on a rising then falling edge of the 125MHz clock, on two consecutive rising 250MHz edges
		------------------------------------ NOTE: every clockEnable runs twice, on a rising then falling edge of the 125MHz clock, on two consecutive rising 250MHz edges
		------------------------------------ NOTE: every clockEnable runs twice, on a rising then falling edge of the 125MHz clock, on two consecutive rising 250MHz edges
	
		if clockEnableRead = '1'  then --capture data, actually captures 8 times, I think, 4 cycles of count2 at 125MHz, but two rising edges of 250 MHz per count2 incremena
			nextCapturedData(1) <= inData;
			
			nextCapturedData(11 downto 2) <= capturedData(10 downto 1);
			
		end if;

		
		if dqsTristate = '1' then
			dataPort (15 downTo 0) <= (15 downTo 0 => 'Z');	
		else
			dataPort(3 downto 0) <= delayedDataForOutput(3 downto 0);
			dataPort(15 downto 4) <= dataAssertedToOutput (15 downto 4);
			
		end if;
	

	 
		nextAdvanceTheShiftRegister <= '0';
		if clockEnableWrite = '1'  then --write data, and pull down the stack of registers
			nextAdvanceTheShiftRegister <= '1';
		end if;
		
		nextRefillTheShiftRegister <= '0';
		if clockEnableRefillWriteData = '1' and refillTheShiftRegister = '0' then -- make pulse only 1 cycle long (the clockEnable pulse is two cycles)
			nextRefillTheShiftRegister <= '1';
		end if;

	
		
	end process;
		
		
		
	process (clk250MHz, clk125MHz)
	
	
		begin
	
------------------------------------------SEQUENTIAL :	
			
		
		if rising_edge(clk250MHz) and clk125MHz = '1' then  -- this is a falling edge of clk125MHz
		
			count2 <= nextCount2;    -- count2 runs at 125 MHz
			clockEnableBeginning <= nextClockEnableBeginning;  --clockEnable registers change on falling edge of clk125MHz
			clockEnableCommand <= nextClockEnableCommand;
			clockEnableRefillWriteData <= nextClockEnableRefillWriteData;
			clockEnableRead <= nextClockEnableRead;
			clockEnableWrite <= nextClockEnableWrite;
		
			cas <= nextCas;
			ras <= nextRas;
			we <= nextWe;

			switchRegister <= nextSwitchRegister;
			switchCount <= nextSwitchCount;
			lastSwitchRegister <= switchRegister;

			writeRefill  <= nextWriteRefill ;
 		   addrOut <= nextAddrOut;

			writePulseTrain <= nextWritePulseTrain;
			doutWaiting <= nextDoutWaiting;
		end if;
		
   end process;
	
------------------------------------------COMBINATORIAL:
	casPORT <= cas;
	rasPORT <= ras;
	wePORT <= we;

	nextWritePulseTrain (15 downto 2) <= writePulseTrain (14 downto 1);



	process (empty, nextwritepulsetrain, doutwaiting, dout, saveRequest, clockEnableCommand, casRequest, rasRequest, weRequest, capturedData, writeRefill, addrOut, switchRegister, lastSwitchRegister, writeRequest, writePulseTrain,  addrRequest, switch2port, switch3Port, switchCount, count2)
	
		begin
		
		nextWriteRefill <=	writeRefill     ;
	 	nextAddrOut <= addrOut;--unless overridden below, hold and remember the loaded values
		addrPort <= addrOut;
	
		
	
		nextSwitchRegister <= switchRegister;
		if switch2PORT = '0' then
			nextSwitchRegister <= '0';
		end if;
		if switch3PORT = '0' then 
			nextSwitchRegister <= '1';
		end if;
		nextSwitchCount <= switchCount;
		if switchRegister /= lastSwitchRegister then
			nextSwitchCount <= switchCount + 1;
		end if;

 		LED0 <= switchCount(0);
		LED1 <= switchCount(1);
 		LED2 <= switchCount(2);
		LED3 <= switchCount(3);

		nextCount2 <= count2 + 1;  -- count2 increments at 125 MHz, not 250 MHz
		if count2 = 1 then 
	--		nextCount2 <= count2 + 14;  --skip ahead to shorten the cycle
		end if;
			
		if count2 = 0    then
			nextClockEnableBeginning <= '1';  -- this flag executes all the block of code below that changes signals on the count2 = 0 edge 
		else
			nextClockEnableBeginning <= '0';
		end if;
		
		if count2 = 16   then   -- this pulses the CAS/RAS/WE command that must get sent for the read or write cycle
			nextClockEnableCommand <= '1';
		else
			nextClockEnableCommand <= '0';
		end if;
			
		if clockEnableCommand = '1' then  --the CAS/RAS/WE command is only applied for this one 125 MHz clock cycle just after count2=16
			nextCas <= casRequest;
			nextRas <= rasRequest;
			nextWe <= weRequest;
		else                      -- otherwise, CAS/RAS/WE are held HIGH (which is the NOP, No Operation command)
			nextCas <= '1';
			nextRas <= '1';
			nextWe <= '1';
		end if;
		
		
		
		
		nextWritePulseTrain (1) <= '0';
		if count2 = 16 and writeRequest = '1' and empty = '0' then
			nextWritePulseTrain (1) <= '1';
		end if;

		if count2 = 19 and  writeRequest = '1' and empty = '0' then  -- during a write cycle, pulse a second write command
			nextCount2 <= count2 - 3;  -- leap backwards by 4 count2's of the sequence; instead of going to count2=20 next time, go to count2=16
		end if;

		
		if count2 = 20 and  writeRequest = '1' then  -- during a write cycle, pulse a second write command
	--		nextClockEnableCommand <= '1';
	--  	nextWritePulseTrain(1) <= '1'; -- this starts a second sequence of write actions for the second burst of data
		end if;
		
		if nextWritePulseTrain(1) = '1' then
			sharpenFIFOpullEnable(1) <= '1';
			nextDoutWaiting <= dout;
		else
			sharpenFIFOpullEnable(1) <= '0';   
			nextDoutWaiting <= doutWaiting;
		end if;
			
		if count2 = 5   then   -- this loads address  
			nextAddrOut <= addrRequest;
		end if;

	--	if count2 = 17   then   -- this increments the address
		if writePulseTrain(2) = '1' then
				nextAddrOut <= 			std_logic_vector(to_unsigned((to_integer(unsigned(addrOut)) + 8),15)); -- increment column address by 8
		end if;
			
			
	--	if count2 = 20 and writeRequest = '1' then  -- this replaces the waiting data from fifo
		if writePulseTrain(4) = '1' then
	--			nextWriteRefill(0) <= "0000000000001001"; 
	--			nextWriteRefill(1) <= "0000000000000110"; 
	--			nextWriteRefill(2) <= "0000000000001100"; 
	--	 		nextWriteRefill(3) <= "0000000000001010"; 
	--			nextWriteRefill(4) <= "0000000000000101"; 
	--			nextWriteRefill(5) <= "0000000000000111"; 
	--			nextWriteRefill(6) <= "0000000000001111"; 
	--			nextWriteRefill(7) <= "0000000000001011"; 
	
			nextWriteRefill(0) <= doutWaiting (15 downto 0); 
			nextWriteRefill(1) <= doutWaiting (31 downto 16); 
			nextWriteRefill(2) <= doutWaiting (47 downto 32); 
	 		nextWriteRefill(3) <= doutWaiting (63 downto 48); 
			nextWriteRefill(4) <= doutWaiting (79 downto 64); 
			nextWriteRefill(5) <= doutWaiting (95 downto 80); 
			nextWriteRefill(6) <= doutWaiting (111 downto 96); 
			nextWriteRefill(7) <= doutWaiting (127 downto 112); 
	
	--		sharpenFIFOpullEnable(0) <= '1';  -- this will advance the FIFO later 
		end if;
			
			
			
		
		nextClockEnableRefillWriteData <= '0';
--		if count2 = 22  and writeRequest = '1'   then   -- this refills more write data onto the outgoing stack
		if writePulseTrain(6) = '1' then
			nextClockEnableRefillWriteData <= '1';
		end if;
	--	if count2 = 26 and writeRequest = '1'   then   -- this refills more write data onto the outgoing stack
	--		nextClockEnableRefillWriteData <= '1';
--		end if;


		if count2 = 24 and writeRequest = '1' then  -- this replaces the waiting data from fifo
--			nextWriteRefill(0) <= "0000000000000001"; 
--			nextWriteRefill(1) <= "0000000000000010"; 
--			nextWriteRefill(2) <= "0000000000000100"; 
--			nextWriteRefill(3) <= "0000000000001000"; 
--			nextWriteRefill(4) <= "0000000000001100"; 
--			nextWriteRefill(5) <= "0000000000000110"; 
--			nextWriteRefill(6) <= "0000000000000011"; 
--			nextWriteRefill(7) <= "0000000000000111"; 
	
		end if;
			
			
--			if (count2 = 23 or count2 = 24 or count2 = 25 or count2 = 26)   then  --reads for 4 cycles of 125MHz count2
		if (count2 = 24 or count2 = 25 or count2 = 26 or count2 = 27) and saveRequest = '1'   then  --reads for 4 cycles of 125MHz count2
--			if count2 = 26 or count2 = 27 or count2 = 28 or count2 = 29 then
			nextClockEnableRead <= '1';
		else
			nextClockEnableRead <= '0';
		end if;
		

	--	if (count2 = 22 or count2 = 23 or count2 = 24 or count2 = 25 or count2 = 26 or count2 = 27 or count2 = 28 or count2 = 29 or count2 = 30  ) and writeRequest = '1'   then  --writes for 4 cycles of 125MHz count2
		if writePulseTrain(6) = '1' or writePulseTrain(7) = '1'  or writePulseTrain(8) = '1'  or writePulseTrain(9) = '1'  or writePulseTrain(10) = '1' then
			nextClockEnableWrite <= '1';
		else
			nextClockEnableWrite <= '0';
		end if;
		

		if switchCount = 0 then
			LED0 <=   capturedData(1)(0);
			LED1 <=    capturedData(1)(1);
			LED2 <=    capturedData(1)(2);
			LED3 <=    capturedData(1)(3);
	   end if;
		if switchCount = 1 then
			LED0 <=   capturedData(2)(0);
			LED1 <=    capturedData(2)(1);
			LED2 <=    capturedData(2)(2);
			LED3 <=    capturedData(2)(3);
		end if;
		if switchCount = 2 then
			LED0 <=   capturedData(3)(0);
			LED1 <=    capturedData(3)(1);
			LED2 <=    capturedData(3)(2);
			LED3 <=    capturedData(3)(3);
		end if;
		if switchCount = 3 then
			LED0 <=   capturedData(4)(0);
			LED1 <=    capturedData(4)(1);
			LED2 <=    capturedData(4)(2);
			LED3 <=    capturedData(4)(3);
		end if;
		if switchCount = 4 then
			LED0 <=   capturedData(5)(0);
			LED1 <=    capturedData(5)(1);
			LED2 <=    capturedData(5)(2);
			LED3 <=    capturedData(5)(3);
		end if;
		if switchCount = 5 then
			LED0 <=   capturedData(6)(0);
			LED1 <=    capturedData(6)(1);
			LED2 <=    capturedData(6)(2);
			LED3 <=    capturedData(6)(3);
		end if;
		if switchCount = 6 then
			LED0 <=   capturedData(7)(0);
			LED1 <=    capturedData(7)(1);
			LED2 <=    capturedData(7)(2);
			LED3 <=    capturedData(7)(3);
		end if;
		if switchCount = 7 then
				LED0 <=   capturedData(8)(0);
				LED1 <=    capturedData(8)(1);
				LED2 <=    capturedData(8)(2);
				LED3 <=    capturedData(8)(3);
		end if;

		if switchCount = 8 then
				LED0 <=   capturedData(9)(0);
				LED1 <=    capturedData(9)(1);
				LED2 <=    capturedData(9)(2);
				LED3 <=    capturedData(9)(3);
		end if;

	   if switchCount = 9 then
				LED0 <=   capturedData(10)(0);
				LED1 <=    capturedData(10)(1);
				LED2 <=    capturedData(10)(2);
				LED3 <=    capturedData(10)(3);
		end if;

		if switchCount = 10 then
				LED0 <=   capturedData(11)(0);
				LED1 <=    capturedData(11)(1);
				LED2 <=    capturedData(11)(2);
				LED3 <=    capturedData(11)(3);
		end if;

   end process;
	
	
	
	
	
------------------------------------------SEQUENTIAL :	
	process (clk250MHz, clk125MHz, ClockEnableBeginning)

		begin
	
		if rising_edge(clk250MHz) and ClockEnableBeginning = '1' and clk125MHz = '1' then --this block of code causes all these to change only on the count2=0 rising edge
		-- basically, all this code is running as if it had a clock at 125MHz/32 = 3.9MHz
		-- it all occurs exactly when count2 = 0, so at the very start of the read or write cycle, which lasts 32 count2 cycles
			
		
			count <= nextcount;  -- count is incrementing at 3.9MHz, or once every 32 count2 increments
			blinker <= nextBlinker;
			ba <= nextBa;
			addrRequest <= nextAddrRequest;

			casRequest <= nextCasRequest;
			rasRequest <= nextRasRequest;
			weRequest <= nextWeRequest;
			writeRequest <= nextWriteRequest;		
			saveRequest <= nextSaveRequest;
			saveRequest2 <= nextSaveRequest2;
			saveRequest3 <= nextSaveRequest3;
			saveRequest4 <= nextSaveRequest4;
			reset <= nextReset;
			cke <= nextCke;
			dqsTristate <= nextDqsTristate;
			odt <= nextODT;
			
	
			requestedDataToWrite  <= nextRequestedDataToWrite;
	
			din <= nextdin;
			end if;
   end process;

------------------------------------------COMBINATORIAL:
	dqm0PORT  <= '0';
	dqm1PORT  <= '0';
	odtPORT <= odt;
	baPort <= ba;
	resetPort <= reset;
	ckePort <= cke;
	blinkerPORT <= blinker;
	
	nextBlinker <= not blinker when count = 0 else blinker;


	process (count, requestedDataToWrite, reset, cke, din)

		begin
			nextCount <= count + 1;

			nextDqsTristate <= '1';

			nextWriteRequest <= '0';  -- unless overridden below
			nextSaveRequest <= '0';
			nextSaveRequest2 <= '0';
			nextSaveRequest3 <= '0';
			nextSaveRequest4 <= '0';
			
			nextRequestedDataToWrite  <= requestedDataToWrite;

			nextODT <= '1';  -- On Die Termination is normally on
			nextBa <= (others => '0');
			nextAddrRequest <= (others => '0');
			nextRasRequest <= '1';
			nextCasRequest <= '1';
			nextWeRequest <= '1';
			
			nextData <= (others => 'Z');
	
			nextReset <= reset;
			nextCke <= cke;
			
			nextdin <= din;
			
			
		 	rst <= '0';
			if count = 0 then
				nextReset <= '0';
				nextCke <= '0';
				rst <= '1';
			end if;
			
			
			
			
			
			
			
			if count = 1 then
	nextCount <= count + 20226;
			end if;
			
			
			
			
			
			
			
			
			
			
			
			if count = 5000 then --5000
				nextReset <= '1';
			end if;
			if count = 20000 then -- 20000
				nextCke <= '1';
			end if;
			
			if count = 20100 then -- 20100 --do nothing (sets nextAddr to get rid of an annoying warking)
				nextBa <= "111";
				nextAddrRequest <= "111111111111111";
			end if;
	
			if count = 20200 then--20200 --MRS MR2
				nextBa <= "010";
				nextAddrRequest <= "000000000001000";  --CWL = 6
--				nextAddrRequest <= "000000000000000";  --CWL = 5
				nextRasRequest <= '0';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
	
			if count = 20201 then--20201 --MRS MR3
				nextBa <= "011";
				nextAddrRequest <= "000000000000100"; -- MPR mode, outputs special pattern on reads
				nextRasRequest <= '0';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
		
			if count = 20202 then--20202 --MRS MR1  
				nextBa <= "001";
				nextAddrRequest <= "000000000000101";  -- DLL disable     RZQ/4 (60O NOM)
--				nextAddrRequest <= "000000000000100";  -- DLL enable     RZQ/4 (60O NOM)
				nextRasRequest <= '0';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
		
			if count = 20203 then--20203 --MRS MR0
				nextBa <= "000";	
				nextAddrRequest <= (9 => '1', 8 => '0', 5 => '1', others => '0'); --CAS latency = 6, Don'treset DLL  , WriteRecovery = 5, FixedBurstLength = 8
--				nextAddrRequest <= (9 => '1', 8 => '1', 4 => '1', others => '0'); --CAS latency = 5, reset DLL  , WriteRecovery = 5
				nextRasRequest <= '0';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
	
			if count = 20204 then--20204 --ZQCL
				nextBa <= "000";				
				nextAddrRequest <= (10 => '1', others => '0'); 
				nextRasRequest <= '1';
				nextCasRequest <= '1';
				nextWeRequest <= '0';
			end if;
				
			if count = 20224 then--20224 --MRS MR3
				nextBa <= "011";
				nextAddrRequest <= "000000000000000"; 
				nextRasRequest <= '0';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
		
			if count = 20226 then--20226 --ACTIVATE
				nextBa <= "000";
				nextAddrRequest <= "000000000001000"; --Row Address 8  
				nextRasRequest <= '0';
				nextCasRequest <= '1';
				nextWeRequest <= '1';
			end if;


		
			
			if count = 20232 then
				nextdin(3 downto 0) <= "1110";
				nextdin(19 downto 16) <= "1101";
				nextdin(35 downto 32) <= "1011";
				nextdin(51 downto 48) <= "0111";
				nextdin(67 downto 64) <= "0011";
				nextdin(83 downto 80) <= "1001";
				nextdin(99 downto 96) <= "1100";
				nextdin(115 downto 112) <= "1000";
				sharpenFIFOpushEnable(0) <= '0';  -- note: will need a rising edge in a later count
		 	end if;
		
			if count = 20234 then
				sharpenFIFOpushEnable(0) <= '1';  -- here is the rising edge
		 	end if;


			if count = 20236 then
				nextdin(3 downto 0) <= "0111";
				nextdin(19 downto 16) <= "0110";
				nextdin(35 downto 32) <= "0101";
				nextdin(51 downto 48) <= "0100";
				nextdin(67 downto 64) <= "0011";
				nextdin(83 downto 80) <= "0010";
				nextdin(99 downto 96) <= "0001";
				nextdin(115 downto 112) <= "0000";
				sharpenFIFOpushEnable(0) <= '0';  -- note: will need a rising edge in a later count
		 	end if;


			if count = 20238 then
				sharpenFIFOpushEnable(0) <= '1';   -- here is the rising edge
		 	end if;

			if count = 20240 then
				nextdin(3 downto 0) <= "1000";
				nextdin(19 downto 16) <= "0100";
				nextdin(35 downto 32) <= "0010";
				nextdin(51 downto 48) <= "0001";
				nextdin(67 downto 64) <= "0011";
				nextdin(83 downto 80) <= "0110";
				nextdin(99 downto 96) <= "1100";
				nextdin(115 downto 112) <= "1110";
				sharpenFIFOpushEnable(0) <= '0';  -- note: will need a rising edge in a later count
		 	end if;
		
			if count = 20242 then
				sharpenFIFOpushEnable(0) <= '1';  -- here is the rising edge
		 	end if;

			if count = 20244 then--20228 --WRITE
				nextData <= "1010101010100110"; -- the last four digits of this will show up on the LEDs
				nextRequestedDataToWrite(1) <= "0000000000000001"; 
				nextRequestedDataToWrite(2) <= "1010101010100010";
				nextRequestedDataToWrite(3) <= "1010101010100100";
				nextRequestedDataToWrite(4) <= "1010101010101000";
				nextRequestedDataToWrite(5) <= "1010101010101100";
				nextRequestedDataToWrite(6) <= "1010101010100110";
				nextRequestedDataToWrite(7) <= "1010101010100011";
				nextRequestedDataToWrite(8) <= "1010101010100111";
				nextRequestedDataToWrite(9) <= "1010101010101110";
				nextRequestedDataToWrite(10) <= "0000000000001111";
 				nextRequestedDataToWrite(11) <= "0000000000001110";
				nextRequestedDataToWrite(12) <= "1010101010101100";
				nextRequestedDataToWrite(13) <= "1010101010101000";
				nextRequestedDataToWrite(14) <= "1010101010101100";
				nextRequestedDataToWrite(15) <= "1010101010101110";
				nextRequestedDataToWrite(16) <= "1010101010101111";
				nextRequestedDataToWrite(17) <= "1010101010100111";
				nextRequestedDataToWrite(18) <= "1010101010100011";
				nextRequestedDataToWrite(19) <= "1010101010100001";
				nextRequestedDataToWrite(20) <= "0000000000000011";





				nextWriteRequest <= '1';
				nextDqsTristate <= '0';
			
				nextBa <= "000";
				nextAddrRequest <= "000000000010000";  -- A10 must be LOW to turn off AutoPrecharge
				nextRasRequest <= '1';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
			
			if count = 20246 then--20230 --WRITE
				nextData <= "1111111111111001";
				nextDqsTristate <= '0';
			
				nextBa <= "000";
				nextAddrRequest <= "000000111110000"; -- A10 must be LOW to turn off AutoPrecharge
				nextRasRequest <= '1';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
	

			if count = 20248 then--20232   --READ
				nextODT <= '0';  -- turn On Die Termination off for read

				nextSaveRequest <= '1';	
				
				nextBa <= "000";
				nextAddrRequest <= "000000000011000";  --"000000000010000";  -- A10 must be LOW to turn off AutoPrecharge
				nextRasRequest <= '1';
				nextCasRequest <= '0';
				nextWeRequest <= '1';
			end if;
			
   end process;
		
		
		
			

process (clk250MHz)
		begin
------------------------------------------SEQUENTIAL :			
		if rising_edge(clk250MHz) then  
			slowClockVector(6 downto 0) <= slowClockVector(7 downto 1);
			slowClockVector(7) <= slowClockVector(0);
		end if;
   end process;
------------------------------------------COMBINATORIAL:
	slowClockEnable <= slowClockVector(0);





	
process (clk250MHz, slowClockEnable)
		begin
------------------------------------------SEQUENTIAL :			
		if rising_edge(clk250MHz) and slowClockEnable = '1' then  
			currentState <= nextState;
			slowCount <= nextSlowCount;
			burstCount <= nextBurstCount;
			slowWritingPulseTrain  <= nextSlowWritingPulseTrain;
			addr <= nextAddr;
			slowBA <= nextSlowBA;
		end if;
   end process;
------------------------------------------COMBINATORIAL:
	nextSlowWritingPulseTrain (3 downto 1) <= slowWritingPulseTrain(2 downto 0);
	slowWriteAddress(0) <= addr;
	slowWriteAddress(1) <= addr;
	slowWriteAddress(2) <= addr;
	slowWriteAddress(3) <= addr;
	slowWriteAddress(4) <= addr;
	slowWriteAddress(5) <= addr;
	slowWriteAddress(6) <= addr;
	slowWriteAddress(7) <= addr;

process (count, currentState,count2, slowCount, burstCount, nextState, slowWritingPulseTrain)
	begin
	nextState <= currentState;
	clkOutSlow <= "01010101";
	dqsSlow <= "01010101";
	nextSlowCount <= slowCount + 1;
	nextSlowWritingPulseTrain(0) <= '0';
	nextBurstCount <= burstCount;
	nextAddr <= addr;
	nextSlowBA <= slowBA;
	
	if nextState /= currentState then
		nextSlowCount <= "000000000000000000";  -- any time the state changes, reset the count to zero
	end if;

	rasSlow <= "11111111";
	casSlow <= "11111111";
	weSlow <= "11111111";

	slowResetPort <= '1';
	slowCKEPort <= '1';
	slowFIFOrst <= '0';
	
	case currentState is
		when slowReset =>
			slowResetPort <= '0';
			slowCKEPort <= '0';
			slowFIFOrst <= '1';
		
			if slowCount = 2 then
				nextState <= ckeLOW;
			end if;
		when ckeLOW =>
			slowCKEPort <= '0';
				
			if slowCount = 2 then
				nextState <= writeMRS;
			end if;
		when startWriting =>  -- the state startWriting means there is additional data waiting in the FIFO
			if burstCount = 3 then  -- this limits the max number of consecutive bursts
				nextState <= stopWriting;
				nextBurstCount <= "00000000";
			else
				nextSlowWritingPulseTrain(0) <= '1';
				rasSlow <= "11111111";
				casSlow <= "11110011";
				weSlow <= "11110011";
				nextBurstCount <= burstCount + 1;
				nextAddr <= 			std_logic_vector(to_unsigned((to_integer(unsigned(addr)) + 8),16)); -- increment column address by 8
	
			end if;
		when stopWriting => -- the state stopWriting means there is no additional data waiting in the FIFO, or we've sent enough pulses and need to refresh or activate a new row
			if slowWritingPulseTrain = "0000" then --no more tasks to do for previous writes
				nextState <= idle;
			end if;

		when writeMRS =>
			if slowCount = 1 or slowCount = 17 or slowCount = 33 or slowCount = 49 or slowCount = 265 then -- will occur at slowCount = 4, 20, 36, 52 etc.
				rasSlow <= "11110011";
				casSlow <= "11110011";
				weSlow <= "11110011";
			end if;
			if slowCount = 0 then
				nextSlowBA <= "010"; --MRS MR2
				nextAddr <= "0000000000001000";  --CWL = 6
			end if;
			if slowCount = 16 then
				nextSlowBA <= "011";--MRS MR3
				nextAddr <= "0000000000000100"; -- MPR mode, outputs special pattern on reads
			end if;
			if slowCount = 32 then
				nextSlowBA <= "001"; --MRS MR1  
				nextAddr <= "0000000000000101";  -- DLL disable     RZQ/4 (60O NOM)
--				nextAddrRequest <= "000000000000100";  -- DLL enable     RZQ/4 (60O NOM)
			end if;
			if slowCount = 48 then
				nextSlowBa <= "000";		--MRS MR0
				nextAddr <= (9 => '1', 8 => '0', 5 => '1', others => '0'); --CAS latency = 6, Don'treset DLL  , WriteRecovery = 5, FixedBurstLength = 8
--				nextAddrRequest <= (9 => '1', 8 => '1', 4 => '1', others => '0'); --CAS latency = 5, reset DLL  , WriteRecovery = 5
			end if;
			if slowCount = 64 then
				--ZQCL
				nextSlowBa <= "000";				
				nextAddr <= (10 => '1', others => '0'); 
			end if;
			if   slowCount = 65 then 
				rasSlow <= "11111111";
				casSlow <= "11111111";
				weSlow <= "11110011";
			end if;
			if slowCount = 264 then
				nextSlowBa <= "011"; --MRS MR3
				nextAddr <= "0000000000000000"; 
			end if;
			if slowCount = 280 then
				nextState <= activate;
			end if;
		when activate =>
				nextSlowBa <= "000";
				nextAddr <= "0000000000001000"; --Row Address 8  
			if   slowCount = 1 then 
				rasSlow <= "11110011";
				casSlow <= "11111111";
				weSlow <= "11111111";
			end if;
			if   slowCount = 2 then  -- this count can be reduced for slow clock frequencies
				nextState <= startWriting;
			end if;			
	
		when others => 
	
	end case;	


	slowWriteData(0)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(1)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(2)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(3)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(4)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(5)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(6)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(7)<= "ZZZZZZZZZZZZZZZZ"; 

	if slowWritingPulseTrain(1) = '1' then
		slowWriteData(0)<= "1111111111111111"; 
		slowWriteData(1)<= "0000000000000000"; 
		slowWriteData(2)<= "1111111111111111"; 
		slowWriteData(3)<= "0000000000000000"; 
		slowWriteData(4)<= "1111111111111111"; 
		slowWriteData(5)<= "0000000000000000"; 
		slowWriteData(6)<= "1111111111111111"; 
		slowWriteData(7)<= "0000000000000000"; 
	
	end if;
		
		
	
	
		
end process;


end Behavioral;
--	signal csFast, rasFast, casFast, weFast : std_logic;
--	signal csSlow, rasSlow, casSlow, weSlow : std_logic_vector(7 downto 0);

--	signal clkOutFast, dqsFast : std_logic;
--	signal clkOutSlow, dqsSlow : std_logic_vector(7 downto 0);

--	signal slowWritingPulseTrain (3 downto 0) := "0000";
--	signal nextSlowWritingPulseTrain (3 downto 0);

--	signal burstCount : unsigned (7 downto 0) := "00000000";
--	signal nextBurstCount : unsigned (17 downto 0) ;

--	signal slowBA : std_logic_vector(3 downto 0) := "0000";
-- signal nextSlowBA : std_logic_vector(3 downto 0)  ;
	
