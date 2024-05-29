LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY alu_tb IS
END;

ARCHITECTURE bench OF alu_tb IS
	COMPONENT alu
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
	SIGNAL A              : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL B              : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Op             : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Output         : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Zero           : STD_LOGIC;
	
	SIGNAL Cout           : STD_LOGIC;
	SIGNAL Ovf            : STD_LOGIC;
	CONSTANT positiveNum1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000001011101101000011001";
	CONSTANT positiveNum2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000001110111111000001000000011";
	CONSTANT negativeNum1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := "11111111111110100010010111100111"; -- negate positiveNum1
	CONSTANT negativeNum2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := "11111110001000000111110111111101"; -- negate positiveNum2
BEGIN
	uut : alu PORT MAP(
		A      => A,
		B      => B,
		Op     => Op,
		Output => Output,
		Zero   => Zero,
		Cout   => Cout,
		Ovf    => Ovf);
	stimulus : PROCESS
	BEGIN
		--checking every case with two +ve nums
		A  <= positiveNum1;
		B  <= positiveNum2;
		Op <= "0000";
		WAIT FOR 10 ns;
		Op <= "0001";
		WAIT FOR 10 ns;
		Op <= "0010";
		WAIT FOR 10 ns;
		Op <= "0011";
		WAIT FOR 10 ns;
		Op <= "0100";
		WAIT FOR 10 ns;
		Op <= "1000";
		WAIT FOR 10 ns;
		Op <= "1001";
		WAIT FOR 10 ns;
		Op <= "1010";
		WAIT FOR 10 ns;
		Op <= "1100";
		WAIT FOR 10 ns;
		Op <= "1101";
		WAIT FOR 10 ns;
		--from this point we only
		--check addition and substraction
		--checking for B -ve
		A  <= positiveNum1;
		B  <= negativeNum2;
		Op <= "0000";
		WAIT FOR 10 ns;
		Op <= "0001";
		WAIT FOR 10 ns;
		--checking for A -ve
		A  <= negativeNum1;
		B  <= positiveNum2;
		Op <= "0000";
		WAIT FOR 10 ns;
		Op <= "0001";
		WAIT FOR 10 ns;
		--checking for both -ve
		A  <= negativeNum1;
		B  <= negativeNum2;
		Op <= "0000";
		WAIT FOR 10 ns;
		Op <= "0001";
		WAIT FOR 10 ns;
		--checking zero flag by A+(-A) operation
		A  <= positiveNum1;
		B  <= negativeNum1;
		Op <= "0000";
		WAIT FOR 10 ns;
		--	 If 2 two's complement numbers are added,
		--	 and they both have the same sign (both
		--	 positive or both negative), then overflow
		--	 occurs if and only if the result has the
		--	 opposite sign. Overflow never occurs when
		--	 adding operands with different signs.

		-- forcing addition of two +ve
		-- numbers to result -ve
		A  <= x"7FFFFFFF";
		B  <= x"00000001";
		Op <= "0000";
		WAIT FOR 10 ns;
		-- forcing addition of two -ve
		-- numbers to result +ve
		A  <= x"80000000";
		B  <= x"FFFFFFFF";
		Op <= "0000";
		WAIT FOR 10 ns;
		--	  If 2 two's complement numbers are subtracted,
		--	  and their signs are different, then overflow
		--	  occurs if and only if the result has the
		--	  same sign as the subtrahend (second operand).

		-- forcing subtraction (+ve) - (-ve)
		-- to result -ve
		A  <= x"7FFFFFFF";
		B  <= x"FFFFFFFF";
		Op <= "0001";
		WAIT FOR 10 ns;
		-- forcing subtraction (-ve) - (+ve)
		-- to result +ve
		A  <= x"80000000";
		B  <= x"00000001";
		Op <= "0001";
		WAIT;
	END PROCESS;
END;
