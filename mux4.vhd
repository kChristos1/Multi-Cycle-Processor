LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux4 IS
    PORT (
        a      : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
        b      : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
        sele   : IN  STD_LOGIC;
        muxout : OUT STD_LOGIC_VECTOR (4 DOWNTO 0));
END mux4;

ARCHITECTURE Behavioral OF mux4 IS
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
