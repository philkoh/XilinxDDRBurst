-- file: DelayPorts_exdes.vhd
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
-- SelectIO wizard example design
------------------------------------------------------------------------------
-- This example design instantiates the IO circuitry
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.and_reduce;

library unisim;
use unisim.vcomponents.all;

entity DelayPorts_exdes is
generic (
  -- width of the data for the system
  sys_w      : integer := 16;
  -- width of the data for the device
  dev_w      : integer := 16
);
port (
  PATTERN_COMPLETED_OUT     : out   std_logic_vector (1 downto 0);
  DATA_TO_AND_FROM_PINS1    : inout std_logic_vector(sys_w-1 downto 0);
  DATA_TO_AND_FROM_PINS2    : inout std_logic_vector(sys_w-1 downto 0);

  TRISTATE_OUTPUT          : in    std_logic;
  TRISTATE_OUTPUT_INV      : in    std_logic;
  CLK_IN                   : in    std_logic;
  CLK_IN1                   : in    std_logic;
  IO_RESET                 : in    std_logic);
end DelayPorts_exdes;

architecture xilinx of DelayPorts_exdes is

component DelayPorts is
generic
 (-- width of the data for the system
  sys_w       : integer := 16;
  -- width of the data for the device
  dev_w       : integer := 16);
port
 (
  DATA_TO_AND_FROM_PINS   : inout std_logic_vector(sys_w-1 downto 0);
  DATA_IN_TO_DEVICE       : out   std_logic_vector(dev_w-1 downto 0);
  -- From the device out to the system
  DATA_OUT_FROM_DEVICE    : in    std_logic_vector(dev_w-1 downto 0);

  TRISTATE_OUTPUT         : in    std_logic;
-- Clock and reset signals
  CLK_IN                  : in    std_logic;                    -- Single ended Fast clock from IOB
  CLK_OUT                 : out   std_logic;
  IO_RESET                : in    std_logic);                   -- Reset signal for IO circuit
end component;

   constant num_serial_bits  : integer := dev_w/sys_w;
   signal unused             : std_logic;
   signal clkin1             : std_logic;
   signal count_out          : std_logic_vector (num_serial_bits-1 downto 0);
   signal local_counter      : std_logic_vector(num_serial_bits-1 downto 0);
   signal pattern_completed    : std_logic_vector (1 downto 0) := "00";
   signal clk_in_int_inv       : std_logic;
            -- connection between ram and io circuit
   signal data_in_to_device1         : std_logic_vector(dev_w-1 downto 0);
   signal data_in_to_device2         : std_logic_vector(dev_w-1 downto 0);
   signal data_in_to_device1_int2    : std_logic_vector(dev_w-1 downto 0);
   signal data_in_to_device1_int3    : std_logic_vector(dev_w-1 downto 0);

   signal data_out_from_device : std_logic_vector(dev_w-1 downto 0);

  
   signal data_out_from_device_q    : std_logic_vector(dev_w-1 downto 0) ;
   signal data_in_from_pins_int     : std_logic_vector(sys_w-1 downto 0);
   signal data_in_to_device_int     : std_logic_vector(dev_w-1 downto 0);
   signal tristate_predelay         : std_logic_vector(sys_w-1 downto 0);
   signal data_out_to_pins_int      : std_logic_vector(sys_w-1 downto 0);
   signal data_out_to_pins_predelay : std_logic_vector(sys_w-1 downto 0);
   constant clock_enable            : std_logic := '1';

   signal clk_out              : std_logic;
   signal rst_sync      : std_logic;
   signal rst_sync_int  : std_logic;
   signal rst_sync_int1 : std_logic;
   signal rst_sync_int2 : std_logic;
   signal rst_sync_int3 : std_logic;
   signal rst_sync_int4 : std_logic;
   signal rst_sync_int5 : std_logic;
   signal rst_sync_int6 : std_logic;
function or_reduce(slv : std_logic_vector (dev_w-1 downto 0)) return std_logic is
    variable r : std_logic := '0';
begin
    for i in slv'range loop
        r := r or slv(i);
    end loop;
    return r;
end or_reduce;
   signal dummy                  : std_logic;
   signal pattern_completed1     : std_logic_vector(1 downto 0);
   signal pattern_completed_out3 : std_logic_vector(1 downto 0);
   signal clkin1_fast            : std_logic;
   signal clkin1_fast_bufg       : std_logic;
   signal clkin1_fast_ddr        : std_logic;
   signal clkin1_buf             : std_logic;
   signal clkin1_buf_n           : std_logic;

   attribute KEEP : string;



begin

   process (clk_out, IO_RESET) begin
     if (IO_RESET = '1') then
       rst_sync <= '1';
       rst_sync_int <= '1';
       rst_sync_int1 <= '1';
       rst_sync_int2 <= '1';
       rst_sync_int3 <= '1';
       rst_sync_int4 <= '1';
       rst_sync_int5 <= '1';
       rst_sync_int6 <= '1';
     elsif (clk_out = '1' and clk_out'event) then
       rst_sync <= '0';
       rst_sync_int <= rst_sync;
       rst_sync_int1 <= rst_sync_int;
       rst_sync_int2 <= rst_sync_int1;
       rst_sync_int3 <= rst_sync_int2;
       rst_sync_int4 <= rst_sync_int3;
       rst_sync_int5 <= rst_sync_int4;
       rst_sync_int6 <= rst_sync_int5;
     end if;
   end process;






     if (rst_sync_int6 = '1') then
       count_out <= (others => '0');
    else   
     count_out <= count_out + 1;
    end if;
   end if;
  end process;


   


assign:for assg in 0 to num_serial_bits-1 generate begin
pinsss:for pinsss in 0 to sys_w-1 generate begin
   data_out_from_device(pinsss+sys_w*assg) <= count_out(assg);
end generate pinsss;
end generate assign;


   process(clk_out) begin
   if (clk_out='1' and clk_out'event) then
   if (rst_sync_int6 = '1') then
       pattern_completed1 <= "00";
   elsif (and_reduce(data_in_to_device1_int3) = '1') then
     pattern_completed1 <= "11";
   else
     pattern_completed1 <= "00";
   end if;
   end if;
 end process;

   process(clk_out) begin
   if (clk_out='1' and clk_out'event) then
   if (rst_sync_int6 = '1') then
        data_in_to_device1_int2 <= (others => '0');
        data_in_to_device1_int3 <= (others => '0');
     else
        data_in_to_device1_int2 <= data_in_to_device1;
        data_in_to_device1_int3 <= data_in_to_device1_int2;
     end if;
   end if;
 end process;



  dummy <= or_reduce (data_in_to_device2);

   process(clk_out) begin
   if (clk_out='1' and clk_out'event) then
   if (rst_sync_int6 = '1') then
       pattern_completed_out3 <= "00";
     elsif (pattern_completed1(1) = '1') then
      pattern_completed_out3 <= pattern_completed1;
     elsif (dummy = '0') then
      pattern_completed_out3 <= pattern_completed_out3;
     else
      pattern_completed_out3 <= "00";
     end if;
   end if;
 end process;

  PATTERN_COMPLETED_OUT <= pattern_completed_out3;
  



  clkio_buf : IBUFG
     generic map (
       IOSTANDARD => "SSTL15_II")
     port map
      (O => clkin1_buf,
       I => CLK_IN1);

  clkin_buf_inst : BUFG
  port map
   (O => clkin1_fast,
    I => clkin1_buf);





  pins: for pin_count in 0 to sys_w-1 generate
    -- Instantiate the buffers
    ----------------------------------
     iobuf_inst : IOBUF
       generic map (
         IOSTANDARD => "SSTL15_II")
       port map (
         IO         => DATA_TO_AND_FROM_PINS2(pin_count),
         I          => data_out_to_pins_predelay(pin_count),
         O          => data_in_from_pins_int(pin_count),
         T          => tristate_predelay    (pin_count));

    data_in_to_device2        (pin_count) <= data_in_from_pins_int(pin_count);
    data_out_to_pins_predelay (pin_count) <= data_out_from_device   (pin_count);
    tristate_predelay         (pin_count) <= TRISTATE_OUTPUT_INV;
  end generate pins;



   -- Instantiate the IO design
   io_inst : DelayPorts
   port map
   (
    -- Connect to the sytem for inout
    DATA_TO_AND_FROM_PINS   => DATA_TO_AND_FROM_PINS1,
    DATA_IN_TO_DEVICE       => data_in_to_device1,
    -- From the drive out to the system
    DATA_OUT_FROM_DEVICE    => data_out_from_device,


    TRISTATE_OUTPUT         => TRISTATE_OUTPUT,
    CLK_IN                  => CLK_IN,
    CLK_OUT                 => clk_out,
    IO_RESET                => rst_sync_int);
end xilinx;
