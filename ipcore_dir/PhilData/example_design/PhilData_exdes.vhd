-- file: PhilData_exdes.vhd
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

entity PhilData_exdes is
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
end PhilData_exdes;

architecture xilinx of PhilData_exdes is

component PhilData is
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

   constant num_serial_bits  : integer := dev_w/sys_w;
   signal unused             : std_logic;
   signal clkin1             : std_logic;
   signal count_out          : std_logic_vector (num_serial_bits-1 downto 0);
   signal local_counter      : std_logic_vector(num_serial_bits-1 downto 0);
   signal pattern_completed    : std_logic_vector (1 downto 0) := "00";
   signal clk_in_int_inv       : std_logic;
   signal clk_div_int               : std_logic;
   signal clk_in_int_buf            : std_logic;
   -- This example design doesn't use the variable delay programming
   signal delay_busy           : std_logic;
   signal delay_clk            : std_logic := '0';
   signal delay_data_cal       : std_logic := '0';
   signal delay_data_ce        : std_logic := '0';
   signal delay_reset          : std_logic := '0';
   signal delay_data_inc       : std_logic := '0';
   signal delay_tap_in         : std_logic_vector (4 downto 0) := "00000";
            -- connection between ram and io circuit
   signal data_in_to_device1         : std_logic_vector(dev_w-1 downto 0);
   signal data_in_to_device2         : std_logic_vector(dev_w-1 downto 0);
   signal data_in_to_device1_int2    : std_logic_vector(dev_w-1 downto 0);
   signal data_in_to_device1_int3    : std_logic_vector(dev_w-1 downto 0);

   signal data_out_from_device : std_logic_vector(dev_w-1 downto 0);

    type serdarr is array (0 to 7) of std_logic_vector(sys_w-1 downto 0);
   signal oserdes_d                : serdarr := (( others => (others => '0')));
   signal ocascade_ms_d            : std_logic_vector(sys_w-1 downto 0);
   signal ocascade_ms_t            : std_logic_vector(sys_w-1 downto 0);
   signal ocascade_sm_d            : std_logic_vector(sys_w-1 downto 0);
   signal ocascade_sm_t            : std_logic_vector(sys_w-1 downto 0);
   signal serdesstrobe             : std_logic;
   signal iserdes_q                : serdarr := (( others => (others => '0')));
   signal icascade                 : std_logic_vector(sys_w-1 downto 0);

   signal data_out_from_device_q    : std_logic_vector(dev_w-1 downto 0) ;
   signal data_in_from_pins_int     : std_logic_vector(sys_w-1 downto 0);
   signal data_in_to_device_int     : std_logic_vector(dev_w-1 downto 0);
   signal tristate_predelay         : std_logic_vector(sys_w-1 downto 0);
   signal data_out_to_pins_int      : std_logic_vector(sys_w-1 downto 0);
   signal data_out_to_pins_predelay : std_logic_vector(sys_w-1 downto 0);
   constant clock_enable            : std_logic := '1';

   signal clk_div_out          : std_logic;
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
   signal clk_div                : std_logic;
   signal clk_div1               : std_logic;

   attribute KEEP : string;
   attribute KEEP of clk_div_out : signal is "TRUE";



begin

   process (clk_div_out, IO_RESET) begin
     if (IO_RESET = '1') then
       rst_sync <= '1';
       rst_sync_int <= '1';
       rst_sync_int1 <= '1';
       rst_sync_int2 <= '1';
       rst_sync_int3 <= '1';
       rst_sync_int4 <= '1';
       rst_sync_int5 <= '1';
       rst_sync_int6 <= '1';
     elsif (clk_div_out = '1' and clk_div_out'event) then
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


   delay_clk <= clk_div_out;




   process(clk_div_out) begin
   if (clk_div_out='1' and clk_div_out'event) then
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


   process(clk_div_out) begin
   if (clk_div_out='1' and clk_div_out'event) then
   if (rst_sync_int6 = '1') then
       pattern_completed1 <= "00";
   elsif (and_reduce(data_in_to_device1_int3) = '1') then
     pattern_completed1 <= "11";
   else
     pattern_completed1 <= "00";
   end if;
   end if;
 end process;

   process(clk_div_out) begin
   if (clk_div_out='1' and clk_div_out'event) then
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

   process(clk_div_out) begin
   if (clk_div_out='1' and clk_div_out'event) then
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
  



  ibufg_clk_inst : IBUFG
     generic map (
       IOSTANDARD => "SSTL15_II")
     port map
      (O  => clkin1_buf,
       OB => clkin1_buf_n,
       I => CLK_IN1);

  bufio2_inst : BUFIO2_2CLK
    generic map (
      DIVIDE        => 8)
    port map (
      DIVCLK       => clk_div1,
      IOCLK        => clk_in_int_buf,
      SERDESSTROBE => serdesstrobe,
      I            => clkin1_buf,
      IB           => clkin1_buf_n);
  clk_in_int_inv <= not (clkin1_buf);

  clkg_buf : BUFG
    port map
      (O => clk_div,
       I => clk_div1);






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

     -- Instantiate the serdes primitive
     ----------------------------------
     -- declare the iserdes
     iserdes2_master : ISERDES2
       generic map (
         BITSLIP_ENABLE =>  TRUE,
         DATA_RATE      => "SDR",
         DATA_WIDTH     => 8,
         INTERFACE_TYPE => "RETIMED",
         SERDES_MODE    => "MASTER")
       port map (
         Q1         => iserdes_q(3)(pin_count),
         Q2         => iserdes_q(2)(pin_count),
         Q3         => iserdes_q(1)(pin_count),
         Q4         => iserdes_q(0)(pin_count),
         SHIFTOUT   => icascade(pin_count),
         INCDEC     => open,
         VALID      => open,
         BITSLIP    => '0',
         CE0        => clock_enable,   -- 1-bit Clock enable input
         CLK0       => clk_in_int_buf, -- 1-bit IO Clock network input. Optionally Invertible. This is the primary clock
                                       -- input used when the clock doubler circuit is not engaged (see DATA_RATE
                                       -- attribute).
         CLK1       => '0',
         CLKDIV            => clk_div,
         D          => data_in_from_pins_int(pin_count), -- 1-bit Input signal from IOB.
         IOCE       => serdesstrobe,                       -- 1-bit Data strobe signal derived from BUFIO CE. Strobes data capture for
                                                          -- NETWORKING and NETWORKING_PIPELINES alignment modes.

         RST        => IO_RESET,        -- 1-bit Asynchronous reset only.
         SHIFTIN    => '0',


        -- unused connections
         FABRICOUT  => open,
         CFB0       => open,
         CFB1       => open,
         DFB        => open);

     iserdes2_slave : ISERDES2
       generic map (
         BITSLIP_ENABLE => TRUE,
         DATA_RATE      => "SDR",
         DATA_WIDTH     => 8,
         INTERFACE_TYPE => "RETIMED",
         SERDES_MODE    => "SLAVE")
       port map (
        Q1         => iserdes_q(7)(pin_count),
        Q2         => iserdes_q(6)(pin_count),
        Q3         => iserdes_q(5)(pin_count),
        Q4         => iserdes_q(4)(pin_count),
        SHIFTOUT   => open,
        INCDEC     => open,
        VALID      => open,
         BITSLIP    => '0',
        CE0        => clock_enable,   -- 1-bit Clock enable input
        CLK0       => clk_in_int_buf, -- 1-bit IO Clock network input. Optionally Invertible. This is the primary clock
                                      -- input used when the clock doubler circuit is not engaged (see DATA_RATE
                                      -- attribute).
        CLK1       => '0',
         CLKDIV            => clk_div,
        D          => '0',            -- 1-bit Input signal from IOB.
        IOCE       => serdesstrobe,   -- 1-bit Data strobe signal derived from BUFIO CE. Strobes data capture for
                                      -- NETWORKING and NETWORKING_PIPELINES alignment modes.

        RST        => IO_RESET,       -- 1-bit Asynchronous reset only.
        SHIFTIN    => icascade(pin_count),
        -- unused connections
        FABRICOUT  => open,
        CFB0       => open,
        CFB1       => open,
        DFB        => open);


     -- declare the oserdes
     oserdes2_master : OSERDES2
       generic map (
         DATA_RATE_OQ   => "SDR",
         DATA_RATE_OT   => "SDR",
         TRAIN_PATTERN  => 0,
         DATA_WIDTH     => 8,
         SERDES_MODE    => "MASTER",
         OUTPUT_MODE    => "SINGLE_ENDED")
       port map (
        D1         => oserdes_d(3)(pin_count),
        D2         => oserdes_d(2)(pin_count),
        D3         => oserdes_d(1)(pin_count),
        D4         => oserdes_d(0)(pin_count),
        T1         => TRISTATE_OUTPUT_INV,
        T2         => TRISTATE_OUTPUT_INV,
        T3         => TRISTATE_OUTPUT_INV,
        T4         => TRISTATE_OUTPUT_INV,
        SHIFTIN1   => '1',
        SHIFTIN2   => '1',
        SHIFTIN3   => ocascade_sm_d(pin_count),
        SHIFTIN4   => ocascade_sm_t(pin_count),
        SHIFTOUT1  => ocascade_ms_d(pin_count),
        SHIFTOUT2  => ocascade_ms_t(pin_count),
        SHIFTOUT3  => open,
        SHIFTOUT4  => open,
        TRAIN      => '0',
        OCE        => clock_enable,
        CLK0       => clk_in_int_buf,
        CLK1       => '0',
        CLKDIV     => clk_div,
        OQ         => data_out_to_pins_predelay(pin_count),
        TQ         => tristate_predelay(pin_count),
        IOCE       => serdesstrobe,
        TCE        => clock_enable,
        RST        => IO_RESET);


     oserdes2_slave : OSERDES2
       generic map (
         DATA_RATE_OQ   => "SDR",
         DATA_RATE_OT   => "SDR",
         DATA_WIDTH     => 8,
         SERDES_MODE    => "SLAVE",
         TRAIN_PATTERN  => 0,
         OUTPUT_MODE    => "SINGLE_ENDED")
       port map (
        D1         => oserdes_d(7)(pin_count),
        D2         => oserdes_d(6)(pin_count),
        D3         => oserdes_d(5)(pin_count),
        D4         => oserdes_d(4)(pin_count),
        T1         => TRISTATE_OUTPUT_INV,
        T2         => TRISTATE_OUTPUT_INV,
        T3         => TRISTATE_OUTPUT_INV,
        T4         => TRISTATE_OUTPUT_INV,
        SHIFTIN1   => ocascade_ms_d(pin_count),
        SHIFTIN2   => ocascade_ms_t(pin_count),
        SHIFTIN3   => '1',
        SHIFTIN4   => '1',
        SHIFTOUT1  => open,
        SHIFTOUT2  => open,
        SHIFTOUT3  => ocascade_sm_d(pin_count),
        SHIFTOUT4  => ocascade_sm_t(pin_count),
        TRAIN      => '0',
        OCE        => clock_enable,
        CLK0       => clk_in_int_buf,
        CLK1       => '0',
        CLKDIV     => clk_div,
        OQ         => open,
        TQ         => open,
        IOCE       => serdesstrobe,
        TCE        => clock_enable,
        RST        => IO_RESET);



     -- Concatenate the serdes outputs together. Keep the timesliced
     --   bits together, and placing the earliest bits on the right
     --   ie, if data comes in 0, 1, 2, 3, 4, 5, 6, 7, ...
     --       the output will be 3210, 7654, ...
     -------------------------------------------------------------
     in_slices: for slice_count in 0 to num_serial_bits-1 generate begin
        -- This places the first data in time on the right
        data_in_to_device2(slice_count) <=
          iserdes_q(num_serial_bits-slice_count-1)(0);
        -- To place the first data in time on the left, use the
        --   following code, instead
        -- data_in_to_device2(slice_count) <=
        --   iserdes_q(slice_count);
     end generate in_slices;
    out_slices: for slice_count in 0 to num_serial_bits-1 generate begin
        -- This places the first data in time on the right
        oserdes_d(8-slice_count-1)(0) <=
           data_out_from_device(slice_count);
        -- To place the first data in time on the left, use the
        --   following code, instead
        -- oserdes_d(slice_count) <=
        --    data_out_from_device(slice_count);
     end generate out_slices;
  end generate pins;



   -- Instantiate the IO design
   io_inst : PhilData
   port map
   (
    -- Connect to the sytem for inout
    DATA_TO_AND_FROM_PINS   => DATA_TO_AND_FROM_PINS1,
    DATA_IN_TO_DEVICE       => data_in_to_device1,
    -- From the drive out to the system
    DATA_OUT_FROM_DEVICE    => data_out_from_device,
    CLK_TO_PINS             => CLK_TO_PINS,

    DELAY_BUSY              => delay_busy,
    DELAY_CLK               => delay_clk,
    DELAY_DATA_CAL            => '0',
    DELAY_DATA_CE             => '0',
    DELAY_DATA_INC            => '0',

    TRISTATE_OUTPUT         => TRISTATE_OUTPUT,
    CLK_IN_P                => CLK_IN_P,
    CLK_IN_N                => CLK_IN_N,
    CLK_DIV_OUT             => clk_div_out,
    CLK_RESET               => CLK_RESET,
    IO_RESET                => rst_sync_int);
end xilinx;
