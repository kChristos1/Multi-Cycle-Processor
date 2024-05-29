LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY CONTROL_mc IS
	PORT (
		-- input is only the Instruction
		Instr            : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		--clk
		clk              : IN  STD_LOGIC;
		reset            : IN  STD_LOGIC;
		-- output signals:
		PC_LdEn          : OUT STD_LOGIC;
		RF_B_sel         : OUT STD_LOGIC;
		RF_WrData_sel    : OUT STD_LOGIC;
		ALU_Bin_sel      : OUT STD_LOGIC;
		ALU_func         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --alu's opcode
		MEM_WrEn         : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
		Sel_immed        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		RF_WrEn          : OUT STD_LOGIC;
		-- register enables
		IF_reg_En        : OUT STD_LOGIC;
		DEC_reg_A_En     : OUT STD_LOGIC;
		DEC_reg_B_En     : OUT STD_LOGIC;
		DEC_reg_Immed_En : OUT STD_LOGIC;
		EXEC_reg_En      : OUT STD_LOGIC;
		MEM_reg_En       : OUT STD_LOGIC;
		--register resets
		Instr_reset      : OUT STD_LOGIC;
		RF_A_reset       : OUT STD_LOGIC;
		RF_B_reset       : OUT STD_LOGIC;
		Immed_reset      : OUT STD_LOGIC;
		ALUout_reset     : OUT STD_LOGIC;
		MEM_reset        : OUT STD_LOGIC
	);
END CONTROL_mc;
-- Instruction format is:
-- (6BITS) - (5 BITS) - (5BITS) - (5BITS) - (5BITS) - (6BITS)
-- R-TYPE: OPCODE - RS - RD - RT - NOTUSED - FUNC
-- I-TYPE: OPCODE - RS - RD - ========IMMEDIATE==========
--
-- To determine the ALU operation we keep the 4 MS bits of the instruction.
-- In cases such as lb/sb or beq/bne we use the following values:
-- "0000" is for addition
-- "0001" is for subtraction
-- "0010" is for logic and
-- "0011" is for logic or
ARCHITECTURE Behavioral OF CONTROL_mc IS
	SIGNAL opcode       : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL func         : STD_LOGIC_VECTOR(3 DOWNTO 0);
	--values for opcode (as constants):
	CONSTANT NOP        : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
	CONSTANT ALU_R_type : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100000";
	CONSTANT li         : STD_LOGIC_VECTOR(5 DOWNTO 0) := "111000";
	CONSTANT lui        : STD_LOGIC_VECTOR(5 DOWNTO 0) := "111001";
	CONSTANT addi       : STD_LOGIC_VECTOR(5 DOWNTO 0) := "110000";
	CONSTANT andi       : STD_LOGIC_VECTOR(5 DOWNTO 0) := "110010";
	CONSTANT ori        : STD_LOGIC_VECTOR(5 DOWNTO 0) := "110011";
	CONSTANT branch     : STD_LOGIC_VECTOR(5 DOWNTO 0) := "111111";
	CONSTANT beq        : STD_LOGIC_VECTOR(5 DOWNTO 0) := "010000";
	CONSTANT bne        : STD_LOGIC_VECTOR(5 DOWNTO 0) := "010001";
	CONSTANT lb         : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000011";
	CONSTANT lw         : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001111";
	CONSTANT sb         : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000111";
	CONSTANT sw         : STD_LOGIC_VECTOR(5 DOWNTO 0) := "011111";
	-- declaring the various states
	TYPE State_Type IS (
		--instruction fetch
		IF_stage,
		--decoding instruction
		DEC_stage,
		--execute (ALU)
		--some of them essentially do the same thing
		--but for clarity we have every possible instruction
		EXEC_stage_ALU_R_type,
		EXEC_stage_li,
		EXEC_stage_lui,
		EXEC_stage_addi,
		EXEC_stage_andi,
		EXEC_stage_ori,
		EXEC_stage_branch,
		EXEC_stage_beq,
		EXEC_stage_bne,
		EXEC_stage_lb,
		EXEC_stage_sb,
		EXEC_stage_lw,
		EXEC_stage_sw,
		--load/store from/to memory
		MEM_stage_load,
		MEM_stage_store,
		--write back (to the RF)
		WB_stage_ALU,
		WB_stage_MEM
	);
	-- state variables
	SIGNAL curr_state : State_Type;
BEGIN
	opcode       <= Instr(31 DOWNTO 26);
	func         <= Instr(3 DOWNTO 0);
	Instr_reset  <= '0';
	RF_A_reset   <= '0';
	RF_B_reset   <= '0';
	Immed_reset  <= '0';
	ALUout_reset <= '0';
	MEM_reset    <= '0';
	--reset -> IF_stage
	--clk -> curr_state
	StateReg : PROCESS
	BEGIN
		WAIT UNTIL clk'EVENT AND clk = '1';
		IF (reset = '1') THEN
			curr_state <= IF_stage;
			--PC_LdEn    <= '1';
		ELSE
			CASE curr_state IS
				WHEN IF_stage =>
					-- control signals
					RF_B_sel         <= 'U';
					RF_WrEn          <= '0';
					RF_WrData_sel    <= 'U';
					PC_LdEn          <= '0';
					MEM_WrEn         <= "0";
					ALU_Bin_sel      <= 'U';
					ALU_func         <= "UUUU";
					Sel_immed        <= "UU";
					IF_reg_En        <= '1';
					DEC_reg_A_En     <= '0';
					DEC_reg_B_En     <= '0';
					DEC_reg_Immed_En <= '0';
					EXEC_reg_En      <= '0';
					MEM_reg_En       <= '0';
					curr_state       <= DEC_stage;
				WHEN DEC_stage =>
					-- control signals
					IF (opcode = ALU_R_type) THEN
						RF_B_sel <= '0';
					ELSE
						RF_B_sel <= '1';
					END IF;
					RF_WrEn       <= '0';
					RF_WrData_sel <= 'U';
					PC_LdEn       <= '0';
					MEM_WrEn      <= "0";
					ALU_Bin_sel   <= 'U';
					ALU_func      <= "UUUU";
					CASE opcode IS
						WHEN li | addi | lb | sb | lw | sw =>
							Sel_immed <= "01";
						WHEN lui =>
							Sel_immed <= "11";
						WHEN andi | ori =>
							Sel_immed <= "00";
						WHEN branch | beq | bne =>
							Sel_immed <= "10";
						WHEN OTHERS =>
							Sel_immed <= "UU";
					END CASE;
					IF_reg_En        <= '0';
					DEC_reg_A_En     <= '1';
					DEC_reg_B_En     <= '1';
					DEC_reg_Immed_En <= '1';
					EXEC_reg_En      <= '0';
					MEM_reg_En       <= '0';
					-- next state
					CASE opcode IS
						WHEN NOP =>
							PC_LdEn    <= '1';
							curr_state <= IF_stage;
						WHEN ALU_R_type =>
							curr_state <= EXEC_stage_ALU_R_type;
						WHEN li =>
							curr_state <= EXEC_stage_li;
						WHEN lui =>
							curr_state <= EXEC_stage_lui;
						WHEN addi =>
							curr_state <= EXEC_stage_addi;
						WHEN andi =>
							curr_state <= EXEC_stage_andi;
						WHEN ori =>
							curr_state <= EXEC_stage_ori;
						WHEN branch =>
							curr_state <= EXEC_stage_branch;
						WHEN beq =>
							curr_state <= EXEC_stage_beq;
						WHEN bne =>
							curr_state <= EXEC_stage_bne;
						WHEN lb =>
							curr_state <= EXEC_stage_lb;
						WHEN sb =>
							curr_state <= EXEC_stage_sb;
						WHEN lw =>
							curr_state <= EXEC_stage_lw;
						WHEN sw =>
							curr_state <= EXEC_stage_sw;
						WHEN OTHERS =>
							PC_LdEn    <= '1';
							curr_state <= IF_stage;
					END CASE;
				WHEN EXEC_stage_ALU_R_type =>
					-- control signals
					RF_B_sel         <= 'U';
					RF_WrEn          <= '0';
					RF_WrData_sel    <= 'U';
					PC_LdEn          <= '0';
					MEM_WrEn         <= "0";
					ALU_Bin_sel      <= '0';
					ALU_func         <= func;
					Sel_immed        <= "UU";
					IF_reg_En        <= '0';
					DEC_reg_A_En     <= '0';
					DEC_reg_B_En     <= '0';
					DEC_reg_Immed_En <= '0';
					EXEC_reg_En      <= '1';
					MEM_reg_En       <= '0';
					-- next state
					curr_state       <= WB_stage_ALU;
					---------------------------------------------------------------------------
					---- li    lui   addi    lb     sb    lw    sw

				WHEN EXEC_stage_li | EXEC_stage_lui | EXEC_stage_addi | EXEC_stage_lb | EXEC_stage_sb |
					EXEC_stage_lw | EXEC_stage_sw =>
					-- control signals
					RF_B_sel         <= 'U';
					RF_WrEn          <= '0';
					RF_WrData_sel    <= 'U';
					PC_LdEn          <= '0';
					MEM_WrEn         <= "0";
					--all these instructions add (ALU_func = "0000")
					--an Immediate (ALU_Bin_sel = '1')
					ALU_Bin_sel      <= '1';
					ALU_func         <= "0000";
					Sel_immed        <= "UU";
					IF_reg_En        <= '0';
					DEC_reg_A_En     <= '0';
					DEC_reg_B_En     <= '0';
					DEC_reg_Immed_En <= '0';
					EXEC_reg_En      <= '1';
					MEM_reg_En       <= '0';
					-- next state
					CASE opcode IS
						WHEN li | lui | addi =>
							curr_state <= WB_stage_ALU;
						WHEN lb | lw =>
							curr_state <= MEM_stage_load;
						WHEN sb | sw =>
							curr_state <= MEM_stage_store;
						WHEN OTHERS =>
							--null;
							PC_LdEn    <= '1';
							curr_state <= IF_stage;
					END CASE;
				WHEN EXEC_stage_andi =>
					-- control signals
					RF_B_sel         <= 'U';
					RF_WrEn          <= '0';
					RF_WrData_sel    <= 'U';
					PC_LdEn          <= '0';
					MEM_WrEn         <= "0";
					ALU_Bin_sel      <= '1';
					ALU_func         <= "0010";
					Sel_immed        <= "UU";
					IF_reg_En        <= '0';
					DEC_reg_A_En     <= '0';
					DEC_reg_B_En     <= '0';
					DEC_reg_Immed_En <= '0';
					EXEC_reg_En      <= '1';
					MEM_reg_En       <= '0';
					-- next state
					curr_state       <= WB_stage_ALU;
				WHEN EXEC_stage_ori =>
					-- control signals
					RF_B_sel         <= 'U';
					RF_WrEn          <= '0';
					RF_WrData_sel    <= 'U';
					PC_LdEn          <= '0';
					MEM_WrEn         <= "0";
					ALU_Bin_sel      <= '1';
					ALU_func         <= "0011";
					Sel_immed        <= "UU";
					IF_reg_En        <= '0';
					DEC_reg_A_En     <= '0';
					DEC_reg_B_En     <= '0';
					DEC_reg_Immed_En <= '0';
					EXEC_reg_En      <= '1';
					MEM_reg_En       <= '0';
					-- next state
					curr_state       <= WB_stage_ALU;
				WHEN EXEC_stage_branch =>
					-- control signals
					RF_B_sel         <= 'U';
					RF_WrEn          <= '0';
					RF_WrData_sel    <= 'U';
					PC_LdEn          <= '1';
					MEM_WrEn         <= "0";
					ALU_Bin_sel      <= 'U';
					ALU_func         <= "UUUU";
					Sel_immed        <= "UU";
					IF_reg_En        <= '0';
					DEC_reg_A_En     <= '0';
					DEC_reg_B_En     <= '0';
					DEC_reg_Immed_En <= '0';
					EXEC_reg_En      <= '1';
					MEM_reg_En       <= '0';
					-- next state
					curr_state       <= IF_stage;
				WHEN EXEC_stage_beq | EXEC_stage_bne =>
					-- control signals
					RF_B_sel         <= 'U';
					RF_WrEn          <= '0';
					RF_WrData_sel    <= 'U';
					PC_LdEn          <= '1';
					MEM_WrEn         <= "0";
					ALU_Bin_sel      <= '0';
					ALU_func         <= "0001";
					Sel_immed        <= "UU";
					IF_reg_En        <= '0';
					DEC_reg_A_En     <= '0';
					DEC_reg_B_En     <= '0';
					DEC_reg_Immed_En <= '0';
					EXEC_reg_En      <= '1';
					MEM_reg_En       <= '0';
					-- next state
					curr_state       <= IF_stage;
				WHEN MEM_stage_load =>
					-- control signals
					RF_B_sel         <= 'U';
					RF_WrEn          <= '0';
					RF_WrData_sel    <= 'U';
					PC_LdEn          <= '0';
					MEM_WrEn         <= "0";
					ALU_Bin_sel      <= 'U';
					ALU_func         <= "UUUU";
					Sel_immed        <= "UU";
					IF_reg_En        <= '0';
					DEC_reg_A_En     <= '0';
					DEC_reg_B_En     <= '0';
					DEC_reg_Immed_En <= '0';
					EXEC_reg_En      <= '0';
					MEM_reg_En       <= '1';
					-- next state
					curr_state       <= WB_stage_MEM;
				WHEN MEM_stage_store =>
					-- control signals
					RF_B_sel         <= 'U';
					RF_WrEn          <= '0';
					RF_WrData_sel    <= 'U';
					PC_LdEn          <= '1';
					MEM_WrEn         <= "1";
					ALU_Bin_sel      <= 'U';
					ALU_func         <= "UUUU";
					Sel_immed        <= "UU";
					IF_reg_En        <= '0';
					DEC_reg_A_En     <= '0';
					DEC_reg_B_En     <= '0';
					DEC_reg_Immed_En <= '0';
					EXEC_reg_En      <= '0';
					MEM_reg_En       <= '0';
					-- next state
					curr_state       <= IF_stage;
				WHEN WB_stage_MEM =>
					-- control signals
					RF_B_sel         <= 'U';
					RF_WrEn          <= '1';
					RF_WrData_sel    <= '1';
					PC_LdEn          <= '1';
					MEM_WrEn         <= "0";
					ALU_Bin_sel      <= 'U';
					ALU_func         <= "UUUU";
					Sel_immed        <= "UU";
					IF_reg_En        <= '0';
					DEC_reg_A_En     <= '0';
					DEC_reg_B_En     <= '0';
					DEC_reg_Immed_En <= '0';
					EXEC_reg_En      <= '0';
					MEM_reg_En       <= '0';
					-- next state
					curr_state       <= IF_stage;
				WHEN WB_stage_ALU =>
					-- control signals
					RF_B_sel         <= 'U';
					RF_WrEn          <= '1';
					RF_WrData_sel    <= '0';
					PC_LdEn          <= '1';
					MEM_WrEn         <= "0";
					ALU_Bin_sel      <= 'U';
					ALU_func         <= "UUUU";
					Sel_immed        <= "UU";
					IF_reg_En        <= '0';
					DEC_reg_A_En     <= '0';
					DEC_reg_B_En     <= '0';
					DEC_reg_Immed_En <= '0';
					EXEC_reg_En      <= '0';
					MEM_reg_En       <= '0';
					-- next state
					curr_state       <= IF_stage;
				WHEN OTHERS =>
					-- next instruction
					PC_LdEn    <= '1';
					-- next state
					curr_state <= IF_stage;
			END CASE;
			--curr_state <= curr_state;
		END IF;
	END PROCESS;
END Behavioral;

