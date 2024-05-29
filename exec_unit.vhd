LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY exec_unit IS
	PORT (
		RF_A        : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		RF_B        : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		Immed       : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		ALU_Bin_sel : IN  STD_LOGIC;
		ALU_func    : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		ALU_out     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		Zero        : OUT STD_LOGIC
	);
END exec_unit;

ARCHITECTURE Behavioral OF exec_unit IS
	COMPONENT ALU IS
		PORT (
			A      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			B      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			Op     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
			Output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Zero   : OUT STD_LOGIC;
			Cout   : OUT STD_LOGIC;
			Ovf    : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT mux2to1
		PORT (
			a      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0); --Din
			b      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			sele   : IN  STD_LOGIC; --true/false...
			muxout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;
	--------------------------------
	--inbetween signals declarations--
	----------------------------------
	SIGNAL mux_res : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN
	multiplexer : mux2to1 PORT MAP(
		a      => RF_B,
		b      => Immed,
		sele   => ALU_Bin_sel,
		muxout => mux_res
	);
	alu_Ex : ALU PORT MAP(
		A      => RF_A,
		B      => mux_res,
		Op     => ALU_func,
		Output => ALU_out,
		Zero   => Zero,
		Cout   => OPEN, -- port is not connected to any signal.
		Ovf    => OPEN  -- port is not connected to any signal.
	);
END Behavioral;
