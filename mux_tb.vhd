LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.array_pack.ALL;

ENTITY mux_tb IS
END mux_tb;

ARCHITECTURE behavior OF mux_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT mux
        PORT (
            Input  : IN  array_32;
            Sel    : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            Output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    --Inputs
    SIGNAL Input  : array_32;
    SIGNAL Sel    : STD_LOGIC_VECTOR(4 DOWNTO 0);
    --Outputs
    SIGNAL Output : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : mux PORT MAP(
        Input  => Input,
        Sel    => Sel,
        Output => Output
    );
    stimulus : PROCESS
    BEGIN
        --initialize input array using a for loop instruction
        FOR i IN 0 TO 31 LOOP
            Input(i) <= "00000000000000000000000000000000" + i;
        END LOOP;
        
        --set some random values for select signal:
        FOR i IN 0 TO 4 LOOP
            Sel <= "00000" + i;
            WAIT FOR 10 ns;
        END LOOP;
    END PROCESS;
END;
