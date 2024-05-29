LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DATAPATH_mc IS
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
END DATAPATH_mc;

ARCHITECTURE Behavioral OF DATAPATH_mc IS
	COMPONENT reg
		PORT (
        reg_clk : IN  STD_LOGIC;
        Data    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        Dout    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        WE      : IN  STD_LOGIC;
        reset   : IN  STD_LOGIC
      );
	END COMPONENT; 
	 

		
	COMPONENT IFSTAGE
		PORT (
			PC_Immed : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			PC_sel   : IN  STD_LOGIC;
			PC_LdEn  : IN  STD_LOGIC;
			Reset    : IN  STD_LOGIC;
			Clk      : IN  STD_LOGIC;
			Instr    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT DECSTAGE
		PORT (
			Instr         : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			RF_WrEn       : IN  STD_LOGIC;
			ALU_out       : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			MEM_out       : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			RF_WrData_sel : IN  STD_LOGIC;
			RF_B_sel      : IN  STD_LOGIC;
			Clk           : IN  STD_LOGIC;
			Reset_regs    : IN  STD_LOGIC;                     --extra added
			Sel_immed     : IN  STD_LOGIC_VECTOR (1 DOWNTO 0); --extra added
			Immed         : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			RF_A          : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			RF_B          : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT exec_unit
		PORT (
			RF_A        : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			RF_B        : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			Immed       : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			ALU_Bin_sel : IN  STD_LOGIC;
			ALU_func    : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			ALU_out     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			Zero        : OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT MEMSTAGE
		PORT (
			clk          : IN  STD_LOGIC;
			Mem_WrEn     : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
			ALU_MEM_Addr : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			MEM_DataIn   : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			MEM_DataOut  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
	END COMPONENT;
	
	--inbetween signals:
	SIGNAL Instr_sig       : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Immed_sig       : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL RF_A_sig        : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL RF_B_sig        : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MEM_in_data     : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_out_sig     : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MEM_out_sig     : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL RF_WRITE_MUX_IN : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL op_code         : STD_LOGIC_VECTOR(5 DOWNTO 0);
	--internal signals for our new registers: 
	SIGNAL InstrReg_out_sig    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL RF_A_out_sig        : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL RF_B_out_sig        : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Immed_out_sig       : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALUreg_out_sig      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MEMreg_out_sig      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	SIGNAL Zero_sig            : STD_LOGIC; 
	SIGNAL PC_sel_sig          : STD_LOGIC; 
	--SIGNAL PC_LdEn_sig         : STD_LOGIC; 
	
	CONSTANT branch     : STD_LOGIC_VECTOR(5 DOWNTO 0) := "111111";
	CONSTANT beq        : STD_LOGIC_VECTOR(5 DOWNTO 0) := "010000";
	CONSTANT bne        : STD_LOGIC_VECTOR(5 DOWNTO 0) := "010001";
	
BEGIN
	--zerofillers for sb/lb instructions
	Instr   <= Instr_sig;
	op_code <= Instr_sig(31 DOWNTO 26);

	-- MEM_in_data and 
	-- getting zerofilled in
	-- case of store/load byte
	-- respectively
	
	--the following process will determine what instruction the fech unit will give us. 
	PROCESS (Zero_sig , PC_LdEn) 
	BEGIN
	 IF(PC_LdEn='1') THEN
		IF(op_code = branch) THEN 				
			PC_sel_sig <= '1';
		ELSIF(op_code = beq AND Zero_sig='1') THEN
			PC_sel_sig <='1'; 
		ELSIF(op_code = bne AND Zero_sig='0') THEN
			PC_sel_sig <='1';
		ELSE
		   PC_sel_sig <='0'; 
		END IF;  
  END IF;
	END PROCESS; 
	
	PROCESS (op_code, RF_B_sig, MEM_out_sig)
	BEGIN
		IF op_code = "000111" THEN
			MEM_in_data(7 DOWNTO 0)  <= RF_B_sig(7 DOWNTO 0);
			MEM_in_data(31 DOWNTO 8) <= (OTHERS => '0');
		ELSE
			MEM_in_data <= RF_B_sig;
		END IF;

		IF op_code = "000011" THEN
			RF_WRITE_MUX_IN(7 DOWNTO 0)  <= MEM_out_sig(7 DOWNTO 0);
			RF_WRITE_MUX_IN(31 DOWNTO 8) <= (OTHERS => '0');
		ELSE
			RF_WRITE_MUX_IN <= MEM_out_sig;
		END IF;
	END PROCESS;

	--PORT MAPPING: 
	instrReg_label : reg
	PORT MAP(
		reg_clk => Clk,
		Data    => Instr_sig, 
		Dout    => InstrReg_out_sig, 
		WE      => Instr_regEn, 
		reset   => Instr_reset
	); 
	
	
	
	RAreg_label : reg 
	PORT MAP(
		reg_clk => Clk,
		Data    => RF_A_sig, 
		Dout    => RF_A_out_sig, 
		WE      => RF_A_En, 
		reset   => RF_A_reset			  
	);
	
	
	RBreg_label : reg 
	PORT MAP(
		reg_clk => Clk,
		Data    => RF_B_sig, 
		Dout    => RF_B_out_sig, 
		WE      => RF_B_En, 
		reset   => RF_B_reset			  
	);
	
	
	ImmedReg_label : reg 
	PORT MAP(
		reg_clk => Clk,
		Data    => Immed_sig,
		Dout    => Immed_out_sig,
		WE      => Immed_En,
		reset   => Immed_reset
	); 
	
	
	ALUoutReg_label : reg
	PORT MAP(
		reg_clk => Clk, 
		Data    => ALU_out_sig,
		Dout    => ALUreg_out_sig,
		WE      => ALUout_En,
		reset   => ALUout_reset
	); 
	
	
	MemReg_label : reg
	PORT MAP(
		reg_clk => Clk, 
		Data    => MEM_out_sig,
		Dout    => MEMreg_out_sig,
		WE      => MEM_En,
		reset   => MEM_reset
	); 
		
	
	
	if_label : IFSTAGE
	PORT MAP(
		PC_Immed => Immed_sig,
		PC_sel   => PC_sel_sig,
		PC_LdEn  => PC_LdEn,
		Reset    => PC_reset,
		Clk      => Clk,
		Instr    => Instr_sig
	);
	

	dec_label : DECSTAGE
	PORT MAP(
		Instr         => InstrReg_out_sig,
		RF_WrEn       => RF_WrEn,
		ALU_out       => ALU_out_sig,
		MEM_out       => RF_WRITE_MUX_IN,
		RF_WrData_sel => RF_WrData_sel,
		RF_B_sel      => RF_B_sel,
		Clk           => Clk,
		Reset_regs    => Reset_regs,
		Sel_immed     => Sel_immed, --for conversion_unit
		Immed         => Immed_sig,
		RF_A          => RF_A_sig,
		RF_B          => RF_B_sig
	);

	exec_unit_label : exec_unit
	PORT MAP(
		RF_A        => RF_A_sig,
		RF_B        => RF_B_sig,
		Immed       => Immed_sig,
		ALU_Bin_sel => ALU_Bin_sel,
		ALU_func    => ALU_func,
		ALU_out     => ALU_out_sig,
		Zero        => Zero_sig
	);

	memstage_label : MEMSTAGE
	PORT MAP(
		clk          => Clk,
		Mem_WrEn     => Mem_WrEn,
		ALU_MEM_Addr => ALU_out_sig,
		MEM_DataIn   => MEM_in_data,
		MEM_DataOut  => MEM_out_sig
	);
END Behavioral;

