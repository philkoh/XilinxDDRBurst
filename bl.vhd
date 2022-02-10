
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

COMPONENT SlowInputByEight
	PORT(
		IOpins : IN std_logic_vector(3 downto 0);
		FastClock : IN std_logic;
		SlowClockEnable : IN std_logic;   
		SlowClock : IN std_logic;
		DataToPins : OUT std_logic_vector(31 downto 0)
	);
END COMPONENT;


COMPONENT SlowInputByEightBus
PORT(
	IOpins : IN std_logic_vector(15 downto 0);
	FastClock : IN std_logic;
	SlowClock : IN std_logic;
	SlowClockEnable : IN std_logic;          
	DataToPins : OUT burstArr
	);
END COMPONENT;



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

COMPONENT DelayWideBus
	PORT(
		IncomingUndelayed : IN std_logic_vector(15 downto 0);
		OutgoingUndelayed : IN std_logic_vector(15 downto 0);
		Tristate : IN std_logic;          
		IncomingDelayed : OUT std_logic_vector(15 downto 0);
		OutgoingDelayed : OUT std_logic_vector(15 downto 0)
		);
END COMPONENT;

	signal clk250MHz : std_logic := '0';

	signal ck_p : std_logic := '0';

	signal blinker  : std_logic := '0';
	signal nextBlinker  : std_logic := '0';
	signal clockEnableBeginning : std_logic := '0';
	signal clockEnableCommand : std_logic := '0';
	signal clockEnableRefillWriteData : std_logic := '0';
	signal clockEnableRead : std_logic := '0';
	signal clockEnableWrite : std_logic := '0';
	signal nextClockEnableBeginning : std_logic := '0';
	signal nextClockEnableCommand : std_logic := '0';
	signal nextClockEnableRefillWriteData : std_logic := '0';
	signal nextClockEnableRead : std_logic := '0';
	signal nextClockEnableWrite : std_logic := '0';
	
	signal writeThisCycle : std_logic := '0';
	signal nextWriteThisCycle : std_logic ;
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------


-- NOTE: SET fiveThousand to 000000000000001000 for simulation, and to 000001000000000000 for actual operation

	constant fiveThousand : unsigned (17 downto 0) :=         "000001000000000000";--     "000000000000001000";--     "000001000000000000"; 
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
 	signal dqs0 : std_logic := '0'; 
	signal dqs1 : std_logic := '0'; 
	signal dqs0Incoming : std_logic := '0';
	signal dqs1Incoming : std_logic := '0';

	signal dqsTristate : std_logic := '1'; 
	signal nextDqsTristate : std_logic := '1'; 
	
	signal odt : std_logic := '1';
	signal nextOdt : std_logic := '1';
	
--	type philArr is array (7 downto 0) of std_logic_vector(15 downto 0);
	 
	signal capturedDataB :   burstArr;
	signal nextCapturedDataB : burstArr;
	
	signal writePulseTrain :    std_logic_vector(15 downto 1) := "000000000000000";
	signal nextWritePulseTrain :    std_logic_vector(15 downto 1) ;

	signal delayedDataForOutput : std_logic_vector(15 downto 0);
	
	signal delayedDataPort : std_logic_vector(15 downto 0);

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
	signal empty : std_logic := '1';
	
	signal IOpinsA : std_logic_vector(3 downto 0);
	signal IOpinsB : std_logic_vector(3 downto 0);
 
	signal dataToPinsA : std_logic_vector(31 downto 0);
	signal dataToPinsB : std_logic_vector(31 downto 0);
	
	signal slowClockVector : std_logic_vector(7 downto 0) := "00100000";
	alias slowClockEnable : std_logic is slowClockVector(0);

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
	signal slowWritingDataTrain0 : std_logic_vector (143 downto 0) ;
	signal slowWritingDataTrain1 : std_logic_vector (143 downto 0) ;
	signal nextSlowWritingPulseTrain : std_logic_vector  (3 downto 0);
	
	signal slowReadDataArr : burstArr;
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
	signal slowNextClockEnableReadDelayed5 : std_logic;
	signal slowClockEnableRead : std_logic := '0';

	signal slowDQStristate : std_logic;
	
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
	
   signal readBurstCount : unsigned (7 downto 0) := "00000000";
	signal nextReadBurstCount : unsigned (7 downto 0) ;

	signal SPIFIFOdin : std_logic_vector(143 downto 0) := "010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101";

	signal nextSPIFIFOdin : std_logic_vector(143 downto 0);

	signal fastReadData : std_logic_vector(3 downto 0);
	signal slowReadData :  std_logic_vector(31 downto 0);
	 
	signal clockShift : std_logic_vector(3 downto 0) :=  "1000";--  "0010";--
	signal clk31M25Hz : std_logic := '0';
	
	signal slowFIFOpull : std_logic;
	signal slowFIFOpush : std_logic := '0';
	signal nextSlowFIFOpush : std_logic;
	
	signal fallingEdgeSlowClockEnable : std_logic := '0';
begin

 

process (clk250MHz)
	begin
	if falling_edge(clk250MHz) then
		fallingEdgeSlowClockEnable <= slowClockEnable;
	end if;
end process;

LEDBUS8 <= fallingEdgeSlowClockEnable;

-- BUFGCE: Global Clock Buffer with Clock Enable
BUFGCE_inst2 : BUFGCE ----------NOTE: this is a clean way to make a slower clock and still have its rising edge well aligned with clk250MHz
port map (
O => clk31M25Hz, -- 1-bit output: Clock buffer output
CE => fallingEdgeSlowClockEnable, -- 1-bit input: Clock buffer select
I => clk250MHz -- 1-bit input: Clock buffer input (S=0)
);

MainControlOutputsA: SlowByEight PORT MAP(
		IOpins => IOpinsA ,
		DataToPins => dataToPinsA,
		FastClock => clk250MHz ,
		SlowClockEnable => slowClockEnable
	);
	
--csFast <= IOpinsA(0);
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

Inst_SlowInputByEight: SlowInputByEight PORT MAP(
	IOpins => delayeddataPort(3 downto 0),
	DataToPins => slowReadData,
	FastClock => clk250MHz,
	SlowClock => clk31M25Hz,
	SlowClockEnable =>   slowClockEnable
);

Inst_SlowInputByEightBus: SlowInputByEightBus PORT MAP(
	IOpins => delayeddataPort(15 downto 0),
	DataToPins => slowReadDataArr,
	FastClock => clk250MHz,
	SlowClock => clk31M25Hz,
	SlowClockEnable =>  slowClockEnable
);


fifoInstance : FIFOphil2
  PORT MAP (
    rst => slowFIFOrst,
     wr_clk => clk31M25Hz,     
    rd_clk => clk31M25Hz,    
    din => SPIFIFOdin,
    wr_en => slowFIFOpush,   
    rd_en => slowFIFOpull,     
    dout => dout,
--    full => full,
  empty => empty
  );

your_instance_name : PhilClock
  port map
   (
    CLK_IN1 => clk,
    CLK_OUT1 => clk250MHz);

Inst_DelayWideBus: DelayWideBus PORT MAP(
		IncomingDelayed => delayedDataPort(15 downto 0),
		OutgoingDelayed => delayedDataForOutput(15 downto 0),
		IncomingUndelayed => dataPort(15 downto 0),
		OutgoingUndelayed => fastWriteData(15 downto 0),
		Tristate => slowdqsTristate
	);

IOBUFDS_dqs0 : IOBUFDS
generic map (
IOSTANDARD => "DIFF_SSTL15_II")
port map (
O => dqs0Incoming, -- received dqs from DRAM
IO => dqs0_pPORT, -- Diff_p inout (connect directly to top-level port)
IOB => dqs0_nPORT, -- Diff_n inout (connect directly to top-level port)
I => dqsFast, -- outgoing dqs is just always the 125MHz clock
T => slowdqsTristate -- 3-state enable input, high=input, low=output
);

IOBUFDS_dqs1 : IOBUFDS
generic map (
IOSTANDARD => "DIFF_SSTL15_II")
port map (
O => dqs1Incoming, -- Buffer output
IO => dqs1_pPORT, -- Diff_p inout (connect directly to top-level port)
IOB => dqs1_nPORT, -- Diff_n inout (connect directly to top-level port)
I => dqsFast, -- Buffer input
T => slowdqsTristate -- 3-state enable input, high=input, low=output
);

OBUFDS_clock : OBUFDS
generic map (
IOSTANDARD => "DIFF_SSTL15_II")
port map (
O => ck_pPORT, -- Diff_p output (connect directly to top-level port)
OB => ck_nPORT, -- Diff_n output (connect directly to top-level port)
I => clkOutFast -- Buffer input
);

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
	if falling_edge(clk250MHz) then
		clockShift(3 downto 1) <= clockShift(2 downto 0);
		clockShift(0) <= clockShift(3);
	end if;
end process;


------------------------------------------COMBINATORIAL:
	process (slowdqstristate,delayedDataForOutput)
		begin
	
	if slowdqsTristate = '1' then
			dataPort (15 downTo 0) <= (15 downTo 0 => 'Z');	
		else
			dataPort(15 downto 0) <= delayedDataForOutput(15 downto 0);
		end if;
		
	end process;
		
------------------------------------------SEQUENTIAL :	
process (clk31M25Hz)
		begin
	if rising_edge(clk31M25Hz)  then 
		capturedDataB(7 downto 0) <= nextCapturedDataB(7 downto 0);
		slowClockEnableRead <= slowNextClockEnableRead;
	end if;
end process;

------------------------------------------COMBINATORIAL:
process (slowReadDataArr, capturedDataB, slowClockEnableRead)
		begin
		
		nextCapturedDataB(7 downto 0) <= capturedDataB(7 downto 0); --unless overridden below, hold and remember the captured values
	
		if slowClockEnableRead = '1'  then
--			nextCapturedDataB(7)(0) <= slowReadData(0);
--			nextCapturedDataB(6)(0) <= slowReadData(1);
--			nextCapturedDataB(5)(0) <= slowReadData(2);
--			nextCapturedDataB(4)(0) <= slowReadData(3);
--			nextCapturedDataB(3)(0) <= slowReadData(4);
--			nextCapturedDataB(2)(0) <= slowReadData(5);
--			nextCapturedDataB(1)(0) <= slowReadData(6);
--			nextCapturedDataB(0)(0) <= slowReadData(7);

--			nextCapturedDataB(7)(1) <= slowReadData(8);
--			nextCapturedDataB(6)(1) <= slowReadData(9);
--			nextCapturedDataB(5)(1) <= slowReadData(10);
--			nextCapturedDataB(4)(1) <= slowReadData(11);
--			nextCapturedDataB(3)(1) <= slowReadData(12);
--			nextCapturedDataB(2)(1) <= slowReadData(13);
--			nextCapturedDataB(1)(1) <= slowReadData(14);
--			nextCapturedDataB(0)(1) <= slowReadData(15);
	
--			nextCapturedDataB(7)(2) <= slowReadData(16);
--			nextCapturedDataB(6)(2) <= slowReadData(17);
--			nextCapturedDataB(5)(2) <= slowReadData(18);
--			nextCapturedDataB(4)(2) <= slowReadData(19);
--			nextCapturedDataB(3)(2) <= slowReadData(20);
--			nextCapturedDataB(2)(2) <= slowReadData(21);
--			nextCapturedDataB(1)(2) <= slowReadData(22);
--			nextCapturedDataB(0)(2) <= slowReadData(23);

--			nextCapturedDataB(7)(3) <= slowReadData(24);
--			nextCapturedDataB(6)(3) <= slowReadData(25);
--			nextCapturedDataB(5)(3) <= slowReadData(26);
--			nextCapturedDataB(4)(3) <= slowReadData(27);
--			nextCapturedDataB(3)(3) <= slowReadData(28);
--			nextCapturedDataB(2)(3) <= slowReadData(29);
--			nextCapturedDataB(1)(3) <= slowReadData(30);
--			nextCapturedDataB(0)(3) <= slowReadData(31);
			
			nextCapturedDataB <= slowReadDataArr;
	end if;
		
end process;
		
	process (clk250MHz, slowClockEnable, clk31M25Hz)
		begin
------------------------------------------SEQUENTIAL :	
			if rising_edge(clk31M25Hz)  then 

			switchRegister <= nextSwitchRegister;
			switchCount <= nextSwitchCount;
			lastSwitchRegister <= switchRegister;
			
			requestReadToggle <= nextRequestReadToggle ;
			requestWriteToggle <= nextRequestWriteToggle ;
			requestedAddress <= nextRequestedAddress  ;

			SPIdataInSlowed <= SPIdataIn ;
			dataArrivedToggleSlowed <= dataArrivedToggle ;
			lastDataArrivedToggle <= dataArrivedToggleSlowed;

			SPIFIFOdin <= nextSPIFIFOdin;
			
			slowFIFOpush <= nextSlowFIFOpush;
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
--	LEDBUS8  <= '0';

	process (capturedDataB, dataArrivedToggleSlowed, SPIdataInSlowed, lastDataArrivedToggle, requestedAddress, requestWriteToggle, requestReadToggle, SPIdataIn, SPIFIFOdin, readBurstCount, fastwriteaddress, empty, nextwritepulsetrain, doutwaiting, dout, clockEnableCommand,  switchRegister, lastSwitchRegister, writePulseTrain,  switch2port, switch3Port, switchCount)
		begin
		nextSPIFIFOdin <= SPIFIFOdin;
		
		addrPort <= fastWriteAddress(14 downto 0);
	
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
	
		
		LEDBUSvec <= capturedDataB(to_integer(switchCount))(8 downto 0);

		LED0 <= dout(0);
		LED1 <= dout(1);
		LED2 <= dout(2);
		LED3 <= dout(3);

--		LEDBUSvec(8 downto 0) <= SPIdataIn(8 downto 0);
--		LEDBUSvec(3 downto 0) <= std_logic_vector(switchCount);
--		LEDBUSvec <= "000000000";
--		LEDBUSvec(7 downto 0) <= std_logic_vector(readBurstCount);
--		LEDBUSvec(8 downto 0) <= SPIFIFOdin (8 downto 0);
		LEDBUSvec(8 downto 0) <= requestedAddress (8 downto 0);
		LEDBUSvec(8 downto 0) <= "000000000";
		
		SPIdataOut(15 downto 0) <= "0000000000000000";
		SPIdataOut(11 downto 8) <= std_logic_vector(switchCount);
		SPIdataOut(7 downto 0) <= capturedDataB(to_integer(switchCount + 0))(7 downto 0);

		nextRequestReadToggle <= requestReadToggle ;
		nextRequestWriteToggle <= requestWriteToggle ;
		nextRequestedAddress <= requestedAddress  ;
		
		nextSlowFIFOpush <= '0';

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
				nextSlowFIFOpush <= '1';
			end if;
			if SPIdataInSlowed(15 downto 8) = "00001000" then -- command 8 means set nextSPIFIFOdin values
				nextSPIFIFOdin(63 downto 0)   <= "1111111111111111111111111111111111111111111111101111111111111111";
				nextSPIFIFOdin(127 downto 64) <= "1111111111111111111111111111111111111111111111111111111111111111";
				nextSPIFIFOdin(143 downto 128) <= "1111111111111111";
			end if;
			if SPIdataInSlowed(15 downto 8) = "00001001" then -- command 9 means set nextSPIFIFOdin values
				nextSPIFIFOdin(63 downto 0)   <= "0000000000000000000000000000000000000000000000010000000000000000";
				nextSPIFIFOdin(127 downto 64) <= "0000000000000000000000000000000000000000000000000000000000000000";
				nextSPIFIFOdin(143 downto 128) <= "0000000000000000";
			end if;
			if SPIdataInSlowed(15 downto 8) = "00001010" then -- command 10 means set nextSPIFIFOdin values
				nextSPIFIFOdin(63 downto 0)   <= "0101010101010101010101010101010101010101010101000101010101010101";
				nextSPIFIFOdin(127 downto 64) <= "0101010101010101010101010101010101010101010101010101010101010101";
				nextSPIFIFOdin(143 downto 128) <= "0101010101010101";
			end if;
			if SPIdataInSlowed(15 downto 8) = "00010010" then -- command 16 through 31 means set nextdin values
--				nextdin(23 downto 16) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "00010100" then -- command 16 through 31 means set nextdin values
--				nextdin(39 downto 32) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "00010110" then -- command 16 through 31 means set nextdin values
--				nextdin(55 downto 48) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "00011000" then -- command 16 through 31 means set nextdin values
--				nextdin(71 downto 64) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "00011010" then -- command 16 through 31 means set nextdin values
--				nextdin(87 downto 80) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "00011100" then -- command 16 through 31 means set nextdin values
--				nextdin(103 downto 96) <= SPIdataInSlowed(7 downto 0);
			end if;
			if SPIdataInSlowed(15 downto 8) = "00011110" then -- command 16 through 31 means set nextdin values
--				nextdin(119 downto 112) <= SPIdataInSlowed(7 downto 0);
			end if;

		end if;
			
   end process;
	
------------------------------------------SEQUENTIAL :	
	process (clk250MHz,  ClockEnableBeginning, slowClockEnable, clk31M25Hz)
		begin
	if rising_edge(clk31M25Hz)  then 

			blinker <= nextBlinker;
			odt <= nextODT;
			din <= nextdin;
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
	
	nextBlinker <= not blinker; --when count = 0 else blinker;

	nextODT <= '1';  -- On Die Termination is normally on
	
	nextdin <= din;

process (clk250MHz)
		begin
------------------------------------------SEQUENTIAL :			
		if rising_edge(clk250MHz) then  
			slowClockVector(6 downto 0) <= slowClockVector(7 downto 1);
			slowClockVector(7) <= slowClockVector(0);
		 
		end if;
   end process;
------------------------------------------COMBINATORIAL:
	
process (clk31M25Hz, slowClockEnable)
		begin
------------------------------------------SEQUENTIAL :			
	if rising_edge(clk31M25Hz)  then  -- the clock is one-eighth speed, so the below logic 
												--can do very complicated count math, FIFO operations, etc, without hitting timing issues
			currentState <= nextState;
			slowCount <= nextSlowCount;
			burstCount <= nextBurstCount;
			slowWritingPulseTrain  <= nextSlowWritingPulseTrain;
			slowWritingDataTrain0  <= dout ;
			slowWritingDataTrain1  <= slowWritingDataTrain0  ;

			addr <= nextAddr;
			slowBA <= nextSlowBA;
			
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

process (slowwritingdatatrain1, dout,  lastrequestwritetoggle, lastrequestreadtoggle, requestedaddress, requestwritetoggle, requestedaddress, requestreadtoggle, empty, readburstcount,  addr, slowBA,  currentState, slowCount, burstCount, nextState, slowWritingPulseTrain)
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
		
	nextReadBurstCount <= readBurstCount ;

	slowFIFOpull <= '0';
	
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
			if	burstCount = 63 then -- this limits the max number of consecutive bursts 
				nextState <= stopWriting;
			end if;
			
			if empty = '1' then   --this checks that more data is available
				nextState <= stopWriting;
				nextBurstCount <= "00000000";
			else
				nextSlowWritingPulseTrain(0) <= '1';
				slowFIFOpull <= '1';
	
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
			if requestReadToggle /= lastRequestReadToggle then
				nextState <= reading;
			
				nextSlowBa <= "000";
				nextAddr <= requestedAddress; 
			end if;

			if requestWriteToggle /= lastRequestWriteToggle and empty = '0' then  -- don't write if the FIFO is empty
				nextState <= startWriting;
				nextSlowBa <= "000";
				nextAddr <= requestedAddress; 
			end if;

		when reading =>
				rasSlow <= "11111111";
				casSlow <= "00111111"; --"11111100";  --"11110011";
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
--				nextAddr <= "000000000000100";  -- DLL enable     RZQ/4 (60O NOM)
			end if;
			if slowCount =  35 then 
				rasSlow <= "11110011";
				casSlow <= "11110011";
				weSlow <= "11110011";
			end if;

			if slowCount =  48   then
				nextSlowBa <= "000";		--MRS MR0
				nextAddr <= (9 => '1', 8 => '0', 5 => '1', others => '0'); --CAS latency = 6, Don'treset DLL  , WriteRecovery = 5, FixedBurstLength = 8
--				nextAddr <= (9 => '1', 8 => '1', 4 => '1', others => '0'); --CAS latency = 5, reset DLL  , WriteRecovery = 5
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
	
	slowWriteData(0)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(1)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(2)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(3)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(4)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(5)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(6)<= "ZZZZZZZZZZZZZZZZ"; 
	slowWriteData(7)<= "ZZZZZZZZZZZZZZZZ"; 

	if slowWritingPulseTrain(1) = '1' or slowWritingPulseTrain(2) = '1' then
		slowWriteData(0)<= slowWritingDataTrain1(15 downto 0); 
		slowWriteData(1)<= slowWritingDataTrain1(31 downto 16); 
		slowWriteData(2)<= slowWritingDataTrain1(47 downto 32); 
		slowWriteData(3)<= slowWritingDataTrain1(63 downto 48); 
		slowWriteData(4)<= slowWritingDataTrain1(79 downto 64); 
		slowWriteData(5)<= slowWritingDataTrain1(95 downto 80); 
		slowWriteData(6)<= slowWritingDataTrain1(111 downto 96); 
		slowWriteData(7)<= slowWritingDataTrain1(127 downto 112); 
	end if;
		
end process;

end Behavioral;
