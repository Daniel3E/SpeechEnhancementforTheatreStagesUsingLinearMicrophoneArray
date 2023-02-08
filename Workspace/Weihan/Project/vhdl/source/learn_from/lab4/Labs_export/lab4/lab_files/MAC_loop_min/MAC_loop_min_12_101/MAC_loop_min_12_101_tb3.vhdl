----------------------------------
-- MAC_loop_min_12_101_tb3.vhdl --
-- testbench type 3 for         --
-- multiply/accumulate (MAC)    --
-- direct implementation        --
-- using FOR...LOOP             --
-- 12 bit signal                --
-- 12 bit coefficients          --
-- 101 taps                     --
-- mini version                 --
-- Sven Knutsson                --
----------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL; --****--
USE WORK.vec2str_package.ALL;
USE WORK.MAC_loop_min_12_101_package.ALL;

ENTITY MAC_loop_min_12_101_tb3 IS
   GENERIC(SIGNAL_WIDTH:INTEGER := SIGNAL_WIDTH;
           COEFF_WIDTH:INTEGER := COEFF_WIDTH;
           TAPS:INTEGER := 101);
END MAC_loop_min_12_101_tb3;

ARCHITECTURE arch_MAC_loop_min_12_101_tb3 OF MAC_loop_min_12_101_tb3 IS

   COMPONENT MAC_loop_min_12_101 IS
      GENERIC (SIGNAL_WIDTH:INTEGER := SIGNAL_WIDTH;
               COEFF_WIDTH:INTEGER := COEFF_WIDTH;
               TAPS:NATURAL := TAPS);
      PORT(resetn:STD_LOGIC;
           start:STD_LOGIC;
           clk:STD_LOGIC;
           x:IN STD_LOGIC_VECTOR(SIGNAL_WIDTH-1 DOWNTO 0);
--           y:OUT STD_LOGIC_VECTOR(SIGNAL_WIDTH+COEFF_WIDTH-1 DOWNTO 0));
           y:OUT STD_LOGIC_VECTOR(SIGNAL_WIDTH-1 DOWNTO 0));
   END COMPONENT MAC_loop_min_12_101;

   SIGNAL x_tb_signal:STD_LOGIC_VECTOR(SIGNAL_WIDTH-1 DOWNTO 0);
--   SIGNAL y_tb_signal:STD_LOGIC_VECTOR(SIGNAL_WIDTH+COEFF_WIDTH-1 DOWNTO 0);
   SIGNAL y_tb_signal:STD_LOGIC_VECTOR(SIGNAL_WIDTH-1 DOWNTO 0);
   SIGNAL clk_tb_signal:STD_LOGIC:='0';
   SIGNAL resetn_tb_signal:STD_LOGIC;
   SIGNAL start_tb_signal:STD_LOGIC;
BEGIN
   MAC_loop_min_12_101_inst:
   COMPONENT MAC_loop_min_12_101
         PORT MAP(clk => clk_tb_signal,
                  resetn => resetn_tb_signal,
                  start => start_tb_signal,
                  x => x_tb_signal,
                  y => y_tb_signal);

   reset_proc:
   PROCESS
   BEGIN
      resetn_tb_signal <= '1';   
      WAIT FOR reset_time;   
      resetn_tb_signal <= '0';
      WAIT FOR reset_width;
      resetn_tb_signal <= '1';
      WAIT;
   END PROCESS reset_proc;

  sample_proc:
   PROCESS
   BEGIN
      start_tb_signal <='0';
      WAIT FOR sample_start_time;
      FOR i in 0 TO TAPS LOOP
        start_tb_signal <= '1';
        WAIT FOR sample_pulse_time;
        start_tb_signal <= '0';
        WAIT FOR sample_space_time;
     END LOOP;
  END PROCESS;  

   input_proc:
   PROCESS
   BEGIN
      x_tb_signal <= input_array_constant(0);
      WAIT FOR input_start_time;
      FOR i IN 1 TO TAPS LOOP
	        x_tb_signal <= input_array_constant(i); 
		       WAIT FOR input_loop_time;
      END LOOP;
   END PROCESS input_proc;
   
   clk_proc:
   PROCESS
   BEGIN
      WAIT FOR clk_period_time/2;
      clk_tb_signal <= NOT(clk_tb_signal);
   END PROCESS clk_proc;

   test_proc:
   PROCESS
      FILE test_vector:text open write_mode is "output_file.txt"; --****--
      VARIABLE row:line; --****--
   BEGIN
      WAIT FOR test_start_time;
      FOR i IN 0 TO TAPS-1 LOOP
         ASSERT (y_tb_signal = output_array_constant(i))
         REPORT "the result is "& vec2str(y_tb_signal)&
                             " but it should be "&vec2str(output_array_constant(i))
         SEVERITY ERROR;
         WRITE(row, vec2str(y_tb_signal)&","); --****--
         WRITELINE(test_vector,row); --****--
         WAIT FOR test_loop_time;
      END LOOP; 
   END PROCESS test_proc;
         
END arch_MAC_loop_min_12_101_tb3;