LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.array_pack.ALL;

ENTITY IFSTAGE IS
	PORT (
		PC_Immed : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		PC_sel   : IN  STD_LOGIC;
		PC_LdEn  : IN  STD_LOGIC;
		Reset    : IN  STD_LOGIC;
		Clk      : IN  STD_LOGIC;
		Instr    : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END IFSTAGE;

ARCHITECTURE Behavioral OF IFSTAGE IS
	COMPONENT memory_file1 IS
		PORT (
			ADDRA : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
			DOUTA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			CLKA  : IN  STD_LOGIC
		);
	END COMPONENT;
	COMPONENT reg
		PORT (
			reg_clk : IN  STD_LOGIC;
			Data    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			Dout    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			WE      : IN  STD_LOGIC;
			reset   : IN  STD_LOGIC
		);
	END COMPONENT;
	COMPONENT mux2to1
		PORT (
			a      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			b      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			sele   : IN  STD_LOGIC;
			muxout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;
	--------------------------------
	--inbetween signals declarations--
	----------------------------------
	SIGNAL PC_in          : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL mem_address    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL next_instr     : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL branch_address : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL delayed_clk    : STD_LOGIC;
BEGIN
	next_instr     <= mem_address + 4;
	branch_address <= next_instr + PC_Immed;
	delayed_clk    <= Clk AFTER 100 ps; --delay ROM's clock by an insignificant amount of time

	PC : reg PORT MAP(
		reg_clk => Clk,
		Data    => PC_in,
		Dout    => mem_address,
		WE      => PC_LdEn,
		reset   => Reset
	);
	
	MUX : mux2to1 PORT MAP(
		a      => next_instr,
		b      => branch_address,
		sele   => PC_Sel,
		muxout => PC_in
	);
	
	IMEM : memory_file1 PORT MAP(
		ADDRA => mem_address(11 DOWNTO 2),
		DOUTA => Instr,
		CLKA  => delayed_clk
	);
END Behavioral;
