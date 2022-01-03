-- (c) Copyright 2009 - 2011 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.

-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component PhilData
generic
 (-- width of the data for the system
  sys_w       : integer := 1;
  -- width of the data for the device
  dev_w       : integer := 8);
port
 (
  DATA_TO_AND_FROM_PINS   : inout std_logic_vector(sys_w-1 downto 0);
  DATA_IN_TO_DEVICE       : out   std_logic_vector(dev_w-1 downto 0);
  -- From the device out to the system
  DATA_OUT_FROM_DEVICE    : in    std_logic_vector(dev_w-1 downto 0);
  CLK_TO_PINS             : out std_logic;

-- Input, Output delay control signals
  DELAY_BUSY              : out   std_logic;
  DELAY_CLK               : in    std_logic;
  DELAY_DATA_CAL          : in    std_logic;
  DELAY_DATA_CE           : in    std_logic;                    -- Enable signal for delay 
  DELAY_DATA_INC          : in    std_logic;                    -- Delay increment (high), decrement (low) signal
  TRISTATE_OUTPUT         : in    std_logic;
-- Clock and reset signals
  CLK_IN_P                : in    std_logic;                    -- Differential fast clock from IOB
  CLK_IN_N                : in    std_logic;
  CLK_DIV_OUT             : out   std_logic;                    -- Slow clock output
  CLK_RESET               : in    std_logic;                    -- Reset signal for Clock circuit
  IO_RESET                : in    std_logic);                   -- Reset signal for IO circuit
end component;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------
-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG

-- User Notes:
-- None

your_instance_name : PhilData
  port map
   (
  DATA_TO_AND_FROM_PINS =>   DATA_TO_AND_FROM_PINS, --Bi-Directional Pins
  DATA_IN_TO_DEVICE =>   DATA_IN_TO_DEVICE, --Output pins
  -- From the device out to the system
  DATA_OUT_FROM_DEVICE =>   DATA_OUT_FROM_DEVICE, --Input pins
  CLK_TO_PINS        => CLK_TO_PINS, --Output pins

-- Input, Output delay control signals
  DELAY_BUSY =>   DELAY_BUSY, --Output pin
  DELAY_CLK =>   DELAY_CLK, --Input pin
  DELAY_DATA_CAL =>   DELAY_DATA_CAL, --Input pin
  DELAY_DATA_CE =>   DELAY_DATA_CE,   -- Enable signal for delay
  DELAY_DATA_INC =>   DELAY_DATA_INC,  -- Delay increment (high), decrement (low) signal
  TRISTATE_OUTPUT =>   TRISTATE_OUTPUT,  --Output pin
  
-- Clock and reset signals
  CLK_IN_P =>   CLK_IN_P,     -- Differential clock from IOB
  CLK_IN_N =>   CLK_IN_N,     -- Differential clock from IOB
  CLK_DIV_OUT =>   CLK_DIV_OUT,     -- Slow clock output
  CLK_RESET =>   CLK_RESET,         --clocking logic reset
  IO_RESET =>   IO_RESET);          --system reset

-- INST_TAG_END ------ End INSTANTIATION Template ------------
