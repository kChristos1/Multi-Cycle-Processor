LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY REG IS
    PORT (
        reg_clk : IN  STD_LOGIC;
        Data    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        Dout    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        WE      : IN  STD_LOGIC;
        reset   : IN  STD_LOGIC
    );
END REG;

ARCHITECTURE behavioral OF REG IS
    SIGNAL tempOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    PROCESS
    BEGIN
        WAIT UNTIL reg_clk'event AND reg_clk = '1';
        --reset "ON"
        IF reset = '1' THEN
            tempOut <= (OTHERS => '0');
            --reset "OFF" ('0')
        ELSE
            IF WE = '1' THEN
                tempOut <= Data;
            ELSE
                tempOut <= tempOut;
            END IF;
        END IF;
    END PROCESS;
    Dout <= tempOut;
END behavioral;
