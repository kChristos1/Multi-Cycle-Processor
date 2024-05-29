LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.array_pack.ALL;

ENTITY decoder_tb IS
END decoder_tb;

ARCHITECTURE behavior OF decoder_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT decoder
        PORT (
            Input  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            Output : OUT array_1
        );
    END COMPONENT;
    --Inputs
    SIGNAL Input  : STD_LOGIC_VECTOR(4 DOWNTO 0);
    --Outputs
    SIGNAL Output : array_1;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : decoder PORT MAP(
        Input  => Input,
        Output => Output
    );
    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        --initialize input with some random values
        FOR i IN 0 TO 4 LOOP
            Input <= "00000" + i;
            WAIT FOR 10 ns;
        END LOOP;
    END PROCESS;
END;
