LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DECSTAGE IS
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
END DECSTAGE;

ARCHITECTURE Behavioral OF DECSTAGE IS
	--2to1 multiplexer
	COMPONENT mux2to1
		PORT (
			a      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			b      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			sele   : IN  STD_LOGIC;
			muxout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;

	--register file
	COMPONENT reg_file IS
		PORT (
			Ard1            : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
			Ard2            : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
			Awr             : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
			Dout1           : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			Dout2           : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			Din             : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			WrEn            : IN  STD_LOGIC;
			Clk             : IN  STD_LOGIC;
			reset_registers : IN  STD_LOGIC
		);
	END COMPONENT;

	COMPONENT conversion_unit IS
		PORT (
			Input : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
			Immed : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			cond  : IN  STD_LOGIC_VECTOR (1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT mux4 IS
		PORT (
			a      : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
			b      : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
			sele   : IN  STD_LOGIC;
			muxout : OUT STD_LOGIC_VECTOR (4 DOWNTO 0));
	END COMPONENT;

	--inbetween signals needed:
	SIGNAL read_address_2 : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL write_data_in  : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL Opcode         : STD_LOGIC_VECTOR (5 DOWNTO 0);
	SIGNAL Rs             : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL Rd             : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL Rt             : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL Func           : STD_LOGIC_VECTOR (5 DOWNTO 0);
	SIGNAL Immediate      : STD_LOGIC_VECTOR (15 DOWNTO 0);
BEGIN
	Immediate <= Instr(15 DOWNTO 0);
	Rt        <= Instr(15 DOWNTO 11);
	Rd        <= Instr(20 DOWNTO 16);
	Rs        <= Instr(25 DOWNTO 21);
	
	--port mapping
	write_mux : mux2to1 PORT MAP(
		a      => ALU_out,
		b      => MEM_out,
		sele   => RF_WrData_sel,
		muxout => write_data_in
	);

	read_mux : mux4 PORT MAP(
		a      => Rt,
		b      => Rd,
		sele   => RF_B_sel,
		muxout => read_address_2
	);

	bit_expander : conversion_unit
	PORT MAP(
		Input => Immediate,
		Immed => Immed,
		cond  => Sel_immed
	);

	rf_label : reg_file
	PORT MAP(
		Ard1            => Rs,
		Ard2            => read_address_2,
		Awr             => Rd,
		Dout1           => RF_A,
		Dout2           => RF_B,
		Din             => write_data_in,
		WrEn            => RF_WrEn,
		Clk             => Clk,
		reset_registers => Reset_regs
	);
END Behavioral;
