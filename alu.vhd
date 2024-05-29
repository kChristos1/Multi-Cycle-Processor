LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY alu IS
	PORT (
		A      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		B      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Op     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		Output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Zero   : OUT STD_LOGIC;
		Cout   : OUT STD_LOGIC;
		Ovf    : OUT STD_LOGIC
	);
END alu;

ARCHITECTURE Behavioral OF alu IS
	SIGNAL result32   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL tempZero   : STD_LOGIC;
	SIGNAL result33   : STD_LOGIC_VECTOR(32 DOWNTO 0); --keep the entire number with the carry_out and later isolate the carry_out digit
	SIGNAL tempOvf    : STD_LOGIC;
	SIGNAL tempCout   : STD_LOGIC;
	SIGNAL A_extended : STD_LOGIC_VECTOR(32 DOWNTO 0);
	SIGNAL B_extended : STD_LOGIC_VECTOR(32 DOWNTO 0);

BEGIN
	PROCESS (A, B, Op, tempCout, tempOvf, tempZero, result32, result33, A_extended, B_extended)
	BEGIN
		--sign extend the input signals
		A_extended <= A(31) & A;
		B_extended <= B(31) & B;
		tempCout   <= '0';
		CASE Op IS
				--addition
			WHEN "0000" =>
				result33 <= A_extended + B_extended; --sign extended inputs.
				--checking overflow of addition
				result32 <= result33(31 DOWNTO 0);
				IF ((A(31) = '0') AND (B(31) = '0') AND (result32(31) = '1'))
					OR ((A(31) = '1') AND (B(31) = '1') AND (result32(31) = '0')) THEN
					tempOvf <= '1';
				ELSE
					tempOvf <= '0';
				END IF;
				--carry out on/off
				tempCout <= result33(32);
				--subtraction
			WHEN "0001" =>
				result33 <= (A_extended) + ((NOT B_extended) + 1);
				result32 <= result33(31 DOWNTO 0);
				IF ((A(31) = '0') AND (B(31) = '1') AND (result32(31) = '1'))
					OR ((A(31) = '1') AND (B(31) = '0') AND (result32(31) = '0')) THEN
					tempOvf <= '1';
				ELSE
					tempOvf <= '0';
				END IF;
				--carry out on/off
				tempCout <= result33(32);
				--logic AND
			WHEN "0010" =>
				result32 <= A AND B;
				tempOvf  <= '0';
				--logic OR
			WHEN "0011" =>
				result32 <= A OR B;
				tempOvf  <= '0';
				--logic NOT
			WHEN "0100" =>
				result32 <= NOT A;
				tempOvf  <= '0';
				--shift RIGHT ARITHMETIC
			WHEN "1000" =>
				result32(31)          <= A(31); --copy MSB
				result32(30 DOWNTO 0) <= A(31 DOWNTO 1); --shift the rest 31 bits
				tempOvf               <= '0';
				--shift RIGHT LOGIC
			WHEN "1001" =>
				result32(31)          <= '0'; --in right logic shift MSB = '0'
				result32(30 DOWNTO 0) <= A(31 DOWNTO 1);
				tempOvf               <= '0';
				--shit LEFT LOGIC
			WHEN "1010" =>
				result32(31 DOWNTO 1) <= A(30 DOWNTO 0);
				result32(0)           <= '0'; --in left logic shift LSB = '0'
				tempOvf               <= '0';
				--left rotate
			WHEN "1100" =>
				result32(31 DOWNTO 1) <= A(30 DOWNTO 0);
				result32(0)           <= A(31);
				tempOvf               <= '0';
				--right rotate
			WHEN "1101" =>
				result32(30 DOWNTO 0) <= A(31 DOWNTO 1);
				result32(31)          <= A(0);
				tempOvf               <= '0';
			WHEN OTHERS =>
				result32 <= (OTHERS => '0');
				result33 <= (OTHERS => '0');
		END CASE;
		--activate "Zero" when circuit's result is zero
		IF (result32 = x"00000000") THEN
			tempZero <= '1';
		ELSE
			tempZero <= '0';
		END IF;
		--results:
		Output <= result32;
		Cout   <= tempCout;
		Ovf    <= tempOvf;
		Zero   <= tempZero;
	END PROCESS;
END Behavioral;
