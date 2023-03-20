LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY singleregister IS
  GENERIC(SIGNAL_WIDTH : INTEGER := 16);
  PORT (clk: IN STD_LOGIC;
        din: IN STD_LOGIC_VECTOR(SIGNAL_WIDTH-1 DOWNTO 0);
        dout: OUT STD_LOGIC_VECTOR(SIGNAL_WIDTH-1 DOWNTO 0));
END singleregister;

ARCHITECTURE arch_singleregister OF singleregister IS

BEGIN

assign_process:
PROCESS(clk)
BEGIN
  IF FALLING_EDGE(clk) THEN
    dout <= din;
  END IF;
END PROCESS assign_process;

END arch_singleregister;