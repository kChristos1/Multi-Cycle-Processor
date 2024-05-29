LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY conversion_unit_tb IS
END conversion_unit_tb;

ARCHITECTURE behavior OF conversion_unit_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT conversion_unit
        PORT (
            Input : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            Immed : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            cond  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;
    --Inputs
    SIGNAL Input : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL cond  : STD_LOGIC_VECTOR(1 DOWNTO 0);
    --Outputs
    SIGNAL Immed : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : conversion_unit PORT MAP(
        Input => Input,
        Immed => Immed,
        cond  => cond
    );
    stim_proc : PROCESS
    BEGIN
        Input <= "1111000001110011";
        
        cond  <= "00";
        WAIT FOR 100 ns;

        cond <= "01";
        WAIT FOR 100 ns;

        cond <= "10";
        WAIT FOR 100 ns;

        cond <= "11";
        WAIT FOR 100 ns;
    END PROCESS;
END;
