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
			
			LEDBUS0 : out STD_LOGIC;
			LEDBUS1 : out STD_LOGIC;
			LEDBUS2 : out STD_LOGIC;
			LEDBUS3 : out STD_LOGIC;
			LEDBUS4 : out STD_LOGIC;
			LEDBUS5 : out STD_LOGIC;
			LEDBUS6 : out STD_LOGIC;
			LEDBUS7 : out STD_LOGIC;
			LEDBUS8 : out STD_LOGIC;

			
			PIN0 : in  STD_LOGIC;
			PIN1 : out  STD_LOGIC;
			PIN26 : in  STD_LOGIC;
			PIN27 : in  STD_LOGIC;
			
			
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


	signal verySlowClockEnable : std_logic_vector(31 downto 0) := "00000000000000000000000000000001";

    signal count : unsigned (17 downto 0) := "000000000000000000";
	constant fiveThousand : unsigned (17 downto 0) :=   "000001000000000000"; 
	constant twentyThousand : unsigned (17 downto 0) :=  "000100000000000000"; 
 	constant hundred : unsigned (17 downto 0) :=  "000000000010000000"; 
 	constant thousand : unsigned (17 downto 0) := "000000000000000000";--  "000000010000000000"; 
--	constant fiveThousand : unsigned (17 downto 0) :=    "000000000000000100";
--	constant twentyThousand : unsigned (17 downto 0) :=   "000000000000010000";
-- 	constant hundred : unsigned (17 downto 0) :=   "000000000000000010";
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


	type stateTypes IS (slowReset, ckeLOW, startWriting,   stopWriting, idle, activate, writeMRS, reading, stopReading, stop);
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
	signal addr : std_logic_vector(15 downto 0) := "0000000000010000";
	signal nextAddr: std_logic_vector(15 downto 0);
	
	signal slowBA : std_logic_vector(2 downto 0) := "000";
	signal nextSlowBA : std_logic_vector(2 downto 0)  ;
	signal slowResetPort, slowCKEPort, slowFIFOrst : std_logic;
	
	signal useNewCode : std_logic := '0';
	signal nextUseNewCode : std_logic;
	signal requestNewCode : std_logic := '0';
	signal lastRequestNewCode : std_logic := '0';
	signal nextRequestNewCode : std_logic ;
	signal lastRequestOldCode : std_logic := '0';
	signal requestOldCode : std_logic := '0';
	signal nextRequestOldCode : std_logic ;
	signal slowNextClockEnableRead : std_logic;
	signal slowNextClockEnableReadDelayed1 : std_logic;
	signal slowNextClockEnableReadDelayed2 : std_logic;
	signal slowNextClockEnableReadDelayed3 : std_logic;
	signal slowNextClockEnableReadDelayed4 : std_logic;
	

	signal slowDQStristate : std_logic;
	
	signal slowFIFOpullToggle :  std_logic   := '0';
	signal nextSlowFIFOpullToggle :  std_logic  ;
	signal slowFIFOpullPulse :  std_logic_vector(9 downto 0) := "0000000000";

	signal requestReset :  std_logic   := '0';
	signal nextRequestReset : std_logic;
	
	
	signal LEDBUSvec : std_logic_vector(8 downto 0)  ;
	
	signal SPIdataIn : std_logic_vector (15 downto 0) ;
	signal SPIdataInSlowed : std_logic_vector (15 downto 0) ;
	signal SPIdataOut : std_logic_vector (15 downto 0) := "1000000000000010";
	signal nextSPIdataOut : std_logic_vector (15 downto 0);

	signal dataArrivedToggle : std_logic;
	signal dataArrivedToggleSlowed : std_logic;
	
	signal lastDataArrivedToggle : std_logic := '0';
	
	signal requestReadToggle : std_logic := '0';
	signal lastRequestReadToggle : std_logic := '0';
	signal nextRequestReadToggle : std_logic;
	
	signal requestWriteToggle : std_logic := '0';
	signal lastRequestWriteToggle : std_logic := '0';
	signal nextRequestWriteToggle : std_logic;
	
	signal requestedAddress : std_logic_vector (15 downto 0) := "0000000000010000" ;
	signal nextRequestedAddress : std_logic_vector (15 downto 0) ;
	
	signal FIFOpushEnable : std_logic := '0';
	signal nextFIFOpushEnable : std_logic;
	signal FIFOpushToggle : std_logic := '0';
	signal lastFIFOpushToggle : std_logic := '0';
	signal nextFIFOpushToggle : std_logic;

   signal readBurstCount : unsigned (7 downto 0) := "00000000";
	signal nextReadBurstCount : unsigned (7 downto 0) ;

	
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
    rst => slowFIFOrst,--rst,
     wr_clk => clk250MHz,
    rd_clk => clk250MHz,
    din => din,
    wr_en => sharpenFIFOpushEnable(5) ,--FIFOpushEnable,-- 
    rd_en => slowFIFOpullPulse(9) ,
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

--			sharpenFIFOpullEnable(4) <= sharpenFIFOpullEnable(3) and (not sharpenFIFOpullEnable(4));  -- only on rising edge of sharpenFIFOpushEnable(2) 
--			sharpenFIFOpullEnable(5) <= sharpenFIFOpullEnable(4);

			lastFIFOpushToggle <= FIFOpushToggle;
			FIFOpushEnable <= nextFIFOpushEnable;
			
		end if;
	end process;
	
	
		------------------------------------------COMBINATORIAL:
		nextFIFOpushEnable <= '1' when FIFOpushToggle /= lastFIFOpushToggle else '0';
	

	process (clk250MHz, clk125MHz)  -- FIFO enable sharpener; it will turn any rising edge into a two cycle-pulse, then further sharpen to a one-cycle pulse at 250 MHz.
		begin
	------------------------------------------SEQUENTIAL :	
		if rising_edge(clk250MHz) and clk125MHz = '1' then
			sharpenFIFOpushEnable(1) <= sharpenFIFOpushEnable(0);
			sharpenFIFOpushEnable(2) <= sharpenFIFOpushEnable(1);
			sharpenFIFOpushEnable(3) <= sharpenFIFOpushEnable(1) and (not sharpenFIFOpushEnable(2)); -- only on rising edge of sharpenFIFOpushEnable(1) 
 
--			sharpenFIFOpullEnable(2) <= sharpenFIFOpullEnable(1);
--			sharpenFIFOpullEnable(3) <= sharpenFIFOpullEnable(1) and (not sharpenFIFOpullEnable(2)); -- only on rising edge of sharpenFIFOpushEnable(1) 
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
ODATAIN => fastWriteData(0),--dataAssertedToOutput(0), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => slowdqsTristate -- 1-bit input: 3-state input signal
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
ODATAIN => fastWriteData(1),-- dataAssertedToOutput(1), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => slowdqsTristate -- 1-bit input: 3-state input signal
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
ODATAIN => fastWriteData(2),-- dataAssertedToOutput(2), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => slowdqsTristate -- 1-bit input: 3-state input signal
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
ODATAIN => fastWriteData(3),-- dataAssertedToOutput(3), -- 1-bit input: Output data input from output register or OSERDES2.
RST => '0', -- 1-bit input: Reset to zero or 1/2 of total delay period
T => slowdqsTristate -- 1-bit input: 3-state input signal
);





IOBUFDS_dqs0 : IOBUFDS
generic map (
IOSTANDARD => "DIFF_SSTL15_II")
port map (
O => dqs0Incoming, -- received dqs from DRAM
IO => dqs0_pPORT, -- Diff_p inout (connect directly to top-level port)
IOB => dqs0_nPORT, -- Diff_n inout (connect directly to top-level port)
I => dqsFast,--clk125MHz, -- outgoing dqs is just always the 125MHz clock
T => slowdqsTristate -- 3-state enable input, high=input, low=output
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
I => dqsFast,--clk125MHz, -- Buffer input
T => slowdqsTristate -- 3-state enable input, high=input, low=output
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
I => clkOutFast--clk125MHz -- Buffer input
);
-- End of OBUFDS_inst instantiation

Inst_SPIinterface: SPIinterface PORT MAP(
		clk => clk250MHz ,
		dataout => SPIdataOut,
		datain => SPIdataIn,
		dataarrivedtoggle => dataArrivedToggle ,
		csPin => PIN0,
		MISOpin => PIN1,
		MOSIpin => PIN26,
		sckPin => PIN27 
	);











	process (clk250MHz)
		begin
------------------------------------------SEQUENTIAL :	
		if rising_edge(clk250MHz) then
			clk125MHz <=  nextClk125MHz  ;  --clk125MHz changes on rising edge of 250MHz clock; this is sent out as external clock *and* as dqs
			inData (15 downTo 4) <= dataPort (15 downTo 4);  -- data uses the 250 MHz clock
			inData (3 downto 0) <= delayedDataPort (3 downto 0);  -- data uses the 250 MHz clock


			capturedData(11 downto 1) <= nextCapturedData(11 downto 1);
		
			slowNextClockEnableReadDelayed1 <= slowNextClockEnableRead;
			slowNextClockEnableReadDelayed2 <= slowNextClockEnableReadDelayed1;
			slowNextClockEnableReadDelayed3 <= slowNextClockEnableReadDelayed2;
			slowNextClockEnableReadDelayed4 <= slowNextClockEnableReadDelayed3;
		end if;
	end process;

		------------------------------------------COMBINATORIAL:
	process (slownextclockenablereaddelayed4,slowdqstristate, clk125MHz,cas,casRequest,ras,rasRequest,we,weRequest,saveRequest,inData,  clockEnableRead, capturedData, dqsTristate, delayedDataForOutput, dataAssertedToOutput, clockEnableWrite, clockEnableRefillWriteData, refillTheShiftRegister)
		begin

		nextClk125MHz <= not clk125MHz;
		
		nextCapturedData(11 downto 1) <= capturedData(11 downto 1); --unless overridden below, hold and remember the captured values
	
		if slowNextClockEnableReadDelayed4 = '1'  then
			nextCapturedData(1) <= inData;
			nextCapturedData(11 downto 2) <= capturedData(10 downto 1);
		end if;
		
		if slowdqsTristate = '1' then
			dataPort (15 downTo 0) <= (15 downTo 0 => 'Z');	
		else
			dataPort(3 downto 0) <= delayedDataForOutput(3 downto 0);
			dataPort(15 downto 4) <= dataAssertedToOutput (15 downto 4);
		end if;
		
	end process;
		
		
	process (clk250MHz, verySlowClockEnable(0))
		begin
------------------------------------------SEQUENTIAL :	
		if rising_edge(clk250MHz) and verySlowClockEnable(0) = '1' then 
		
--			count2 <= nextCount2;    

			switchRegister <= nextSwitchRegister;
			switchCount <= nextSwitchCount;
			lastSwitchRegister <= switchRegister;


			
			
			requestReadToggle <= nextRequestReadToggle ;
			requestWriteToggle <= nextRequestWriteToggle ;
			requestedAddress <= nextRequestedAddress  ;
			
			FIFOpushToggle <= nextFIFOpushToggle;

--			din <= nextdin;
			SPIdataInSlowed <= SPIdataIn ;
			dataArrivedToggleSlowed <= dataArrivedToggle ;
			lastDataArrivedToggle <= dataArrivedToggleSlowed;

		end if;
   end process;
	
------------------------------------------COMBINATORIAL:
	casPORT <=  casFast;--cas;
	rasPORT <= rasFast;-- ras;
	wePORT <= weFast;--we;
	
	LEDBUS0 <= LEDBUSvec(0);
	LEDBUS1 <= LEDBUSvec(1);
	LEDBUS2 <= LEDBUSvec(2);
	LEDBUS3 <= LEDBUSvec(3);
	LEDBUS4 <= LEDBUSvec(4);
	LEDBUS5 <= LEDBUSvec(5);
	LEDBUS6 <= LEDBUSvec(6);
	LEDBUS7 <= LEDBUSvec(7);
	LEDBUS8 <= LEDBUSvec(8);


	process (fastwriteaddress, empty, nextwritepulsetrain, doutwaiting, dout, saveRequest, clockEnableCommand, casRequest, rasRequest, weRequest, capturedData, writeRefill, addrOut, switchRegister, lastSwitchRegister, writeRequest, writePulseTrain,  addrRequest, switch2port, switch3Port, switchCount)
	
		begin

		addrPort <= fastWriteAddress(14 downto 0);-- addrOut;
	
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

--		nextCount2 <= count2 + 1;  -- count2 increments at 125 MHz, not 250 MHz
	
		if switchCount = 0 then
			LED0 <=   capturedData(1)(0);
			LED1 <=    capturedData(1)(1);
			LED2 <=    capturedData(1)(2);
			LED3 <=    capturedData(1)(3);
			LEDBUSvec <= capturedData(1)(8 downto 0);
	   end if;
		if switchCount = 1 then
			LED0 <=   capturedData(2)(0);
			LED1 <=    capturedData(2)(1);
			LED2 <=    capturedData(2)(2);
			LED3 <=    capturedData(2)(3);
			LEDBUSvec <= capturedData(2)(8 downto 0);
		end if;
		if switchCount = 2 then
			LED0 <=   capturedData(3)(0);
			LED1 <=    capturedData(3)(1);
			LED2 <=    capturedData(3)(2);
			LED3 <=    capturedData(3)(3);
			LEDBUSvec <= capturedData(3)(8 downto 0);
	end if;
		if switchCount = 3 then
			LED0 <=   capturedData(4)(0);
			LED1 <=    capturedData(4)(1);
			LED2 <=    capturedData(4)(2);
			LED3 <=    capturedData(4)(3);
			LEDBUSvec <= capturedData(4)(8 downto 0);
		end if;
		if switchCount = 4 then
			LED0 <=   capturedData(5)(0);
			LED1 <=    capturedData(5)(1);
			LED2 <=    capturedData(5)(2);
			LED3 <=    capturedData(5)(3);
			LEDBUSvec <= capturedData(5)(8 downto 0);
		end if;
		if switchCount = 5 then
			LED0 <=   capturedData(6)(0);
			LED1 <=    capturedData(6)(1);
			LED2 <=    capturedData(6)(2);
			LED3 <=    capturedData(6)(3);
			LEDBUSvec <= capturedData(6)(8 downto 0);
		end if;
		if switchCount = 6 then
			LED0 <=   capturedData(7)(0);
			LED1 <=    capturedData(7)(1);
			LED2 <=    capturedData(7)(2);
			LED3 <=    capturedData(7)(3);
			LEDBUSvec <= capturedData(7)(8 downto 0);
		end if;
		if switchCount = 7 then
			LED0 <=   capturedData(8)(0);
			LED1 <=    capturedData(8)(1);
			LED2 <=    capturedData(8)(2);
			LED3 <=    capturedData(8)(3);
			LEDBUSvec <= capturedData(8)(8 downto 0);
		end if;

		if switchCount = 8 then
				LED0 <=   capturedData(9)(0);
				LED1 <=    capturedData(9)(1);
				LED2 <=    capturedData(9)(2);
				LED3 <=    capturedData(9)(3);
			LEDBUSvec <= capturedData(9)(8 downto 0);
		end if;

	   if switchCount = 9 then
				LED0 <=   capturedData(10)(0);
				LED1 <=    capturedData(10)(1);
				LED2 <=    capturedData(10)(2);
				LED3 <=    capturedData(10)(3);
			LEDBUSvec <= capturedData(10)(8 downto 0);
		end if;

		if switchCount = 10 then
				LED0 <=   capturedData(11)(0);
				LED1 <=    capturedData(11)(1);
				LED2 <=    capturedData(11)(2);
				LED3 <=    capturedData(11)(3);
			LEDBUSvec <= capturedData(11)(8 downto 0);
		end if;



		LEDBUSvec(8 downto 0) <= SPIdataIn(8 downto 0);
		LEDBUSvec(3 downto 0) <= std_logic_vector(switchCount);
		LEDBUSvec <= "000000000";
		LEDBUSvec(7 downto 0) <= std_logic_vector(readBurstCount);
		SPIdataOut(15 downto 0) <= "0000000000000000";
		SPIdataOut(11 downto 8) <= std_logic_vector(switchCount);
		SPIdataOut(7 downto 0) <= capturedData(to_integer(switchCount + 1))(7 downto 0);


		nextRequestReadToggle <= requestReadToggle ;
		nextRequestWriteToggle <= requestWriteToggle ;
		nextRequestedAddress <= requestedAddress  ;
		
		nextFIFOpushToggle <= FIFOpushToggle;
--		nextdin <= din;
		
		if lastDataArrivedToggle /= dataArrivedToggleSlowed then  -- an SPI message has arrived
			if SPIdataInSlowed(15 downto 8) = "00000011" then -- command 3 means advance the switchCount
				nextSwitchCount <= switchCount + 1;
			end if;
			if SPIdataInSlowed(15 downto 8) = "00000101" then -- command 5 means request a read operation
				nextRequestReadToggle <= not requestReadToggle ;
			end if;
			if SPIdataInSlowed(15 downto 8) = "00000001" then -- command 1 means request a write operation
				nextRequestWriteToggle <= not requestWriteToggle ;
			end if;
			if SPIdataInSlowed(15 downto 8) = "00000110" then -- command 6 means set address
				nextRequestedAddress(7 downto 0) <= SPIdataInSlowed(7 downto 0);
			end if; 

			if SPIdataInSlowed(15 downto 8) = "00000111" then -- command 7 means push into FIFO
				nextFIFOpushToggle <= not FIFOpushToggle;
			end if;
			if SPIdataInSlowed(15 downto 8) = "000010000" then -- command 16 through 31 means set nextdin values
--				nextdin(7 downto 0) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "000010010" then -- command 16 through 31 means set nextdin values
--				nextdin(23 downto 16) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "000010100" then -- command 16 through 31 means set nextdin values
--				nextdin(39 downto 32) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "000010110" then -- command 16 through 31 means set nextdin values
--				nextdin(55 downto 48) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "000011000" then -- command 16 through 31 means set nextdin values
--				nextdin(71 downto 64) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "000011010" then -- command 16 through 31 means set nextdin values
--				nextdin(87 downto 80) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "000011100" then -- command 16 through 31 means set nextdin values
--				nextdin(103 downto 96) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "000011110" then -- command 16 through 31 means set nextdin values
--				nextdin(119 downto 112) <= SPIdataInSlowed(7 downto 0);
			end if;

		

		end if;
			
   end process;
	
	
	
	
	
------------------------------------------SEQUENTIAL :	
	process (clk250MHz,  ClockEnableBeginning,verySlowClockEnable(0))
		begin
		if rising_edge(clk250MHz) and verySlowClockEnable(0) = '1' then 

			count <= nextcount;  
			blinker <= nextBlinker;

			odt <= nextODT;

			din <= nextdin;
			
			requestReset <= nextRequestReset;

			end if;
   end process;

------------------------------------------COMBINATORIAL:
	dqm0PORT  <= '0';
	dqm1PORT  <= '0';
	odtPORT <= odt;
	baPort <= slowBA;-- ba;
	 
	resetPort <= slowResetPort;--reset;
	ckePort <= slowCKEPort;-- cke;
	blinkerPORT <= empty;--blinker;
	
	nextBlinker <= not blinker when count = 0 else blinker;

	process (count, requestedDataToWrite, reset, cke, din)

		begin
			nextCount <= count + 1;

			nextODT <= '1';  -- On Die Termination is normally on
			
			nextdin <= din;
			
			nextRequestReset <= '0';

			if count = 0 then
	--			nextRequestReset <= '1';
			end if;
			
			if count = 4 then-- twentyThousand + hundred  + hundred + 27 then
				nextdin(3 downto 0) <= "1110"; --14
				nextdin(19 downto 16) <= "1101"; --13
				nextdin(35 downto 32) <= "1011"; --11
				nextdin(51 downto 48) <= "0111"; --7
				nextdin(67 downto 64) <= "0011"; --3
				nextdin(83 downto 80) <= "1001"; --9
				nextdin(99 downto 96) <= "1100"; --12
				nextdin(115 downto 112) <= "1000"; --8
				sharpenFIFOpushEnable(0) <= '0';  -- note: will need a rising edge in a later count
		 	end if;
		
			if count = 5 then-- twentyThousand + hundred  + hundred + 28 then
				sharpenFIFOpushEnable(0) <= '1';  -- here is the rising edge
		 	end if;

			if count = 6 then --twentyThousand + hundred  + hundred + 29 then
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

			if count = 7 then -- twentyThousand + hundred  + hundred + 30 then
				sharpenFIFOpushEnable(0) <= '1';   -- here is the rising edge
		 	end if;

			if count = 8 then-- twentyThousand + hundred  + hundred + 31 then
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
		
			if count = 9 then--  twentyThousand + hundred  + hundred + 32 then
				sharpenFIFOpushEnable(0) <= '1';  -- here is the rising edge
		 	end if;
			
			if count = 10 then
				nextCount <= nextCount + 0;
			end if;
		
			
   end process;
		
		
		
			

process (clk250MHz)
		begin
------------------------------------------SEQUENTIAL :			
		if rising_edge(clk250MHz) then  
			slowClockVector(6 downto 0) <= slowClockVector(7 downto 1);
			slowClockVector(7) <= slowClockVector(0);
			verySlowClockEnable(30 downto 0) <= verySlowClockEnable(31 downto 1);
			verySlowClockEnable(31) <= verySlowClockEnable(0);
			
			
			
			slowFIFOpullPulse( 1) <= slowFIFOpullPulse( 0);  -- shift delay for FIFO pull enable pulse
			slowFIFOpullPulse(9 downto 3) <= slowFIFOpullPulse(8 downto 2);  -- shift delay for FIFO pull enable pulse
		 
		end if;
   end process;
------------------------------------------COMBINATORIAL:
	slowClockEnable <= slowClockVector(0);
	
	slowFIFOpullPulse(0) <= slowFIFOpullToggle; -- remember the last state of toggle
	slowFIFOpullPulse(2) <= '0' when slowFIFOpullPulse(0) = slowFIFOpullPulse(1) else '1';  -- bit 2 pulses when bit 0 toggles





	
process (clk250MHz, slowClockEnable)
		begin
------------------------------------------SEQUENTIAL :			
		if rising_edge(clk250MHz) and slowClockEnable = '1' then  -- the slowClockEnable is one-eighth speed, so the below logic 
																					--can do very complicated count math, FIFO operations, etc, without hitting timing issues
			currentState <= nextState;
			slowCount <= nextSlowCount;
			burstCount <= nextBurstCount;
			slowWritingPulseTrain  <= nextSlowWritingPulseTrain;
			addr <= nextAddr;
			slowBA <= nextSlowBA;
			slowFIFOpullToggle <= nextSlowFIFOpullToggle;
			
			lastRequestReadToggle <= requestReadToggle; -- keep track of last toggle value so we can detect a change within this process
			lastRequestWriteToggle <= requestWriteToggle; -- keep track of last toggle value so we can detect a change within this process


			readBurstCount <= nextReadBurstCount;

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

process (slowfifopulltoggle, addr, slowBA, count, currentState, slowCount, burstCount, nextState, slowWritingPulseTrain)
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
	
	slowNextClockEnableRead <= '0';
	
	slowDQStristate <= '1';
	
	nextSlowFIFOpullToggle <= slowFIFOpullToggle;
		
	nextReadBurstCount <= readBurstCount ;


	
	case currentState is
		when slowReset =>
			slowResetPort <= '0';
			slowCKEPort <= '0';
			slowFIFOrst <= '1';
		
		
			if slowCount = fiveThousand * 16 - 1 then
				nextState <= ckeLOW;
			end if;
		when ckeLOW =>
			slowCKEPort <= '0';
				
			if slowCount = fiveThousand * 3 * 16 then
				nextState <= writeMRS;
			end if;
		when startWriting =>  -- the state startWriting means there is additional data waiting in the FIFO
			slowDQStristate <= '0';
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
			slowDQStristate <= '0';
			if slowWritingPulseTrain = "0000" then --no more tasks to do for previous writes
				nextState <= idle;
			end if;
		when idle => 
--			if slowCount = 2 * 16 - 7 then
			if requestReadToggle /= lastRequestReadToggle then
				nextState <= reading;
			
				nextSlowBa <= "000";
			--	nextAddr <= "0000000000010000";  --"000000000011000";  -- A10 must be LOW to turn off AutoPrecharge
				nextAddr <= requestedAddress; 
			end if;

			if requestWriteToggle /= lastRequestWriteToggle then
				nextState <= startWriting;
				nextSlowBa <= "000";
				nextAddr <= requestedAddress; 
			end if;



		when reading =>
				rasSlow <= "11111111";
				casSlow <= "11110011";
				weSlow <= "11111111";
				nextState <= stopReading;
				nextReadBurstCount <= readBurstCount + 1 ;
		when stopReading =>
			if slowCount = 2 then
				slowNextClockEnableRead <= '1';
				nextState <= idle;
			end if;
		 

		when writeMRS =>
			if slowCount = 0  then
				nextSlowBA <= "010"; --MRS MR2
				nextAddr <= "0000000000001000";  --CWL = 6
			end if;
			if slowCount = 3 then 
				rasSlow <= "11110011";
				casSlow <= "11110011";
				weSlow <= "11110011";
			end if;
	
			if slowCount =  16   then
				nextSlowBA <= "011";--MRS MR3
				nextAddr <= "0000000000000100"; -- MPR mode, outputs special pattern on reads
			end if;
			if slowCount =  19 then 
				rasSlow <= "11110011";
				casSlow <= "11110011";
				weSlow <= "11110011";
			end if;
	
			if slowCount =  32     then
				nextSlowBA <= "001"; --MRS MR1  
				nextAddr <= "0000000000000101";  -- DLL disable     RZQ/4 (60O NOM)
--				nextAddrRequest <= "000000000000100";  -- DLL enable     RZQ/4 (60O NOM)
			end if;
			if slowCount =  35 then 
				rasSlow <= "11110011";
				casSlow <= "11110011";
				weSlow <= "11110011";
			end if;

			if slowCount =  48   then
				nextSlowBa <= "000";		--MRS MR0
				nextAddr <= (9 => '1', 8 => '0', 5 => '1', others => '0'); --CAS latency = 6, Don'treset DLL  , WriteRecovery = 5, FixedBurstLength = 8
--				nextAddrRequest <= (9 => '1', 8 => '1', 4 => '1', others => '0'); --CAS latency = 5, reset DLL  , WriteRecovery = 5
			end if;
			if slowCount =  51 then 
				rasSlow <= "11110011";
				casSlow <= "11110011";
				weSlow <= "11110011";
			end if;



			if slowCount =  64   then
				--ZQCL
				nextSlowBa <= "000";				
				nextAddr <= (10 => '1', others => '0'); 
			end if;
			if   slowCount = 67 then 
				rasSlow <= "11111111";
				casSlow <= "11111111";
				weSlow <= "11110011";
			end if;
			if slowCount =  384     then
				nextSlowBa <= "011"; --MRS MR3
				nextAddr <= "0000000000000000"; 
			end if;
			if slowCount =  387 then 
				rasSlow <= "11110011";
				casSlow <= "11110011";
				weSlow <= "11110011";
			end if;
		
			
			if slowCount =  389   then
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
			if   slowCount = 8 * 16 then  -- this count can be reduced for slow clock frequencies
				nextState <= idle;--startWriting;
				nextSlowBa <= "000";
				nextAddr <= "0000000000010000";   
	end if;			
	
		when others => 
	
	end case;	
	
	if requestReset = '1'  then
--		nextState <= slowReset;
	end if;


	slowWriteData(0)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(1)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(2)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(3)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(4)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(5)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(6)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(7)<= "ZZZZZZZZZZZZZZZZ"; 

	if slowWritingPulseTrain(1) = '1' or slowWritingPulseTrain(2) = '1' then
		
		slowWriteData(0)<= "1111111111110001"; 
		slowWriteData(1)<= "0000000000000010"; 
		slowWriteData(2)<= "1111111111110100"; 
		slowWriteData(3)<= "0000000000001000"; 
		slowWriteData(4)<= "1111111111111100"; 
		slowWriteData(5)<= "0000000000000110"; 
		slowWriteData(6)<= "1111111111110011"; 
		slowWriteData(7)<= "0000000000000111"; 
	
	
		slowWriteData(0)<= dout(15 downto 0); 
		slowWriteData(1)<= dout(31 downto 16); 
		slowWriteData(2)<= dout(47 downto 32); 
		slowWriteData(3)<= dout(63 downto 48); 
		slowWriteData(4)<= dout(79 downto 64); 
		slowWriteData(5)<= dout(95 downto 80); 
		slowWriteData(6)<= dout(111 downto 96); 
		slowWriteData(7)<= dout(127 downto 112); 
	
	
	end if;
	if slowWritingPulseTrain(0) = '1' then
		
		nextSlowFIFOpullToggle <= not slowFIFOpullToggle ;--toggle this to advance the FIFO (after some delay)
	end if;
		
	
	
		
end process;


end Behavioral;

