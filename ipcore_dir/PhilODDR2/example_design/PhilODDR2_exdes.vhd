-- file: PhilODDR2_exdes.vhd
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

entity PhilODDR2_exdes is
generic (
  -- width of the data for the system
  sys_w      : integer := 1;
  -- width of the data for the device
  dev_w      : integer := 1
);
port (
  PATTERN_COMPLETED_OUT     : out   std_logic_vector (1 downto 0);
  -- From the system into the device
  DATA_IN_FROM_PINS        : in    std_logic_vector(sys_w-1 downto 0);
  DATA_OUT_TO_PINS         : out   std_logic_vector(sys_w-1 downto 0);
  CLK_TO_PINS_FWD           : out std_logic;

  CLK_IN                   : in    std_logic;
  CLK_IN_FWD               : in    std_logic;
  CLK_RESET                : in    std_logic;
  IO_RESET                 : in    std_logic);
end PhilODDR2_exdes;

architecture xilinx of PhilODDR2_exdes is

component PhilODDR2 is
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
end component;

   constant num_serial_bits  : integer := dev_w/sys_w;
   signal unused             : std_logic;
   signal clkin1             : std_logic;
   signal count_out          : std_logic_vector (sys_w-1 downto 0);
   signal count_out1         : std_logic_vector (sys_w-1 downto 0);
   signal count_out2         : std_logic_vector (sys_w-1 downto 0);
   signal local_counter      : std_logic_vector(num_serial_bits-1 downto 0);
   signal pattern_completed    : std_logic_vector (1 downto 0) := "00";
   signal clk_in_int_inv       : std_logic;
   signal clk_in_int_inv_c     : std_logic;
            -- connection between ram and io circuit
   signal data_in_to_device         : std_logic_vector(dev_w-1 downto 0);
   signal data_in_to_device_int2    : std_logic_vector(dev_w-1 downto 0);
   signal data_in_to_device_int3    : std_logic_vector(dev_w-1 downto 0);

   signal data_out_from_device : std_logic_vector(dev_w-1 downto 0);

  
   signal data_out_from_device_q    : std_logic_vector(dev_w-1 downto 0) ;
   signal data_in_from_pins_int     : std_logic_vector(sys_w-1 downto 0);
   signal data_in_to_device_int     : std_logic_vector(dev_w-1 downto 0);
   signal tristate_predelay         : std_logic_vector(sys_w-1 downto 0);
   signal data_out_to_pins_int      : std_logic_vector(sys_w-1 downto 0);
   signal data_out_to_pins_predelay : std_logic_vector(sys_w-1 downto 0);
   constant clock_enable            : std_logic := '1';

   signal clk_out              : std_logic;
   signal clkfbout             : std_logic;
   signal clkfbout_buf         : std_logic;
   signal clk_in_pll           : std_logic;
   signal clk_in_pll1          : std_logic;
   signal locked_in            : std_logic;
   signal locked_out           : std_logic;
   signal clk_fwd_out          : std_logic;
   signal clk_fwd_int          : std_logic;
   signal rst_sync      : std_logic;
   signal rst_sync_int  : std_logic;
   signal rst_sync_int1 : std_logic;
   signal rst_sync_int2 : std_logic;
   signal rst_sync_int3 : std_logic;
   signal rst_sync_int4 : std_logic;
   signal rst_sync_int5 : std_logic;
   signal rst_sync_int6 : std_logic;

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



   clkin_in_buf : IBUFG
   port map
     (O => clkin1,
      I => CLK_IN);

   -- set up the fabric PLL_BASE to drive the BUFPLL
   pll_base_inst : PLL_BASE
    generic map (
      BANDWIDTH             => "OPTIMIZED",
      CLK_FEEDBACK          => "CLKFBOUT",
      COMPENSATION          => "SYSTEM_SYNCHRONOUS",
      DIVCLK_DIVIDE         => 1,
      CLKFBOUT_MULT         => 4,
      CLKFBOUT_PHASE        => 0.000,
      CLKOUT0_DIVIDE        => 4,
      CLKOUT0_PHASE         => 0.000,
      CLKOUT0_DUTY_CYCLE    => 0.500,
      CLKIN_PERIOD          => 10.0,
      REF_JITTER            => 0.010)
   port map (
     -- Output clocks
      CLKFBOUT              => clkfbout,
      CLKOUT0               => clk_in_pll1,
      CLKOUT1               => open,
      CLKOUT2               => open,
      CLKOUT3               => open,
      CLKOUT4               => open,
      CLKOUT5               => open,
      -- Status and control signals
      LOCKED                => locked_in,
      RST                   => CLK_RESET,
      -- Input clock control
      CLKFBIN               => clkfbout_buf,
      CLKIN                 => clkin1);

   clkfb_buf : BUFG
    port map (
      O            => clkfbout_buf,
      I            => clkfbout);



   clko_buf : BUFG
    port map (
      O            => clk_in_pll,
      I            => clk_in_pll1);




   process(clk_out) begin
   if (clk_out='1' and clk_out'event) then
     if (rst_sync_int6 = '1') then
       count_out <= (others => '0');
     elsif locked_in='1' then  
     count_out <= count_out + 1;
    end if;
   end if;
  end process;


   


   process(clk_out) begin
   if (clk_out='1' and clk_out'event) then
     if (rst_sync_int6 = '1') then
       count_out1 <= (others => '0');
       count_out2 <= (others => '0');
     else
       count_out1 <= count_out;
       count_out2 <= count_out1;
     end if;
    end if;
   end process;

   data_out_from_device <= count_out2;


   process(clk_in_pll) begin
   if (clk_in_pll='1' and clk_in_pll'event) then
   if (rst_sync_int6 = '1') then
       pattern_completed <= "00";
   elsif (and_reduce(data_in_to_device_int3) = '1') then
     pattern_completed <= "11";
   else
     pattern_completed <= "00";
   end if;
   end if;
 end process;

   process(clk_in_pll) begin
   if (clk_in_pll='1' and clk_in_pll'event) then
   if (rst_sync_int6 = '1') then
        data_in_to_device_int2 <= (others => '0');
        data_in_to_device_int3 <= (others => '0');
     else
        data_in_to_device_int2 <= data_in_to_device;
        data_in_to_device_int3 <= data_in_to_device_int2;
     end if;

   end if;
 end process;




 
   PATTERN_COMPLETED_OUT <= pattern_completed;
  







  pins: for pin_count in 0 to sys_w-1 generate
   attribute IOB : string;
   attribute IOB of fdre_in_inst  : label is "true";
   begin
    -- Instantiate the buffers
    ----------------------------------
     ibuf_inst : IBUF
       generic map (
         IOSTANDARD => "LVCMOS33")
       port map (     
         I          => DATA_IN_FROM_PINS    (pin_count),
         O          => data_in_from_pins_int(pin_count));

    fdre_in_inst : FDRE
      port map
       (D             => data_in_from_pins_int(pin_count),
        C             => clk_in_pll,
        CE            => clock_enable,
        R             => IO_RESET,
        Q             => data_in_to_device(pin_count));
  end generate pins;

    clk_in_int_inv_c <= not(clk_in_pll);
    oddr2_clk_inst : ODDR2
      generic map (
        DDR_ALIGNMENT  => "C0",
        INIT           => '0',
        SRTYPE         => "ASYNC")
      port map
       (D0             => '1',
        D1             => '0',
        C0             => clk_in_pll,
        C1             => clk_in_int_inv_c,
        CE             => locked_in,
        Q              => clk_fwd_out,
        R              => CLK_RESET,
        S              => '0');

         obuf_clk_inst : OBUF
           generic map (
             IOSTANDARD => "LVCMOS33")
           port map (
             O          => CLK_TO_PINS_FWD,
             I          => clk_fwd_out);

   -- Instantiate the IO design
   io_inst : PhilODDR2
   port map
   (
    -- From the drive out to the system
    DATA_OUT_FROM_DEVICE    => data_out_from_device,
    DATA_OUT_TO_PINS        => DATA_OUT_TO_PINS,


    CLK_IN                  => CLK_IN_FWD,
    CLK_OUT                 => clk_out,
    IO_RESET                => rst_sync_int);
end xilinx;
