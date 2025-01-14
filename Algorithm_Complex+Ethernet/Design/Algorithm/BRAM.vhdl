-- Simple Dual-Port Block RAM with Two Clocks
-- Correct Modelization with a Shared Variable
-- File: simple_dual_two_clocks.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity simple_dual_two_clocks is
 port(
 clka : in std_logic;
 clkb : in std_logic;
 ena : in std_logic;
 enb : in std_logic;
 wea : in std_logic;
 addra : in std_logic_vector(13 downto 0);
 addrb : in std_logic_vector(13 downto 0);
 dia : in std_logic_vector(15 downto 0);
 dob : out std_logic_vector(15 downto 0)
 );
end simple_dual_two_clocks;

architecture syn of simple_dual_two_clocks is
 type ram_type is array (9999 downto 0) of std_logic_vector(15 downto 0);
 shared variable RAM : ram_type;
begin

 process(clka)
 begin
 -- reading clock is system clk 
 if FALLING_EDGE(clka) then
   if ena = '1' then
     if wea = '1' then
       RAM(conv_integer(addra)) := dia;
     end if;
   end if;
 end if;
 end process;
 
 -- writing clock, fsync
 process(clkb)
 begin
 if RISING_EDGE(clkb) then
   if enb = '1' then
     dob <= RAM(conv_integer(addrb));
   end if;
 end if;
 end process;
 
end syn;