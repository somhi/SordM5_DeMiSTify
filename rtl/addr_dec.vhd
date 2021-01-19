--//============================================================================
--//  Sord M5
--//  Address decoder
--//  Copyright (C) 2021 molekula
--//
--//  This program is free software; you can redistribute it and/or modify it
--//  under the terms of the GNU General Public License as published by the Free
--//  Software Foundation; either version 2 of the License, or (at your option)
--//  any later version.
--//
--//  This program is distributed in the hope that it will be useful, but WITHOUT
--//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
--//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
--//  more details.
--//
--//  You should have received a copy of the GNU General Public License along
--//  with this program; if not, write to the Free Software Foundation, Inc.,
--//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
--//
--//============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity addr_dec is

  port (
    clk_i           : in  std_logic;
    reset_n_i       : in  std_logic;
    a_i             : in  std_logic_vector(15 downto 0);
    d_i             : in  std_logic_vector(7 downto 0);
    iorq_n_i        : in  std_logic;
    m1_n_i          : in  std_logic;
    rd_n_i          : in  std_logic;
    wr_n_i          : in  std_logic;
    mreq_n_i        : in  std_logic;
    rfsh_n_i        : in  std_logic;
    bios_ce_n_o     : out std_logic;
    rom_ce_n_o      : out std_logic;
    ram1_ce_n_o     : out std_logic;
	 ram2_ce_n_o     : out std_logic;
    vdp_r_n_o       : out std_logic;
    vdp_w_n_o       : out std_logic;
    psg_we_n_o      : out std_logic;
    kb_ce_n_o       : out std_logic;
    cas_ce_n_o      : out std_logic;
    ctc_ce_n_o      : out std_logic;
    int_vect_ce_n_o : out std_logic
  );

end addr_dec;


architecture rtl of addr_dec is
     signal io_s : boolean;
     signal mem_s : boolean;
begin
  io_s  <= iorq_n_i = '0' and m1_n_i = '1';
  mem_s <= mreq_n_i = '0' and rfsh_n_i = '1';
  
  -- MEM
  bios_ce_n_o     <= '0' when mem_s AND a_i(15 downto 13) = "000"   else '1';   -- 0000 - 1FFF
  rom_ce_n_o      <= '0' when mem_s AND a_i(15 downto 13) = "001"   else '1';   -- 2000 - 3FFF
  ram1_ce_n_o     <= '0' when mem_s AND a_i(15 downto 13) = "011"   else '1';   -- 6000 - 7FFF
  ram2_ce_n_o     <= '0' when mem_s AND a_i(15) = '1'               else '1';   -- 8000 - FFFF

  -- IO
  vdp_r_n_o       <= '0' when io_s and a_i(7 downto 4) = "0001"     AND rd_n_i = '0' else '1' ;    -- VDP rd
  vdp_w_n_o       <= '0' when io_s and a_i(7 downto 4) = "0001"     AND wr_n_i = '0' else '1' ;    -- VDP wr
  kb_ce_n_o       <= '0' when io_s and a_i(7 downto 4) = "0011"     AND rd_n_i = '0' else '1' ;    -- KB rd
  cas_ce_n_o      <= '0' when io_s and a_i(7 downto 4) = "0101"     AND rd_n_i = '0' else '1' ;    -- CAS rd
  ctc_ce_n_o      <= '0' when io_s and a_i(7 downto 4) = "0000"                      else '1' ;    -- CTC rd
  psg_we_n_o      <= '0' when io_s and a_i(7 downto 0) = "00100000" AND wr_n_i = '0' else '1' ;    -- SGC wr
  -- INT
  int_vect_ce_n_o <= '0' when m1_n_i='0' and iorq_n_i='0' else '1'; 

end rtl;
