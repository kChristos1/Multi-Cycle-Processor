LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;
ENTITY CONTROL_mc_tb IS
END;
ARCHITECTURE bench OF CONTROL_mc_tb IS
	COMPONENT CONTROL_mc
		PORT (
			Instr            : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			clk              : IN  STD_LOGIC;
			reset            : IN  STD_LOGIC;
			PC_LdEn          : OUT STD_LOGIC;
			RF_B_sel         : OUT STD_LOGIC;
			RF_WrData_sel    : OUT STD_LOGIC;
			ALU_Bin_sel      : OUT STD_LOGIC;
			ALU_func         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			MEM_WrEn         : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
			Sel_immed        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			RF_WrEn          : OUT STD_LOGIC;
			IF_reg_En        : OUT STD_LOGIC;
			DEC_reg_A_En     : OUT STD_LOGIC;
			DEC_reg_B_En     : OUT STD_LOGIC;
			DEC_reg_Immed_En : OUT STD_LOGIC;
			EXEC_reg_En      : OUT STD_LOGIC;
			MEM_reg_En       : OUT STD_LOGIC;
			Instr_reset      : OUT STD_LOGIC;
			RF_A_reset       : OUT STD_LOGIC;
			RF_B_reset       : OUT STD_LOGIC;
			Immed_reset      : OUT STD_LOGIC;
			ALUout_reset     : OUT STD_LOGIC;
			MEM_reset        : OUT STD_LOGIC
		);
	END COMPONENT;
	SIGNAL Instr            : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL clk              : STD_LOGIC;
	SIGNAL reset            : STD_LOGIC;
	SIGNAL PC_LdEn          : STD_LOGIC;
	SIGNAL RF_B_sel         : STD_LOGIC;
	SIGNAL RF_WrData_sel    : STD_LOGIC;
	SIGNAL ALU_Bin_sel      : STD_LOGIC;
	SIGNAL ALU_func         : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL MEM_WrEn         : STD_LOGIC_VECTOR(0 DOWNTO 0);
	SIGNAL Sel_immed        : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL RF_WrEn          : STD_LOGIC;
	SIGNAL IF_reg_En        : STD_LOGIC;
	SIGNAL DEC_reg_A_En     : STD_LOGIC;
	SIGNAL DEC_reg_B_En     : STD_LOGIC;
	SIGNAL DEC_reg_Immed_En : STD_LOGIC;
	SIGNAL EXEC_reg_En      : STD_LOGIC;
	SIGNAL MEM_reg_En       : STD_LOGIC;
	SIGNAL Instr_reset      : STD_LOGIC;
	SIGNAL RF_A_reset       : STD_LOGIC;
	SIGNAL RF_B_reset       : STD_LOGIC;
	SIGNAL Immed_reset      : STD_LOGIC;
	SIGNAL ALUout_reset     : STD_LOGIC;
	SIGNAL MEM_reset        : STD_LOGIC;
	CONSTANT clock_period   : TIME := 10 ns;
BEGIN
	uut : CONTROL_mc PORT MAP(
		Instr            => Instr,
		clk              => clk,
		reset            => reset,
		PC_LdEn          => PC_LdEn,
		RF_B_sel         => RF_B_sel,
		RF_WrData_sel    => RF_WrData_sel,
		ALU_Bin_sel      => ALU_Bin_sel,
		ALU_func         => ALU_func,
		MEM_WrEn         => MEM_WrEn,
		Sel_immed        => Sel_immed,
		RF_WrEn          => RF_WrEn,
		IF_reg_En        => IF_reg_En,
		DEC_reg_A_En     => DEC_reg_A_En,
		DEC_reg_B_En     => DEC_reg_B_En,
		DEC_reg_Immed_En => DEC_reg_Immed_En,
		EXEC_reg_En      => EXEC_reg_En,
		MEM_reg_En       => MEM_reg_En,
		Instr_reset      => Instr_reset,
		RF_A_reset       => RF_A_reset,
		RF_B_reset       => RF_B_reset,
		Immed_reset      => Immed_reset,
		ALUout_reset     => ALUout_reset,
		MEM_reset        => MEM_reset);
	stimulus : PROCESS
	BEGIN
		--                 Instruction format is:
		-- (6BITS) - (5 BITS) - (5BITS) - (5BITS) - (5BITS)	- (6BITS)
		-- OPCODE  -    RS    -    RD   -    RT   - NOTUSED -  FUNC
		-- OPCODE  -    RS    -    RD   - ========IMMEDIATE==========
		reset <= '1';
		WAIT FOR clock_period;
		reset <= '0';
		-- li r1,6
		Instr <= "11100000000000010000000000000110";
		WAIT FOR 4 * clock_period;
		--li r2,6
		Instr <= "11100000000000100000000000000110";
		WAIT FOR 4 * clock_period;
		--add r1,r3,r2
		Instr <= "10000000001000110001000000110000";
		WAIT FOR 4 * clock_period;
		--bne r1,r2, 0
		Instr <= "01000100001000100000000000000000";
		WAIT FOR 3 * clock_period;
		--beq r1,r2, 0
		Instr <= "01000000001000100000000000000000";
		WAIT FOR 3 * clock_period;
		--lui r8,4
		Instr <= "11100100000010000000000000000100";
		WAIT FOR 4 * clock_period;
		--lui r10,16
		Instr <= "11100100000010100000000000010000";
		WAIT FOR 4 * clock_period;
		--or r8,r5,r10
		Instr <= "10000001000001010101000000110011";
		WAIT FOR 4 * clock_period;
		--rol r5,r6,1
		Instr <= "10000000101001100000000000111100";
		WAIT FOR 4 * clock_period;
		--ror r6,r5,1
		Instr <= "10000000110001010000000000111101";
		WAIT FOR 4 * clock_period;
		--sw r5,4(r10)
		Instr <= "01111100101010100000000000000100";
		WAIT FOR 4 * clock_period;
		WAIT;
	END PROCESS;
	Clk_process : PROCESS
	BEGIN
		clk <= '0';
		WAIT FOR clock_period/2;
		clk <= '1';
		WAIT FOR clock_period/2;
	END PROCESS;
END;

