LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY exec_unit_tb IS
END exec_unit_tb;

ARCHITECTURE behavior OF exec_unit_tb IS
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT exec_unit
		PORT (
			RF_A        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			RF_B        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			Immed       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			ALU_Bin_sel : IN  STD_LOGIC;
			ALU_func    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
			ALU_out     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	--Inputs
	SIGNAL RF_A           : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RF_B           : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Immed          : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ALU_Bin_sel    : STD_LOGIC                     := '0';
	SIGNAL ALU_func       : STD_LOGIC_VECTOR(3 DOWNTO 0)  := (OTHERS => '0');
	--Outputs
	SIGNAL ALU_out        : STD_LOGIC_VECTOR(31 DOWNTO 0);
	--constants
	CONSTANT positiveNum1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000001011101101000011001";
	CONSTANT positiveNum2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000001110111111000001000000011";
BEGIN
	-- Instantiate the Unit Under Test (UUT)
	uut : exec_unit PORT MAP(
		RF_A        => RF_A,
		RF_B        => RF_B,
		Immed       => Immed,
		ALU_Bin_sel => ALU_Bin_sel,
		ALU_func    => ALU_func,
		ALU_out     => ALU_out
	);
	stim_proc : PROCESS
	BEGIN
		--addition.
		ALU_func    <= "0000";
		--r type instruction:
		ALU_bin_sel <= '0';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000010";
		WAIT FOR 100 ns;
		--I-type instruction (res = ra + immed):
		ALU_bin_sel <= '1';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000001";
		WAIT FOR 100 ns;
		---------------------------------------------
		--subtraction.
		ALU_func    <= "0001";
		--r type instruction:
		ALU_bin_sel <= '0';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000010";
		WAIT FOR 100 ns;
		--I-type instruction (res = ra + immed):
		ALU_bin_sel <= '1';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000001";
		WAIT FOR 100 ns;
		---------------------------------------------
		--logic AND.
		ALU_func    <= "0010";
		--r type instruction:
		ALU_bin_sel <= '0';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000010";
		WAIT FOR 100 ns;
		--I-type instruction (res = ra + immed):
		ALU_bin_sel <= '1';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000001";
		WAIT FOR 100 ns;
		-------------------------------------------
		--logic OR.
		ALU_func    <= "0011";
		--r type instruction:
		ALU_bin_sel <= '0';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000010";
		WAIT FOR 100 ns;
		--I-type instruction (res = ra + immed):
		ALU_bin_sel <= '1';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000001";
		WAIT FOR 100 ns;
		-------------------------------------------
		--logic NOT.
		ALU_func    <= "0100";
		--r type instruction:
		ALU_bin_sel <= '0';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000010";
		WAIT FOR 100 ns;
		--I-type instruction (res = ra + immed):
		ALU_bin_sel <= '1';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000001";
		WAIT FOR 100 ns;
		-------------------------------------------
		--shift right arithmetic.
		ALU_func    <= "1000";
		--r type instruction:
		ALU_bin_sel <= '0';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000010";
		WAIT FOR 100 ns;
		--I-type instruction (res = ra + immed):
		ALU_bin_sel <= '1';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000001";
		WAIT FOR 100 ns;
		-------------------------------------------
		--shift right logic.
		ALU_func    <= "1001";
		--r type instruction:
		ALU_bin_sel <= '0';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000010";
		WAIT FOR 100 ns;
		--I-type instruction (res = ra + immed):
		ALU_bin_sel <= '1';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000001";
		WAIT FOR 100 ns;
		-------------------------------------------
		--shift left.
		ALU_func    <= "1010";
		--r type instruction:
		ALU_bin_sel <= '0';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000010";
		WAIT FOR 100 ns;
		--I-type instruction (res = ra + immed):
		ALU_bin_sel <= '1';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000001";
		WAIT FOR 100 ns;
		-------------------------------------------
		--left rotate.
		ALU_func    <= "1100";
		--r type instruction:
		ALU_bin_sel <= '0';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000010";
		WAIT FOR 100 ns;
		--I-type instruction (res = ra + immed):
		ALU_bin_sel <= '1';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000001";
		WAIT FOR 100 ns;
		-------------------------------------------
		--right rotate.
		ALU_func    <= "1101";
		--r type instruction:
		ALU_bin_sel <= '0';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000010";
		WAIT FOR 100 ns;
		--I-type instruction (res = ra + immed):
		ALU_bin_sel <= '1';
		RF_A        <= positiveNum1;
		RF_B        <= positiveNum2;
		Immed       <= "00000000000000000000000000000001";
		WAIT FOR 100 ns;
		WAIT;
	END PROCESS;
END;
