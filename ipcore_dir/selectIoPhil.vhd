-- file: selectIoPhil.vhd
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
-- User entered comments
------------------------------------------------------------------------------
-- None
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity selectIoPhil is
generic
 (-- width of the data for the system
  sys_w       : integer := 1;
  -- width of the data for the device
  dev_w       : integer := 1);
port
 (
  -- From the device out to the system
  DATA_OUT_FROM_DEVICE    : in    std_logic_vector(dev_w-1 downto 0);
  DATA_OUT_TO_PINS        : out   std_logic_vector(sys_w-1 downto 0);

-- Clock and reset signals
  CLK_IN                  : in    std_logic;                    -- Single ended Fast clock from IOB
  CLK_OUT                 : out   std_logic;
  IO_RESET                : in    std_logic);                   -- Reset signal for IO circuit
end selectIoPhil;

architecture xilinx of selectIoPhil is
  attribute CORE_GENERATION_INFO            : string;
  attribute CORE_GENERATION_INFO of xilinx  : architecture is "selectIoPhil,selectio_wiz_v4_1,{component_name=selectIoPhil,bus_dir=OUTPUTS,bus_sig_type=SINGLE,bus_io_std=LVCMOS33,use_serialization=false,use_phase_detector=false,serialization_factor=4,enable_bitslip=false,enable_train=false,system_data_width=1,bus_in_delay=NONE,bus_out_delay=NONE,clk_sig_type=SINGLE,clk_io_std=LVCMOS33,clk_buf=BUFG,active_edge=RISING,clk_delay=NONE,v6_bus_in_delay=NONE,v6_bus_out_delay=NONE,v6_clk_buf=BUFIO,v6_active_edge=NOT_APP,v6_ddr_alignment=SAME_EDGE_PIPELINED,v6_oddr_alignment=SAME_EDGE,ddr_alignment=C0,v6_interface_type=NETWORKING,interface_type=NETWORKING,v6_bus_in_tap=0,v6_bus_out_tap=0,v6_clk_io_std=LVCMOS18,v6_clk_sig_type=SINGLE}";
  constant clock_enable            : std_logic := '1';
  signal unused : std_logic;
  signal clk_in_int                : std_logic;
  signal clk_in_int_buf            : std_logic;


  -- Before the buffer
  signal data_out_to_pins_int      : std_logic_vector(sys_w-1 downto 0);
  -- Between the delay and serdes
  signal data_out_to_pins_predelay : std_logic_vector(sys_w-1 downto 0);
  signal data_out_from_device_q    : std_logic_vector(dev_w-1 downto 0) ;


begin




  -- Create the clock logic
  ibufg_clk_inst : IBUFG
    generic map (
      IOSTANDARD => "LVCMOS33")
    port map (
      I          => CLK_IN,
      O          => clk_in_int);

   clkin_buf_inst : BUFG
     port map (
       O => clk_in_int_buf,
       I => clk_in_int);


   -- Forward the buffered version of the input clock
   CLK_OUT <= clk_in_int_buf;
  
  -- We have multiple bits- step over every bit, instantiating the required elements
  pins: for pin_count in 0 to sys_w-1 generate
   attribute IOB : string;
   attribute IOB of fdre_out_inst : label is "true";
  begin
    -- Instantiate the buffers
    ----------------------------------
    -- Instantiate a buffer for every bit of the data bus
     obuf_inst : OBUF
       generic map (
         IOSTANDARD => "LVCMOS33")
       port map (
         O          => DATA_OUT_TO_PINS    (pin_count),
         I          => data_out_to_pins_int(pin_count));


    -- Pass through the delay
    -----------------------------------
   data_out_to_pins_int(pin_count)    <= data_out_to_pins_predelay(pin_count);

    -- Connect the delayed data to the fabric
    ------------------------------------------

    -- Pack the registers into the IOB
    fdre_out_inst : FDRE
      port map
       (D             => DATA_OUT_FROM_DEVICE(pin_count),
        C             => clk_in_int_buf,
        CE            => clock_enable,
        R             => IO_RESET,
        Q             => data_out_from_device_q(pin_count));
     data_out_to_pins_predelay(pin_count) <= data_out_from_device_q(pin_count);

  end generate pins;





end xilinx;



