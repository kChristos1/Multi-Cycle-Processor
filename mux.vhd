LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.array_pack.ALL;

ENTITY mux IS
    PORT (
        Input  : IN  array_32;
        Sel    : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
        Output : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END mux;

ARCHITECTURE Behavioral OF mux IS
    SIGNAL tempOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    PROCESS (Input, Sel, tempOut)
    BEGIN
        tempOut <= Input(to_integer(unsigned(Sel)));
    END PROCESS;
    Output <= tempOut;
END Behavioral;
