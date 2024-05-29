LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.array_pack.ALL;

ENTITY compare_module_tb IS
END compare_module_tb;

ARCHITECTURE behavior OF compare_module_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT compare_module
        PORT (
            cmp1       : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            cmp2       : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            cmp_result : OUT STD_LOGIC
        );
    END COMPONENT;
    --Inputs
    SIGNAL cmp1       : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL cmp2       : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    --Outputs
    SIGNAL cmp_result : STD_LOGIC;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : compare_module PORT MAP(
        cmp1       => cmp1,
        cmp2       => cmp2,
        cmp_result => cmp_result
    );
    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        cmp1 <= "00000";
        cmp2 <= "00000";
        WAIT FOR 10 ns;

        cmp1 <= "00001";
        cmp2 <= "00000";
        WAIT FOR 10 ns;
        
    END PROCESS;
END;
