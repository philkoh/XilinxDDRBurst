--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:23:18 06/23/2020
-- Design Name:   
-- Module Name:   C:/VM/D125MHZA/Stim14.vhd
-- Project Name:  D125MHZA
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
 
ENTITY Stim14 IS
END Stim14;
 
ARCHITECTURE behavior OF Stim14 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bl
    PORT(
         blinkerPORT : OUT  std_logic;
         clk : IN  std_logic;
         LED0 : OUT  std_logic;
         LED1 : OUT  std_logic;
         LED2 : OUT  std_logic;
         LED3 : OUT  std_logic;
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
         monitor2 : OUT  std_logic;
         monitor3 : OUT  std_logic;
         monitor4 : OUT  std_logic;
         switch2PORT : IN  std_logic;
         switch3PORT : IN  std_logic;
         dummyOut : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
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
   signal monitor2 : std_logic;
   signal monitor3 : std_logic;
   signal monitor4 : std_logic;
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
          monitor2 => monitor2,
          monitor3 => monitor3,
          monitor4 => monitor4,
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
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
