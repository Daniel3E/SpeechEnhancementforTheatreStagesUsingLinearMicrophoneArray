LIBRARY ieee;
library work;
USE ieee.std_logic_1164.ALL;
USE work.parameter.ALL;


ENTITY singleregister IS
  PORT (clk: IN STD_LOGIC;
        din: IN STD_LOGIC;
        dout: OUT STD_LOGIC);
END singleregister;

ARCHITECTURE arch_singleregister OF singleregister IS

BEGIN

assign_process:
PROCESS(clk)
BEGIN
  IF RISING_EDGE(clk) THEN
    dout <= din;
  END IF;
END PROCESS assign_process;

END arch_singleregister;