-- file: PhilData_tb.vhd
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

------------------------------------------------------------------------------
-- SelectIO wizard demonstration testbench
------------------------------------------------------------------------------
-- This demonstration testbench instantiates the example design for the 
--   SelectIO wizard. 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

library work;
use work.all;

entity PhilData_tb is
end PhilData_tb;

architecture test of PhilData_tb is

component PhilData_exdes
generic (
  -- width of the data for the system
  sys_w      : integer := 1;
  -- width of the data for the device
  dev_w      : integer := 8
);
port (
  PATTERN_COMPLETED_OUT     : out   std_logic_vector (1 downto 0);
  DATA_TO_AND_FROM_PINS1    : inout std_logic_vector(sys_w-1 downto 0);
  DATA_TO_AND_FROM_PINS2    : inout std_logic_vector(sys_w-1 downto 0);
  CLK_TO_PINS             : out std_logic;

  TRISTATE_OUTPUT          : in    std_logic;
  TRISTATE_OUTPUT_INV      : in    std_logic;
  CLK_IN_P                 : in    std_logic;
  CLK_IN_N                 : in    std_logic;
  CLK_IN1                   : in    std_logic;
  CLK_RESET                : in    std_logic;
  IO_RESET                 : in    std_logic);
end component;
  constant clk_per         : time    :=  10 ns; -- 100 MHz clk
  constant sys_w           : integer := 1;
  constant dev_w           : integer := 8;
  constant num_serial_bits : integer := dev_w/sys_w;
  signal   clk_to_pins     : std_logic;
  signal   tristate_output : std_logic;
  signal   tristate_output_inv : std_logic;
  signal   sim_over : std_logic_vector (1 downto 0);
  signal   sim_check : std_logic := '0';
  signal   data_to_and_from_pins1   : std_logic_vector(sys_w-1 downto 0);
  signal   data_to_and_from_pins2   : std_logic_vector(sys_w-1 downto 0);
  signal   clk_in             : std_logic := '0';
  signal   clk_in_p           : std_logic;
  signal   clk_in_n           : std_logic;
  signal   clk_in1             : std_logic := '0';
  signal   clk_reset          : std_logic;
  signal   io_reset           : std_logic;
  signal   pattern_completed_out : std_logic_vector (1 downto 0);
  signal   timeout_counter    : std_logic_vector (10 downto 0) := "00000000000";
  signal   bitslip_timeout : std_logic_vector (16 downto 0) := "00000000000000000";


begin

  -- Any aliases
   clk_in_p <= clk_in;
   clk_in_n <= not clk_in;

  -- clock generator- 100 MHz simulation clock
  --------------------------------------------
  process begin
    wait for (clk_per/2);
    clk_in <= not clk_in;
  end process;

  process begin
    wait for (clk_per/4);
    clk_in1 <= not clk_in1;
  end process;




  -- Test sequence
  process 
    procedure simtimeprint is
      variable outline : line;
    begin
      write(outline, string'("## SYSTEM_CYCLE_COUNTER "));
      write(outline, NOW/clk_per);
      write(outline, string'(" ns"));
      writeline(output,outline);
    end simtimeprint;
  begin
    tristate_output <= '1';
    tristate_output_inv <= '0';
    sim_over <= "00";
    -- reset the logic
    clk_reset   <= '1';
    io_reset    <= '1';
    
    wait for (18*clk_per);
    clk_reset   <= '0';

    wait for (30*clk_per);
    io_reset    <= '0';
   
    wait until (pattern_completed_out = "11"); 
    sim_over <= "01";



    wait for (10*clk_per);
    tristate_output <= '1';
    tristate_output_inv <= '1';

    wait for (50*clk_per);
    tristate_output <= '0';
    tristate_output_inv <= '1';
    wait for (200*clk_per);
    sim_over <= "11";
    wait;
  end process;

process (clk_in)
    procedure simtimeprint is
      variable outline : line;
    begin
      write(outline, string'("## SYSTEM_CYCLE_COUNTER "));
      write(outline, NOW/clk_per);
      write(outline, string'(" ns"));
      writeline(output,outline);
    end simtimeprint;
begin
    if (clk_in'event and clk_in = '1') then
    if (io_reset = '0') then
       timeout_counter <= timeout_counter + '1';
       if (timeout_counter = "00000110000") then
         simtimeprint;
         report "BITSLIP not enabled, Please turn it on (S6)" severity note;
       report "SIMULATION STOPPED." severity failure;
       end if;
    end if; 
    end if;
end process;


process (clk_in)
    procedure simtimeprint is
      variable outline : line;
    begin
      write(outline, string'("## SYSTEM_CYCLE_COUNTER "));
      write(outline, NOW/clk_per);
      write(outline, string'(" ns"));
      writeline(output,outline);
    end simtimeprint;
begin
    if (clk_in'event and clk_in = '1') then
    if (io_reset = '0') then
    if (sim_check = '0') then
    if (pattern_completed_out = "00") then
       report "SIMULATION started" severity note;
    elsif (pattern_completed_out = "10") then
       simtimeprint;
       report "ERROR : SIMULATION FAILED. SERDES Design" severity failure;
    elsif (pattern_completed_out = "01") then
       bitslip_timeout <= bitslip_timeout + '1';
       if (bitslip_timeout = "11111111111111111") then
          simtimeprint;
          report "ERROR: TOO LONG A TIME FOR BITSLIP COMPLETION" severity failure;
       end if;
       report "SIMULATION in progress: BITSLIPS found, data checking in progress" severity note;
    elsif (pattern_completed_out = "11") then
         simtimeprint;
         report "BITSLIP not enabled, please turn it on (S6)" severity note;
       report "SIMULATION STOPPED." severity failure;
    else
       simtimeprint;
       report "ERROR : unknown state. SERDES Design" severity failure;
    end if;
    else
      if (sim_over = "11") then
         simtimeprint;
         report "Test Completed Successfully" severity note;
         report "SIMULATION STOPPED." severity failure;
      end if;
    end if;
    end if;
    end if;
end process;



  data_to_and_from_pins2 <= data_to_and_from_pins1 after 1.00 ns when tristate_output = '0' else (others => 'Z') ;
  data_to_and_from_pins1 <= data_to_and_from_pins2 after 1.00 ns when tristate_output = '1' else (others => 'Z') ;
 
  -- Instantiation of the example design

  dut : PhilData_exdes
  generic map
  (
   sys_w => 1,
   dev_w => 8
   )
  port map
  (
   PATTERN_COMPLETED_OUT      => pattern_completed_out,
   DATA_TO_AND_FROM_PINS1     => data_to_and_from_pins1,
   DATA_TO_AND_FROM_PINS2     => data_to_and_from_pins1,
    CLK_TO_PINS             => clk_to_pins,
   TRISTATE_OUTPUT           => tristate_output,
   TRISTATE_OUTPUT_INV       => tristate_output_inv,
   CLK_IN_P                  => clk_in_p,
   CLK_IN_N                  => clk_in_n,
   CLK_IN1                    => clk_in1,
   CLK_RESET                 => clk_reset,
   IO_RESET                  => io_reset);
end test;

