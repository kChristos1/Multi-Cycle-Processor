LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY compare_module IS
	PORT (
		cmp1       : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
		cmp2       : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
		cmp_result : OUT STD_LOGIC);
END compare_module;

ARCHITECTURE Behavioral OF compare_module IS
BEGIN
	PROCESS (cmp1, cmp2)
	BEGIN
		IF cmp1 = cmp2 THEN
			cmp_result <= '1';
		ELSE
			cmp_result <= '0';
		END IF;
	END PROCESS;
END Behavioral;
