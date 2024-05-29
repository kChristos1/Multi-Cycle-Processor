LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY DATAPATH_mc_tb IS
END DATAPATH_mc_tb;
 
ARCHITECTURE behavior OF DATAPATH_mc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DATAPATH_mc
    PORT(
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         RF_B_sel : IN  std_logic;
         RF_WrData_sel : IN  std_logic;
         ALU_Bin_sel : IN  std_logic;
         ALU_func : IN  std_logic_vector(3 downto 0);
         MEM_WrEn : IN  std_logic_vector(0 downto 0);
         RF_WrEn : IN  std_logic;
         Sel_immed : IN  std_logic_vector(1 downto 0);
         Reset_regs : IN  std_logic;
         PC_reset : IN  std_logic;
         Clk : IN  std_logic;
         Instr_regEn : IN  std_logic;
         RF_A_En : IN  std_logic;
         RF_B_En : IN  std_logic;
         Immed_En : IN  std_logic;
         ALUout_En : IN  std_logic;
         MEM_En : IN  std_logic;
         Instr_reset : IN  std_logic;
         RF_A_reset : IN  std_logic;
         RF_B_reset : IN  std_logic;
         Immed_reset : IN  std_logic;
         ALUout_reset : IN  std_logic;
         MEM_reset : IN  std_logic;
         Instr : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal RF_WrData_sel : std_logic := '0';
   signal ALU_Bin_sel : std_logic := '0';
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');
   signal MEM_WrEn : std_logic_vector(0 downto 0) := (others => '0');
   signal RF_WrEn : std_logic := '0';
   signal Sel_immed : std_logic_vector(1 downto 0) := (others => '0');
   signal Reset_regs : std_logic := '0';
   signal PC_reset : std_logic := '0';
   signal Clk : std_logic := '0';
   signal Instr_regEn : std_logic := '0';
   signal RF_A_En : std_logic := '0';
   signal RF_B_En : std_logic := '0';
   signal Immed_En : std_logic := '0';
   signal ALUout_En : std_logic := '0';
   signal MEM_En : std_logic := '0';
   signal Instr_reset : std_logic := '0';
   signal RF_A_reset : std_logic := '0';
   signal RF_B_reset : std_logic := '0';
   signal Immed_reset : std_logic := '0';
   signal ALUout_reset : std_logic := '0';
   signal MEM_reset : std_logic := '0';

 	--Outputs-
   signal Instr : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DATAPATH_mc PORT MAP (
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          RF_B_sel => RF_B_sel,
          RF_WrData_sel => RF_WrData_sel,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,
          MEM_WrEn => MEM_WrEn,
          RF_WrEn => RF_WrEn,
          Sel_immed => Sel_immed,
          Reset_regs => Reset_regs,
          PC_reset => PC_reset,
          Clk => Clk,
          Instr_regEn => Instr_regEn,
          RF_A_En => RF_A_En,
          RF_B_En => RF_B_En,
          Immed_En => Immed_En,
          ALUout_En => ALUout_En,
          MEM_En => MEM_En,
          Instr_reset => Instr_reset,
          RF_A_reset => RF_A_reset,
          RF_B_reset => RF_B_reset,
          Immed_reset => Immed_reset,
          ALUout_reset => ALUout_reset,
          MEM_reset => MEM_reset,
          Instr => Instr
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: PROCESS
	BEGIN
      -- hold reset
		PC_reset   <= '1';
		Reset_regs <= '1';
		WAIT FOR Clk_period;

		-- testing
		PC_reset      <= '0';
		Reset_regs    <= '0';

		--we start by testing the li instruction 
		--li takes 4 clock cycles in total 
		--in every cycle the "CONTROL_mc" FSM, 
		--will generate the needed control signals 
		--li r1, 6:
		
		--IFSTAGE (1st clock period)
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		------------------------
		Instr_regEn        <= '1';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 
		
		--DECSTAGE (2nd clock period)
		RF_B_sel      <= '1'; 
		RF_WrEn       <= '0';
		RF_WrData_sel <= 'U';
		PC_LdEn       <= '0';
		MEM_WrEn      <= "0";
		ALU_Bin_sel   <= 'U';
		ALU_func      <= "UUUU";
		Sel_immed     <= "01";
		-----------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '1';
		RF_B_En         <= '1';
		Immed_En        <= '1';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period;
		
		--EXECSTAGE (3rd clock period) 
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= '1';
		ALU_func         <= "0000";
		Sel_immed        <= "UU";
	   -----------------------
		Instr_regEn     <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '1';
		MEM_En          <= '0';
		WAIT FOR Clk_period;
		
		--WRITE BACK (4th -last- clock period)
		RF_B_sel         <= 'U';
		RF_WrEn          <= '1';
		RF_WrData_sel    <= '0';
		PC_LdEn          <= '1';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		-------------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 
	
		--li again.. (see .coe file)
				--IFSTAGE (1st clock period)
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		------------------------
		Instr_regEn     <= '1';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 
		
		--DECSTAGE (2nd clock period)
		RF_B_sel      <= '1'; 
		RF_WrEn       <= '0';
		RF_WrData_sel <= 'U';
		PC_LdEn       <= '0';
		MEM_WrEn      <= "0";
		ALU_Bin_sel   <= 'U';
		ALU_func      <= "UUUU";
		Sel_immed     <= "01";
		-----------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '1';
		RF_B_En         <= '1';
		Immed_En        <= '1';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period;
		
		--EXECSTAGE (3rd clock period) 
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= '1';
		ALU_func         <= "0000";
		Sel_immed        <= "UU";
	   -----------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '1';
		MEM_En          <= '0';

		WAIT FOR Clk_period;
		
		--WRITE BACK (4th -last- clock period)
		RF_B_sel         <= 'U';
		RF_WrEn          <= '1';
		RF_WrData_sel    <= '0';
		PC_LdEn          <= '1';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		-------------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 
		-----------------------------------------------------------------------------------
		
		--now lets test an add instruction
		--it takes 4 cycles in total
		
		--add r1, r3, r2: (r3=r1+r2)
	
	   --IFSTAGE (1st clock period same for all instructions)
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		------------------------
		Instr_regEn        <= '1';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 
		
		--DECSTAGE (2nd clock period)
		RF_B_sel      <= '0'; --Rtype
		RF_WrEn       <= '0';
		RF_WrData_sel <= 'U';
		PC_LdEn       <= '0';
		MEM_WrEn      <= "0";
		ALU_Bin_sel   <= 'U';
		ALU_func      <= "UUUU";
		Sel_immed     <= "UU"; --Rtype
		-----------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '1';
		RF_B_En         <= '1';
		Immed_En        <= '1';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period;
		
		
		--EXEC
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= '0';
		ALU_func         <= "0000"; --addition
		Sel_immed        <= "UU";
		------------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '1';
		MEM_En          <= '0';
		
		--WRITE BACK 
		RF_B_sel         <= 'U';
		RF_WrEn          <= '1';
		RF_WrData_sel    <= '0';
		PC_LdEn          <= '1';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		-------------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		
		------------------------------------------------------------------------------------
		
		--now lets test a branch instruction 
		--it takes 3 cycles in total 
		--bne r1, r2, 0
		
		--IFSTAGE (1st clock period same for all instructions)
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		------------------------
		Instr_regEn        <= '1';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		
		--DECSTAGE
		RF_B_sel      <= '1';
		RF_WrEn       <= '0';
		RF_WrData_sel <= 'U';
		PC_LdEn       <= '0';
		MEM_WrEn      <= "0";
		ALU_Bin_sel   <= 'U';
		ALU_func      <= "UUUU";			
		Sel_immed     <= "10";		
      ------------------------		
		Instr_regEn        <= '0';
		RF_A_En         <= '1';
		RF_B_En         <= '1';
		Immed_En        <= '1';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		
		
		--EXEC
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '1';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= '0';
		ALU_func         <= "0001";
		Sel_immed        <= "UU";
		--------------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '1';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 
		
		
		------------------------------------------------------------------------------
		--beq r1, r2, 0
		--IFSTAGE (1st clock period same for all instructions)
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		------------------------
		Instr_regEn        <= '1';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period;
		
		--DECSTAGE
		RF_B_sel      <= '1';
		RF_WrEn       <= '0';
		RF_WrData_sel <= 'U';
		PC_LdEn       <= '0';
		MEM_WrEn      <= "0";
		ALU_Bin_sel   <= 'U';
		ALU_func      <= "UUUU";			
		Sel_immed     <= "10";		
      ------------------------		
		Instr_regEn        <= '0';
		RF_A_En         <= '1';
		RF_B_En         <= '1';
		Immed_En        <= '1';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 

		
		--EXEC
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '1';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= '0';
		ALU_func         <= "0001";
		Sel_immed        <= "UU";
		--------------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '1';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 
		
		--------------------------------------------------------------------------------------
		-- load upper immediate 
		--lui r8, 4
		--IFSTAGE : 
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		------------------------
		Instr_regEn        <= '1';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period;
		
		--DECSTAGE
		RF_B_sel      <= '1';
		RF_WrEn       <= '0';
		RF_WrData_sel <= 'U';
		PC_LdEn       <= '0';
		MEM_WrEn      <= "0";
		ALU_Bin_sel   <= 'U';
		ALU_func      <= "UUUU";			
		Sel_immed     <= "10";		
      ------------------------		
		Instr_regEn        <= '0';
		RF_A_En         <= '1';
		RF_B_En         <= '1';
		Immed_En        <= '1';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 
	

    	--EXECSTAGE (same as li) 
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= '1';
		ALU_func         <= "0000";
		Sel_immed        <= "UU";
	   -----------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '1';
		MEM_En          <= '0';
		WAIT FOR Clk_period;
		
		--WRITEBACK 
		RF_B_sel         <= 'U';
		RF_WrEn          <= '1';
		RF_WrData_sel    <= '0';
		PC_LdEn          <= '1';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		----------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 
		
		
		-------------------------------------------------
		--lui r10, 16
		--IFSTAGE : 
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		------------------------
		Instr_regEn        <= '1';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period;
		
		--DECSTAGE
		RF_B_sel      <= '1';
		RF_WrEn       <= '0';
		RF_WrData_sel <= 'U';
		PC_LdEn       <= '0';
		MEM_WrEn      <= "0";
		ALU_Bin_sel   <= 'U';
		ALU_func      <= "UUUU";			
		Sel_immed     <= "10";		
      ------------------------		
		Instr_regEn        <= '0';
		RF_A_En         <= '1';
		RF_B_En         <= '1';
		Immed_En        <= '1';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 
	

    	--EXECSTAGE (same as li) 
		RF_B_sel         <= 'U';
		RF_WrEn          <= '0';
		RF_WrData_sel    <= 'U';
		PC_LdEn          <= '0';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= '1';
		ALU_func         <= "0000";
		Sel_immed        <= "UU";
	   -----------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '1';
		MEM_En          <= '0';
		WAIT FOR Clk_period;
		
		--WRITEBACK 
		RF_B_sel         <= 'U';
		RF_WrEn          <= '1';
		RF_WrData_sel    <= '0';
		PC_LdEn          <= '1';
		MEM_WrEn         <= "0";
		ALU_Bin_sel      <= 'U';
		ALU_func         <= "UUUU";
		Sel_immed        <= "UU";
		----------------------
		Instr_regEn        <= '0';
		RF_A_En         <= '0';
		RF_B_En         <= '0';
		Immed_En        <= '0';
		ALUout_En       <= '0';
		MEM_En          <= '0';
		WAIT FOR Clk_period; 
		
		--or r8, r5, r10
		RF_WrEn       <= '1';
		PC_sel        <= '0';
		PC_LdEn       <= '1';
		RF_B_sel      <= 'U';
		RF_WrData_sel <= '0';
		ALU_Bin_sel   <= '1';
		MEM_WrEn      <= "0";
		ALU_func      <= "0011";
		Sel_immed     <= "00";
		
		Instr_reset    <= '0'; 
		RF_A_reset     <= '0'; 
		RF_B_reset     <= '0';
		Immed_reset      <= '0';
		ALUout_reset     <= '0'; 
		Mem_reset       <= '0'; 
		WAIT FOR Clk_period;
		
		--rol r5, r6, 1
		RF_WrEn       <= '1';
		PC_sel        <= '0';
		PC_LdEn       <= '1';
		RF_B_sel      <= '0';
		RF_WrData_sel <= '0';
		ALU_Bin_sel   <= '0';
		MEM_WrEn      <= "0";
		ALU_func      <= "1100";
		Sel_immed     <= "UU";
		
		Instr_reset    <= '0'; 
		RF_A_reset     <= '0'; 
		RF_B_reset     <= '0';
		Immed_reset      <= '0';
		ALUout_reset     <= '0'; 
		Mem_reset       <= '0'; 
		WAIT FOR Clk_period;
		
--		--ror r6, r5, 1
--		RF_WrEn       <= '1';
--		PC_sel        <= '0';
--		PC_LdEn       <= '1';
--		RF_B_sel      <= '0';
--		RF_WrData_sel <= '0';
--		ALU_Bin_sel   <= '0';
--		MEM_WrEn      <= "0";
--		ALU_func      <= "1101";
--		Sel_immed     <= "UU";
--		
--		Instr_reset    <= '0'; 
--		RF_A_reset     <= '0'; 
--		RF_B_reset     <= '0';
--		Immed_reset      <= '0';
--		ALUout_reset     <= '0'; 
--		Mem_reset       <= '0'; 
--		WAIT FOR Clk_period;
--		
--		--sw r5, 4(r10)
--		RF_WrEn       <= '0';
--		PC_sel        <= '0';
--		PC_LdEn       <= '1';
--		RF_B_sel      <= '1';
--		RF_WrData_sel <= 'U';
--		ALU_Bin_sel   <= '1';
--		MEM_WrEn      <= "1";
--		ALU_func      <= "0000";
--		Sel_immed     <= "01";
--		
--		Instr_reset    <= '0'; 
--		RF_A_reset     <= '0'; 
--		RF_B_reset     <= '0';
--		Immed_reset      <= '0';
--		ALUout_reset     <= '0'; 
--		Mem_reset       <= '0'; 
--		WAIT FOR Clk_period;
   END PROCESS;

END;

