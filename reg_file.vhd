LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.array_pack.ALL;

ENTITY reg_file IS
	PORT (
		Ard1            : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Ard2            : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Awr             : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Dout1           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Dout2           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Din             : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		WrEn            : IN  STD_LOGIC;
		Clk             : IN  STD_LOGIC;
		reset_registers : IN  STD_LOGIC);
END reg_file;

ARCHITECTURE Behavioral OF reg_file IS
	--------------
	--components--
	--------------
	COMPONENT reg
		PORT (
			reg_clk : IN  STD_LOGIC;
			Data    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			Dout    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			WE      : IN  STD_LOGIC;
			reset   : IN  STD_LOGIC);
	END COMPONENT;
	COMPONENT mux2to1
		PORT (
			a      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			b      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			sele   : IN  STD_LOGIC;
			muxout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
	END COMPONENT;
	COMPONENT mux
		PORT (
			Input  : IN  array_32;
			Sel    : IN  STD_LOGIC_VECTOR (4 DOWNTO 0); --Ard1 / Ard2
			Output : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
	END COMPONENT;
	COMPONENT decoder
		PORT (
			Input  : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
			Output : OUT array_1
		);
	END COMPONENT;
	COMPONENT compare_module
		PORT (
			cmp1       : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
			cmp2       : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
			cmp_result : OUT STD_LOGIC
		);
	END COMPONENT;
	----------------------------------
	--inbetween signals declarations--
	----------------------------------
	SIGNAL dec_out   : array_1;
	SIGNAL we2       : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL we_r0     : STD_LOGIC;
	SIGNAL reg_out   : array_32;
	SIGNAL mux_out1  : STD_LOGIC_VECTOR(31 DOWNTO 0); --output of "big" mux
	SIGNAL mux_out2  : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL comp_out1 : STD_LOGIC;
	SIGNAL comp_out2 : STD_LOGIC;
	SIGNAL mux_sel1  : STD_LOGIC;
	SIGNAL mux_sel2  : STD_LOGIC;
	SIGNAL wrenB     : STD_LOGIC;
BEGIN
	-- Making sure that if someone tries to 
	-- write in R0 we disable the WrEn flag
	-- so that they cannot write.
	-- This guarantees that the R0 output
	-- is always 0.
	PROCESS (Awr, WrEn)
	BEGIN
		IF Awr = "00000" THEN
			wrenB <= '0';
		ELSE
			wrenB <= WrEn;
		END IF;
	END PROCESS;

	write_enable :
	FOR i IN 0 TO 31 GENERATE
		--logical AND as shown in schematic:
		we2(i) <= (wrenB AND dec_out(i));
	END GENERATE write_enable;
	
	mux_sel1   <= wrenB AND comp_out1;
	mux_sel2   <= wrenB AND comp_out2;

	registers : FOR i IN 0 TO 31 GENERATE
		label_reg : reg PORT MAP(
			reg_clk => Clk,
			Data    => Din,
			Dout    => reg_out(i),
			WE      => we2(i),
			reset   => reset_registers
		);
	END GENERATE registers;

	label_dec : decoder PORT MAP(
		Input  => Awr,
		Output => dec_out
	);

	label_mux1 : mux PORT MAP(
		Input  => reg_out,
		Sel    => Ard1,
		Output => mux_out1
	);

	label_mux2 : mux PORT MAP(
		Input  => reg_out,
		Sel    => Ard2,
		Output => mux_out2
	);

	label_compare1 : compare_module PORT MAP(
		cmp1       => Ard1,
		cmp2       => Awr,
		cmp_result => comp_out1
	);

	label_compare2 : compare_module PORT MAP(
		cmp1       => Ard2,
		cmp2       => Awr,
		cmp_result => comp_out2
	);

	label_minimux : mux2to1 PORT MAP(
		a      => mux_out1,
		b      => Din,
		sele   => mux_sel1,
		muxout => Dout1
	);

	label_minimux2 : mux2to1 PORT MAP(
		a      => mux_out2,
		b      => Din,
		sele   => mux_sel2,
		muxout => Dout2
	);
END Behavioral;
