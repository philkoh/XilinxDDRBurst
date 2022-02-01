--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   04:13:51 02/01/2022
-- Design Name:   
-- Module Name:   C:/GitRepos/XilinxDDRBurst/SPItest.vhd
-- Project Name:  XilinxBurst
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bl
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY SPItest IS
END SPItest;
 
ARCHITECTURE behavior OF SPItest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bl
    PORT(
         blinkerPORT : OUT  std_logic;
         clk : IN  std_logic;
         LED0 : OUT  std_logic;
         LED1 : OUT  std_logic;
         LED2 : OUT  std_logic;
         LED3 : OUT  std_logic;
         LEDBUS0 : OUT  std_logic;
         LEDBUS1 : OUT  std_logic;
         LEDBUS2 : OUT  std_logic;
         LEDBUS3 : OUT  std_logic;
         LEDBUS4 : OUT  std_logic;
         LEDBUS5 : OUT  std_logic;
         LEDBUS6 : OUT  std_logic;
         LEDBUS7 : OUT  std_logic;
         LEDBUS8 : OUT  std_logic;
         PIN0 : IN  std_logic;
         PIN1 : OUT  std_logic;
         PIN26 : IN  std_logic;
         PIN27 : IN  std_logic;
         baPORT : OUT  std_logic_vector(2 downto 0);
         addrPORT : OUT  std_logic_vector(14 downto 0);
         dataPORT : INOUT  std_logic_vector(15 downto 0);
         casPORT : OUT  std_logic;
         rasPORT : OUT  std_logic;
         wePORT : OUT  std_logic;
         resetPort : OUT  std_logic;
         ckePort : OUT  std_logic;
         ck_pPORT : INOUT  std_logic;
         ck_nPORT : INOUT  std_logic;
         dqs0_pPORT : INOUT  std_logic;
         dqs0_nPORT : INOUT  std_logic;
         dqs1_pPORT : INOUT  std_logic;
         dqs1_nPORT : INOUT  std_logic;
         dqm0PORT : OUT  std_logic;
         dqm1PORT : OUT  std_logic;
         odtPORT : OUT  std_logic;
         switch2PORT : IN  std_logic;
         switch3PORT : IN  std_logic;
         dummyOut : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal PIN0 : std_logic := '0';
   signal PIN26 : std_logic := '0';
   signal PIN27 : std_logic := '0';
   signal switch2PORT : std_logic := '0';
   signal switch3PORT : std_logic := '0';

	--BiDirs
   signal dataPORT : std_logic_vector(15 downto 0);
   signal ck_pPORT : std_logic;
   signal ck_nPORT : std_logic;
   signal dqs0_pPORT : std_logic;
   signal dqs0_nPORT : std_logic;
   signal dqs1_pPORT : std_logic;
   signal dqs1_nPORT : std_logic;

 	--Outputs
   signal blinkerPORT : std_logic;
   signal LED0 : std_logic;
   signal LED1 : std_logic;
   signal LED2 : std_logic;
   signal LED3 : std_logic;
   signal LEDBUS0 : std_logic;
   signal LEDBUS1 : std_logic;
   signal LEDBUS2 : std_logic;
   signal LEDBUS3 : std_logic;
   signal LEDBUS4 : std_logic;
   signal LEDBUS5 : std_logic;
   signal LEDBUS6 : std_logic;
   signal LEDBUS7 : std_logic;
   signal LEDBUS8 : std_logic;
   signal PIN1 : std_logic;
   signal baPORT : std_logic_vector(2 downto 0);
   signal addrPORT : std_logic_vector(14 downto 0);
   signal casPORT : std_logic;
   signal rasPORT : std_logic;
   signal wePORT : std_logic;
   signal resetPort : std_logic;
   signal ckePort : std_logic;
   signal dqm0PORT : std_logic;
   signal dqm1PORT : std_logic;
   signal odtPORT : std_logic;
   signal dummyOut : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bl PORT MAP (
          blinkerPORT => blinkerPORT,
          clk => clk,
          LED0 => LED0,
          LED1 => LED1,
          LED2 => LED2,
          LED3 => LED3,
          LEDBUS0 => LEDBUS0,
          LEDBUS1 => LEDBUS1,
          LEDBUS2 => LEDBUS2,
          LEDBUS3 => LEDBUS3,
          LEDBUS4 => LEDBUS4,
          LEDBUS5 => LEDBUS5,
          LEDBUS6 => LEDBUS6,
          LEDBUS7 => LEDBUS7,
          LEDBUS8 => LEDBUS8,
          PIN0 => PIN0,
          PIN1 => PIN1,
          PIN26 => PIN26,
          PIN27 => PIN27,
          baPORT => baPORT,
          addrPORT => addrPORT,
          dataPORT => dataPORT,
          casPORT => casPORT,
          rasPORT => rasPORT,
          wePORT => wePORT,
          resetPort => resetPort,
          ckePort => ckePort,
          ck_pPORT => ck_pPORT,
          ck_nPORT => ck_nPORT,
          dqs0_pPORT => dqs0_pPORT,
          dqs0_nPORT => dqs0_nPORT,
          dqs1_pPORT => dqs1_pPORT,
          dqs1_nPORT => dqs1_nPORT,
          dqm0PORT => dqm0PORT,
          dqm1PORT => dqm1PORT,
          odtPORT => odtPORT,
          switch2PORT => switch2PORT,
          switch3PORT => switch3PORT,
          dummyOut => dummyOut
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		PIN0 <= '1';
		PIN27 <= '0';
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		PIN0 <= '0';
		PIN26 <= '0';
	
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		
		PIN26 <= '1';
		
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		
		PIN26 <= '0';
		
		PIN27 <= '0';
      wait for clk_period*10;

      wait for clk_period*10;
		
		wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;


		PIN0 <= '1';




      wait for 15us;



		PIN0 <= '0';
		PIN26 <= '0';
	
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		
		
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		
		PIN26 <= '1';
		
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		
		PIN26 <= '0';
		
		PIN27 <= '0';
      wait for clk_period*10;

      wait for clk_period*10;
		
		wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;
		PIN27 <= '1';
      wait for clk_period*10;
		PIN27 <= '0';
      wait for clk_period*10;


		PIN0 <= '1';


      wait;
   end process;

END;
