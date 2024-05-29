LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CPU_mc_tb IS
END CPU_mc_tb;
 
ARCHITECTURE behavior OF CPU_mc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU_mc
    PORT(
         PC_rst : IN  std_logic;
         RF_rst : IN  std_logic;
         FSM_rst : IN  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal PC_rst : std_logic := '0';
   signal RF_rst : std_logic := '0';
   signal FSM_rst : std_logic := '0';
   signal clk : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CPU_mc PORT MAP (
          PC_rst => PC_rst,
          RF_rst => RF_rst,
          FSM_rst => FSM_rst,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		PC_rst <= '1';
		RF_rst <= '1';
		FSM_rst <='1';
      wait for 10 ns;	
  
	   PC_rst <= '0';
	  	RF_rst <= '0';
	   FSM_rst <='0';
      wait for clk_period*100;

      -- insert stimulus here 

      wait;
   end process;

END;

