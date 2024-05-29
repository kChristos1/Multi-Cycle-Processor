LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.array_pack.ALL;

ENTITY decoder IS
    PORT (
        Input  : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
        Output : OUT array_1
    );
END decoder;

ARCHITECTURE Behavioral OF decoder IS
    SIGNAL tempOut : array_1;
BEGIN
    decode :
    FOR i IN 0 TO 31 GENERATE
        tempOut(i) <= '1' WHEN to_integer(unsigned(Input)) = i ELSE
        '0'; --! slay
    END GENERATE;
    Output <= tempOut;
END Behavioral;
