LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux2to1 IS
    PORT (
        a      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
        b      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
        sele   : IN  STD_LOGIC;
        muxout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END mux2to1;

ARCHITECTURE Behavioral OF mux2to1 IS
BEGIN
    PROCESS (sele, a, b)
    BEGIN
        IF sele = '0' THEN
            muxout <= a;
        ELSE
            muxout <= b;
        END IF;
    END PROCESS;
END Behavioral;
