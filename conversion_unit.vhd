LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY conversion_unit IS
	PORT (
		Input : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		Immed : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		cond  : IN  STD_LOGIC_VECTOR (1 DOWNTO 0) -- input used to determine cases of operation
	);
END conversion_unit;

ARCHITECTURE Behavioral OF conversion_unit IS
	--inbetween signal
	SIGNAL temp_res : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
	PROCESS (cond, Input)
	BEGIN
		-- zerofill
		IF cond = "00" THEN 
			temp_res(31 DOWNTO 16) <= x"0000";
			temp_res(15 DOWNTO 0)  <= Input(15 DOWNTO 0);
		-- sign extend
		ELSIF cond = "01" THEN 
			FOR i IN 16 TO 31 LOOP
				temp_res(i) <= Input(15);
			END LOOP;
			temp_res(15 DOWNTO 0) <= Input(15 DOWNTO 0);
		-- sign extend and shift by 2
		ELSIF cond = "10" THEN                   
			temp_res(1 DOWNTO 0)  <= "00";
			temp_res(17 DOWNTO 2) <= Input(15 DOWNTO 0);
			FOR i IN 18 TO 31 LOOP
				temp_res(i) <= Input(15);
			END LOOP;
		-- shift by 16 and zerofill
		ELSIF cond = "11" THEN 
			temp_res(31 DOWNTO 16) <= Input(15 DOWNTO 0);
			temp_res(15 DOWNTO 0)  <= "0000000000000000";
		ELSE
			temp_res <= (OTHERS => '0');
		END IF;
	END PROCESS;
	Immed <= temp_res;
END Behavioral;
