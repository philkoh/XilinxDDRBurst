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
--		   dataFAST : inout std_logic_vector(0 downto 0);

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
			

			monitor2 :out std_logic;
			monitor3 :out std_logic;
			monitor4 :out std_logic;
			
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
	signal clockEnableMidpoint : std_logic := '0';
	signal clockEnableRead : std_logic := '0';
	signal nextClockEnableBeginning : std_logic := '0';
	signal nextClockEnableMidpoint : std_logic := '0';
	signal nextClockEnableRead : std_logic := '0';
   signal count2 : unsigned (4 downto 0) := "00000";
   signal count : unsigned (17 downto 0) := "000000000000000000";
   signal nextCount2 : unsigned (4 downto 0);
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
	signal addr :   std_logic_vector(14 downto 0);
	signal nextAddr :   std_logic_vector(14 downto 0);
	signal dataCount :   unsigned (3 downto 0)  := "1111";
	signal nextDataCount :   unsigned (3 downto 0):= "1111";
	signal data :   std_logic_vector(15 downto 0) := "1111111111111111";
	signal nextData :   std_logic_vector(15 downto 0):= "1111111111111111";
	signal inData :   std_logic_vector(15 downto 0);
	signal inDataB :   std_logic_vector(15 downto 0);

	signal capturedData1 :   std_logic_vector(15 downto 0);
	signal capturedData2 :   std_logic_vector(15 downto 0);
	signal capturedData3 :   std_logic_vector(15 downto 0);
	signal capturedData4 :   std_logic_vector(15 downto 0);
	signal capturedData5 :   std_logic_vector(15 downto 0);
	signal capturedData6 :   std_logic_vector(15 downto 0);
	signal capturedData7 :   std_logic_vector(15 downto 0);
	signal capturedData8 :   std_logic_vector(15 downto 0);
	signal capturedData9 :   std_logic_vector(15 downto 0);
	signal capturedData10 :   std_logic_vector(15 downto 0);
	signal capturedData11 :   std_logic_vector(15 downto 0);
	signal nextCapturedData1 :   std_logic_vector(15 downto 0);
	signal nextCapturedData2 :   std_logic_vector(15 downto 0);
	signal nextCapturedData3 :   std_logic_vector(15 downto 0);
	signal nextCapturedData4 :   std_logic_vector(15 downto 0);
	signal nextCapturedData5 :   std_logic_vector(15 downto 0);
	signal nextCapturedData6 :   std_logic_vector(15 downto 0);
	signal nextCapturedData7 :   std_logic_vector(15 downto 0);
	signal nextCapturedData8 :   std_logic_vector(15 downto 0);
	signal nextCapturedData9 :   std_logic_vector(15 downto 0);
	signal nextCapturedData10 :   std_logic_vector(15 downto 0);
	signal nextCapturedData11 :   std_logic_vector(15 downto 0);
	signal tristateData : std_logic := '1';
	signal tristateDataFromDDR : std_logic := '1';
	signal nextTristateData : std_logic := '1';
	
	

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

	signal saveRequest : std_logic := '0';
	signal nextSaveRequest : std_logic := '0';
	signal saveRequest2 : std_logic := '0';
	signal nextSaveRequest2 : std_logic := '0';
		signal saveRequest3 : std_logic := '0';
	signal nextSaveRequest3 : std_logic := '0';
	signal saveRequest4 : std_logic := '0';
	signal nextSaveRequest4 : std_logic := '0';
	
	
	signal initializationMode : std_logic := '1';
	signal nextInitializationMode : std_logic := '1';

	signal switchRegister : std_logic := '0';
	signal nextSwitchRegister : std_logic := '0';
   signal lastSwitchRegister : std_logic := '0';

   signal switchCount : unsigned (3 downto 0) := "0000";
   signal nextSwitchCount : unsigned (3 downto 0) := "0000";
   
	
begin


------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : PhilClock
  port map
   (-- Clock in ports
    CLK_IN1 => clk,
    -- Clock out ports
    CLK_OUT1 => clk250MHz);
-- INST_TAG_END ------ End INSTANTIATION Template ------------








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








	process (clk250MHz)
	
	
		begin
	
------------------------------------------SEQUENTIAL :	
		if rising_edge(clk250MHz) then
			clk125MHz <=  nextClk125MHz  ;
			inData (15 downTo 0) <= dataPort (15 downTo 0);  -- data uses the 250 MHz clock


			capturedData1 <= nextCapturedData1;
			capturedData2 <= nextCapturedData2;
			capturedData3 <= nextCapturedData3;
			capturedData4 <= nextCapturedData4;
			capturedData5 <= nextCapturedData5;
			capturedData6 <= nextCapturedData6;
			capturedData7 <= nextCapturedData7;
			capturedData8 <= nextCapturedData8;

		end if;
 end process;

		------------------------------------------COMBINATORIAL:
	process (clk125MHz,count2,   clockEnableMidpoint,clockEnableRead,cas,casRequest,ras,rasRequest,we,weRequest,saveRequest,inData,capturedData1,capturedData2,capturedData3,capturedData4)
	
	
		begin
		

		nextClk125MHz <= not clk125MHz;
		
		nextCapturedData1 <= capturedData1; --unless overridden below, hold and remember the captured values
		nextCapturedData2 <= capturedData2;
		nextCapturedData3 <= capturedData3;
		nextCapturedData4 <= capturedData4;
		nextCapturedData5 <= capturedData5;
		nextCapturedData6 <= capturedData6;
		nextCapturedData7 <= capturedData7;
		nextCapturedData8 <= capturedData8;
		nextCapturedData9 <= capturedData9;
		nextCapturedData10 <= capturedData10;
		nextCapturedData10 <= capturedData11;
			
		
			if clockEnableRead = '1' and saveRequest = '1' then --capture data, actually captures 8 times, I think, 4 cycles of count2 at 125MHz, but two rising edges of 250 MHz per count2 incremena
				nextCapturedData1 <= inData;
				nextCapturedData2 <= capturedData1;
				nextCapturedData3 <= capturedData2;
				nextCapturedData4 <= capturedData3;
				nextCapturedData5 <= capturedData4;
				nextCapturedData6 <= capturedData5;
				nextCapturedData7 <= capturedData6;
				nextCapturedData8 <= capturedData7;
				nextCapturedData9 <= capturedData8;
				nextCapturedData10 <= capturedData9;
				nextCapturedData11 <= capturedData10;
		
			end if;


			if clockEnableRead = '1' and saveRequest2 = '1' then --shift in new data
				nextCapturedData2 <= inData;
			end if;



			if clockEnableRead = '1' and saveRequest3 = '1' then --shift in new data
				nextCapturedData3 <= inData;
			end if;





			if clockEnableRead = '1' and saveRequest4 = '1' then --shift in new data
				nextCapturedData4 <= inData;
			end if;


		
	end process;
		
		
		
	process (clk250MHz, clk125MHz)
	
	
		begin
	
------------------------------------------SEQUENTIAL :	
		
		
		
		
		if rising_edge(clk250MHz) and clk125MHz = '1' then
		
			count2 <= nextCount2;    -- count2 runs at 125 MHz
			clockEnableBeginning <= nextClockEnableBeginning;
			clockEnableMidpoint <= nextClockEnableMidpoint;
			clockEnableRead <= nextClockEnableRead;
			cas <= nextCas;
			ras <= nextRas;
			we <= nextWe;
			initializationMode <= nextInitializationMode;
			switchRegister <= nextSwitchRegister;
			switchCount <= nextSwitchCount;
			lastSwitchRegister <= switchRegister;



		
		end if;
		
   end process;
	
------------------------------------------COMBINATORIAL:
	process (count2,dqs0incoming,switchregister,switch2port,switch3port,switchCount,lastSwitchRegister,tristateData, initializationmode,inDataB, captureddata5,captureddata6,captureddata7,captureddata8, clockEnableMidpoint,clockEnableRead,cas,casRequest,ras,rasRequest,we,weRequest,saveRequest,inData,capturedData1,capturedData2,capturedData3,capturedData4)
	
	
		begin
		
		casPORT <= cas;
		rasPORT <= ras;
		wePORT <= we;
		
		
		
		monitor2 <= dqs0Incoming;
		monitor3 <= '0';
		monitor4 <= '0';
--		monitor3 <= dataPORT(0);
--		monitor4 <= dataPORT(1);

		nextInitializationMode <= initializationMode;
	
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

		if initializationMode = '1' then --initializationMode is always '1', so this is always true
			nextCount2 <= count2 + 1;  -- count2 increments at 125 MHz, not 250 MHz
			
			if count2 = 0    then
				nextClockEnableBeginning <= '1';  -- this flag executes all the block of code below that changes signals on the count2 = 0 edge 
			else
				nextClockEnableBeginning <= '0';
			end if;
			
			if count2 = 16   then   -- this pulses the CAS/RAS/WE command that must get sent on the midpoint instant of the read or write cycle
					nextClockEnableMidpoint <= '1';
			else
				nextClockEnableMidpoint <= '0';
			end if;
				
			if (count2 = 24 or count2 = 25 or count2 = 26 or count2 = 27)   then  --reads for 4 cycles of 125MHz count2
--			if count2 = 26 or count2 = 27 or count2 = 28 or count2 = 29 then
				nextClockEnableRead <= '1';
			else
				nextClockEnableRead <= '0';
			end if;
			
 			nextCas <= cas;
			nextRas <= ras;
			nextWe <= we;
			
			if clockEnableMidpoint = '1' then  --the CAS/RAS/WE command is only applied for this one 125 MHz clock cycle when count2=16
				nextCas <= casRequest;
				nextRas <= rasRequest;
				nextWe <= weRequest;
			else                      -- otherwise, CAS/RAS/WE are held HIGH (which is the NOP, No Operation command)
				nextCas <= '1';
				nextRas <= '1';
				nextWe <= '1';
			end if;
		

		 	
	

		 if switchCount = 0 then
				LED0 <=   capturedData1(0);
				LED1 <=    capturedData1(1);
				LED2 <=    capturedData1(2);
				LED3 <=    capturedData1(3);
		end if;
		 if switchCount = 1 then
 
				LED0 <=   capturedData2(0);
				LED1 <=    capturedData2(1);
				LED2 <=    capturedData2(2);
				LED3 <=    capturedData2(3);
				
		end if;
		 if switchCount = 2 then
				LED0 <=   capturedData3(0);
				LED1 <=    capturedData3(1);
				LED2 <=    capturedData3(2);
				LED3 <=    capturedData3(3);
				
		 end if;
		 if switchCount = 3 then
				LED0 <=   capturedData4(0);
				LED1 <=    capturedData4(1);
				LED2 <=    capturedData4(2);
				LED3 <=    capturedData4(3);
		 end if;
		 if switchCount = 4 then
				LED0 <=   capturedData5(0);
				LED1 <=    capturedData5(1);
				LED2 <=    capturedData5(2);
				LED3 <=    capturedData5(3);
		 end if;
		 if switchCount = 5 then
				LED0 <=   capturedData6(0);
				LED1 <=    capturedData6(1);
				LED2 <=    capturedData6(2);
				LED3 <=    capturedData6(3);
		 end if;
		 if switchCount = 6 then
				LED0 <=   capturedData7(0);
				LED1 <=    capturedData7(1);
				LED2 <=    capturedData7(2);
				LED3 <=    capturedData7(3);
		 end if;
		 if switchCount = 7 then
				LED0 <=   capturedData8(0);
				LED1 <=    capturedData8(1);
				LED2 <=    capturedData8(2);
				LED3 <=    capturedData8(3);
		 end if;

		 if switchCount = 8 then
				LED0 <=   capturedData9(0);
				LED1 <=    capturedData9(1);
				LED2 <=    capturedData9(2);
				LED3 <=    capturedData9(3);
		 end if;

	   if switchCount = 9 then
				LED0 <=   capturedData10(0);
				LED1 <=    capturedData10(1);
				LED2 <=    capturedData10(2);
				LED3 <=    capturedData10(3);
		 end if;


		    if switchCount = 10 then
				LED0 <=   capturedData11(0);
				LED1 <=    capturedData11(1);
				LED2 <=    capturedData11(2);
				LED3 <=    capturedData11(3);
		 end if;

			
			 
		
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
			addr <= nextAddr;
			data <= nextData;  --note, this is a massive fudge; the data for a write is presented through the entire cycle of 32 count2 increments
			casRequest <= nextCasRequest;
			rasRequest <= nextRasRequest;
			weRequest <= nextWeRequest;
			saveRequest <= nextSaveRequest;
			saveRequest2 <= nextSaveRequest2;
			saveRequest3 <= nextSaveRequest3;
			saveRequest4 <= nextSaveRequest4;
			reset <= nextReset;
			cke <= nextCke;
			dqsTristate <= nextDqsTristate;
			odt <= nextODT;
			tristateData <= nextTristateData;
			end if;
   end process;

------------------------------------------COMBINATORIAL:
	process (count,blinker,ba,addr,casRequest,rasRequest,weRequest,reset,cke,data,capturedData1,capturedData2,capturedData3,capturedData4,odt,tristateData)

		begin
	--		dummyOut <= capturedData(4) and  capturedData(5) and capturedData(6) and capturedData(7) and capturedData(8) and capturedData(9) and capturedData(10) and capturedData(11) and capturedData(12) and capturedData(13) and capturedData(14) and capturedData(15);


			dqm0PORT  <= '0';
			dqm1PORT  <= '0';
			odtPORT <= odt;
			baPort <= ba;
			addrPort <= addr;
			
			resetPort <= reset;
			ckePort <= cke;
	
	
	
			blinkerPORT <= blinker;
			
			nextCount <= count + 1;
			
			if count = 0 then
				nextBlinker <= not blinker;
			else
				nextBlinker <= blinker;
			end if;
		
			if tristateData = '1' then
				dataPort (15 downTo 0) <= (15 downTo 0 => 'Z');
			else
	--			dataPort (0) <= dataCount (0);			
	--			dataPort (1) <= dataCount (1);			
	--			dataPort (2) <= dataCount (2);			
	--			dataPort (3) <= dataCount (3);			
				dataPort (15 downTo 0) <= data (15 downTo 0);			
			end if;



			nextDqsTristate <= '1';


			nextCasRequest <= '1';
			nextRasRequest <= '1';
			nextWeRequest <= '1';
			nextSaveRequest <= '0';
			nextSaveRequest2 <= '0';
			nextSaveRequest3 <= '0';
			nextSaveRequest4 <= '0';
			nextODT <= '1';  -- On Die Termination is normally on
			nextBa <= (others => '0');
			nextAddr <= (others => '0');
			nextData <= (others => 'Z');
			nextTristateData <= '1';

			nextReset <= reset;
			nextCke <= cke;
			if count = 0 then
				nextReset <= '0';
				nextCke <= '0';
			end if;
			if count = 5000 then --5000
				nextReset <= '1';
			end if;
			if count = 20000 then -- 20000
				nextCke <= '1';
			end if;
			
			if count = 20100 then -- 20100 --do nothing (sets nextAddr to get rid of an annoying warking)
				nextBa <= "111";
				nextAddr <= "111111111111111";
			end if;
	

			if count = 20200 then--20200 --MRS MR2
				nextBa <= "010";
				nextAddr <= "000000000001000";  --CWL = 6
--				nextAddr <= "000000000000000";  --CWL = 5
				nextRasRequest <= '0';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
	
			if count = 20201 then--20201 --MRS MR3
				nextBa <= "011";
				nextAddr <= "000000000000100"; -- MPR mode, outputs special pattern on reads
				nextRasRequest <= '0';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
	
	
			if count = 20202 then--20202 --MRS MR1  
				nextBa <= "001";
				nextAddr <= "000000000000101";  -- DLL disable     RZQ/4 (60O NOM)
--				nextAddr <= "000000000000100";  -- DLL enable     RZQ/4 (60O NOM)
				nextRasRequest <= '0';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
	
	
			if count = 20203 then--20203 --MRS MR0
				nextBa <= "000";	
				nextAddr <= (9 => '1', 8 => '0', 5 => '1', others => '0'); --CAS latency = 6, Don'treset DLL  , WriteRecovery = 5, FixedBurstLength = 8
--				nextAddr <= (9 => '1', 8 => '1', 4 => '1', others => '0'); --CAS latency = 5, reset DLL  , WriteRecovery = 5
				nextRasRequest <= '0';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
	
			if count = 20204 then--20204 --ZQCL
				nextBa <= "000";				
				nextAddr <= (10 => '1', others => '0'); 
				nextRasRequest <= '1';
				nextCasRequest <= '1';
				nextWeRequest <= '0';
			end if;
		
		
			if count = 20224 then--20224 --MRS MR3
				nextBa <= "011";
				nextAddr <= "000000000000000"; 
				nextRasRequest <= '0';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
	
	
		
		
			if count = 20226 then--20226 --ACTIVATE
				nextBa <= "000";
				nextAddr <= "000000000001000"; --Row Address 8  
				nextRasRequest <= '0';
				nextCasRequest <= '1';
				nextWeRequest <= '1';
			end if;
	

			if count = 20229 then--20228 --WRITE
				nextData <= "1010101010100110"; -- the last four digits of this will show up on the LEDs
				nextDqsTristate <= '0';
				nextTristateData <= '0';
			
				nextBa <= "000";
				nextAddr <= "000000000001000";
				nextRasRequest <= '1';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
			
			if count = 20230 then--20230 --WRITE
				nextData <= "1111111111111001";
				nextDqsTristate <= '0';
				nextTristateData <= '0';
			
				nextBa <= "000";
				nextAddr <= "000000000010000";
				nextRasRequest <= '1';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;

	

			if count = 20231 then  --WRITE
				nextData <= "1010101010100111";  
				nextDqsTristate <= '0';
				nextTristateData <= '0';
			
				nextBa <= "000";
				nextAddr <= "000000000011000";
				nextRasRequest <= '1';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;
			
			if count = 20232 then  --WRITE
				nextData <= "1111111111110001";
				nextDqsTristate <= '0';
				nextTristateData <= '0';
			
				nextBa <= "000";
				nextAddr <= "000000000100000";
				nextRasRequest <= '1';
				nextCasRequest <= '0';
				nextWeRequest <= '0';
			end if;

			if count = 20236 then--20232   --READ
				nextODT <= '0';  -- turn On Die Termination off for read

				nextSaveRequest <= '1';	
				
				nextBa <= "000";
				nextAddr <= "000000000001000";
				nextRasRequest <= '1';
				nextCasRequest <= '0';
				nextWeRequest <= '1';
			end if;
			
			
		
   end process;
		

end Behavioral;

