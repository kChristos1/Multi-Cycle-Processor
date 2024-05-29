library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


ENTITY CPU_mc IS
	PORT (
		PC_rst : IN STD_LOGIC;
		RF_rst : IN STD_LOGIC;
		FSM_rst : IN STD_LOGIC;
		clk    : IN STD_LOGIC);
END CPU_mc;


architecture Behavioral of CPU_mc is

component DATAPATH_mc 
	PORT (
		--input signals are:
		--the control signals (generated from CONTROL unit)
	
		PC_LdEn       : IN  STD_LOGIC;
		RF_B_sel      : IN  STD_LOGIC;
		RF_WrData_sel : IN  STD_LOGIC;
		ALU_Bin_sel   : IN  STD_LOGIC;
		ALU_func      : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		MEM_WrEn      : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
		RF_WrEn       : IN  STD_LOGIC;
		Sel_immed     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		--reset signals used for
		--1)registers in RF in DECSTAGE:
		Reset_regs    : IN  STD_LOGIC;
		--2)program counter in IFSTAGE
		PC_reset      : IN  STD_LOGIC;
		
		--we also need a clock (common).
		Clk           : IN  STD_LOGIC;
		
		--write enable signals for the internal registers 
		Instr_regEn   : IN STD_LOGIC; 
		RF_A_En		  : IN STD_LOGIC; 
		RF_B_En       : IN STD_LOGIC; 
		Immed_En      : IN STD_LOGIC; 
		ALUout_En     : IN STD_LOGIC; 
		MEM_En        : IN STD_LOGIC; 
		
		--reset signals for the internal registers: 
		Instr_reset   : IN STD_LOGIC; 
		RF_A_reset    : IN STD_LOGIC;
		RF_B_reset    : IN STD_LOGIC;
		Immed_reset   : IN STD_LOGIC;
		ALUout_reset  : IN STD_LOGIC;
	   MEM_reset     : IN STD_LOGIC;
		
		--output signals are:
		--the 32bit instruction (fetched from IFSTAGE)
		Instr         : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)		
	);
	end component; 
	
	component CONTROL_mc 
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
   end component;
	
	--signals
	--(same as in sc)
   SIGNAL sigInstr         : STD_LOGIC_VECTOR (31 DOWNTO 0);
--	SIGNAL sigZero          : STD_LOGIC;
--	SIGNAL sigPC_sel        : STD_LOGIC;
	SIGNAL sigPC_LdEn       : STD_LOGIC;
	SIGNAL sigRF_B_sel      : STD_LOGIC;
	SIGNAL sigRF_WrData_sel : STD_LOGIC;
	SIGNAL sigALU_Bin_sel   : STD_LOGIC;
	SIGNAL sigALU_func      : STD_LOGIC_VECTOR(3 DOWNTO 0); --alu's opcode
	SIGNAL sigMEM_WrEn      : STD_LOGIC_VECTOR(0 DOWNTO 0);
	SIGNAL sigSel_immed     : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL sigRF_WrEn       : STD_LOGIC;
	--(additional signals for mc)
	signal sigInstr_regEn   :  STD_LOGIC; 
	signal sigRF_A_En		   :  STD_LOGIC; 
	signal sigRF_B_En       :  STD_LOGIC; 
	signal sigImmed_En      :  STD_LOGIC; 
	signal sigALUout_En     :  STD_LOGIC; 
	signal sigMEM_En        :  STD_LOGIC; 
	--reset signals for the internal registers: 
   signal sigInstr_reset      :  STD_LOGIC; 
	signal sigRF_A_reset		   :  STD_LOGIC; 
	signal sigRF_B_reset       :  STD_LOGIC; 
	signal sigImmed_reset      :  STD_LOGIC; 
	signal sigALUout_reset     :  STD_LOGIC; 
	signal sigMEM_reset        :  STD_LOGIC;
		
begin
	datapath_lbl : DATAPATH_mc PORT MAP(
	
		PC_LdEn       => sigPC_LdEn,
		RF_B_sel      => sigRF_B_sel,
		RF_WrData_sel => sigRF_WrData_sel,
		ALU_Bin_sel   => sigALU_Bin_sel,
		ALU_func      => sigALU_func,
		MEM_WrEn      => sigMEM_WrEn,
		RF_WrEn       => sigRF_WrEn,
		Sel_immed     => sigSel_immed,
		Reset_regs    => RF_rst,
		PC_reset      => PC_rst,
		Clk           => clk,
		Instr         => sigInstr,
		
		Instr_regEn   => sigInstr_regEn,
		RF_A_En		  => sigRF_A_En,	
		RF_B_En       => sigRF_B_En,
		Immed_En      => sigImmed_En,
		ALUout_En     => sigALUout_En, 
		MEM_En        => sigMEM_En,
		--reset signals for the internal registers: 
		Instr_reset   => sigInstr_reset,
		RF_A_reset    => sigRF_A_reset,
		RF_B_reset    => sigRF_B_En,
		Immed_reset   => sigImmed_reset,
		ALUout_reset  => sigALUout_reset,
	   MEM_reset     => sigMEM_reset
	);
	
	control_lbl : CONTROL_mc PORT MAP(
		Instr         => sigInstr,
		PC_LdEn       => sigPC_LdEn,
		RF_B_sel      => sigRF_B_sel,
		RF_WrData_sel => sigRF_WrData_sel,
		ALU_Bin_sel   => sigALU_Bin_sel,
		ALU_func      => sigALU_func,
		MEM_WrEn      => sigMEM_WrEn,
		Sel_immed     => sigSel_immed,
		RF_WrEn       => sigRF_WrEn,
		clk           => clk,
--
		reset         => FSM_rst,
		IF_reg_En     => sigInstr_regEn,
		DEC_reg_A_En  => sigRF_A_En,	
		DEC_reg_B_En  => sigRF_B_En,
		DEC_reg_Immed_En => sigImmed_En,
		EXEC_reg_En      => sigALUout_En, 
		MEM_reg_En       => sigMEM_En,
		--reset signals for the internal registers: 
		Instr_reset   => sigInstr_reset,
		RF_A_reset    => sigRF_A_reset,
		RF_B_reset    => sigRF_B_reset,
		Immed_reset   => sigImmed_reset,
		ALUout_reset  => sigALUout_reset,
	   MEM_reset     => sigMEM_reset
		);

end Behavioral;


